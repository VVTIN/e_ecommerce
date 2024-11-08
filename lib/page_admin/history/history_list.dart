import 'package:ecommerce/data/DB_helper.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../config/const.dart';
import '../../model/order.dart';

class HistoryList extends StatefulWidget {
  const HistoryList({super.key});

  @override
  State<HistoryList> createState() => _HistoryListState();
}

class _HistoryListState extends State<HistoryList> {
  Future<void> _showOrderDetails(OrderModel order) async {
    final List<String> orderStatuses = [
      'Đang xử lí',
      'Xử lí',
      'Đang giao',
      'Đã giao'
    ];

    await showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Container(
          width: double.infinity,
          height: MediaQuery.of(context).size.height * 0.4,
          decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/images/bg1.jpg'),
                  fit: BoxFit.cover),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15),
                topRight: Radius.circular(15),
              )),
          child: StatefulBuilder(
            builder: (BuildContext context, StateSetter setModalState) {
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: const Text(
                        'Chi tiết đơn hàng',
                        style:
                            TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                        'Ngày đặt: ${DateFormat('dd/MM/yyyy').format(order.date)}',
                        style: const TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 18)),
                    const SizedBox(height: 10),
                    Text(
                        'Tổng tiền: ${NumberFormat.currency(locale: 'vi_VN', symbol: '', decimalDigits: 0).format(order.amount)} VND',
                        style: const TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 18)),
                    const SizedBox(height: 10),
                    Text(
                      'Người dùng: ${order.userId}',
                      style:
                          const TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
                    ),
                   
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Trạng thái đơn hàng:',
                          style: TextStyle(
                              fontWeight: FontWeight.w500, fontSize: 18),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(width: 1, color: Colors.black),
                          ),
                          padding: const EdgeInsets.symmetric(
                              vertical: 4.0, horizontal: 16.0),
                          child: DropdownButton<String>(
                            value: order.status,
                            items: orderStatuses.map((String status) {
                              return DropdownMenuItem<String>(
                                value: status,
                                child: Text(status),
                              );
                            }).toList(),
                            onChanged: (String? newStatus) async {
                              if (newStatus != null &&
                                  newStatus != order.status) {
                                setModalState(() {
                                  order.status = newStatus;
                                });
                                setState(() {});

                                await DatabaseHelper().updateOrderStatus(
                                    order.orderId, newStatus);
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Danh sách đơn hàng',
          style: TextStyle(
              fontSize: 24, color: Colors.white, fontWeight: FontWeight.w500),
        ),
        backgroundColor: Colors.blue,
        automaticallyImplyLeading: false,
      ),
      body: FutureBuilder<List<OrderModel>>(
        future: DatabaseHelper().getOrdersByUser(),
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
                final totalAmount = NumberFormat.currency(
                  locale: 'vi_VN',
                  symbol: '',
                  decimalDigits: 0,
                ).format(order.amount);

                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6.0),
                  child: Container(
                    padding: const EdgeInsets.all(12.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(width: 1, color: Colors.black),
                    ),
                    child: ListTile(
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Đơn hàng ',
                            style: TextStyle(
                                fontSize: 22, fontWeight: FontWeight.w600),
                          ),
                          Text('$formattedDate'),
                        ],
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Tổng tiền : ${totalAmount} VND'),
                              Text('TT: ${order.status}'),
                            ],
                          ),
                          Text('Người dùng : ${order.userId}'),
                        ],
                      ),
                      onTap: () => _showOrderDetails(order),
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
