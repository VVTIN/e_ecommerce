import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../controller/controller.dart';
import '../../data/DB_helper.dart';
import '../../model/order.dart';

class OrderHistoryPage extends StatefulWidget {
  final int userId;

  OrderHistoryPage({required this.userId});

  @override
  State<OrderHistoryPage> createState() => _OrderHistoryPageState();
}

class _OrderHistoryPageState extends State<OrderHistoryPage> {
  final DatabaseHelper dbHelper = DatabaseHelper();

  void _showOrderDetails(OrderModel order) {
    String formattedDate = DateFormat('dd/MM/yyyy').format(order.date);
    final totalAmount = NumberFormat.currency(
      locale: 'vi_VN',
      symbol: '',
      decimalDigits: 0,
    ).format(order.amount);
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(16.0),
          width: double.infinity,
          height: MediaQuery.of(context).size.height * 0.45,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Thông tin chi tiết đơn hàng',
                style: TextStyle(fontSize: 29, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 30),
              Text('Ngày đặt: $formattedDate',
                  style: const TextStyle(fontSize: 16)),
              const SizedBox(height: 10),
              Text('Địa chỉ: ${order.address}',
                  style: const TextStyle(fontSize: 16)),
              const SizedBox(height: 10),
              Text('Số tiền: ${totalAmount} VNĐ (Thanh toán)',
                  style: const TextStyle(fontSize: 16)),
              const SizedBox(height: 10),
              Text('Trạng thái: ${order.status}',
                  style: const TextStyle(fontSize: 16)),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

//option color for status
  Color _getStatusColor(String status) {
    switch (status) {
      case 'Đang xử lí':
        return Colors.orange;
      case 'Xử lí':
        return Colors.blue;
      case 'Đang giao':
        return Colors.purple;
      case 'Đã giao':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Lịch sử đơn hàng',
          style: TextStyle(
              fontSize: 22, fontWeight: FontWeight.w600, color: Colors.white),
        ),
        automaticallyImplyLeading: false,
      ),
      body: FutureBuilder<List<OrderModel>>(
        future: dbHelper.getOrdersByUserId(widget.userId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Lỗi: ${snapshot.error}'));
          }
          final orders = snapshot.data ?? [];
          if (orders.isEmpty) {
            return const Center(child: Text('Không có đơn hàng nào.'));
          }
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView.builder(
              itemCount: orders.length,
              itemBuilder: (context, index) {
                final order = orders[index];
                String formattedDate =
                    DateFormat('dd/MM/yyyy').format(order.date);

                final amount = NumberFormat.currency(
                  locale: 'vi_VN',
                  symbol: '',
                  decimalDigits: 0,
                ).format(order.amount);
             

                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6.0),
                  child: Container(
                  
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(width: 2, color: Colors.blue),
                    ),
                    child: ListTile(
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Đơn hàng ',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text('$formattedDate'),
                        ],
                      ),
                      subtitle: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Tổng tiền : ${amount} VND',
                            style: TextStyle(
                                color: const Color.fromARGB(255, 21, 84, 134)),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(width: 1, color: Colors.black),
                              color: _getStatusColor(order.status),
                            ),
                            padding: const EdgeInsets.symmetric(
                                vertical: 6.0, horizontal: 16.0),
                            child: Text(
                              'TT: ${order.status}',
                              style: TextStyle(color: Colors.white),
                            ),
                          )
                        ],
                      ),
                      onTap: () {
                        _showOrderDetails(order);
                      },
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
