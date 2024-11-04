import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:intl/intl.dart';

import '../../data/DB_helper.dart';

class OrderHistoryPage extends StatelessWidget {
  final int userId;

  OrderHistoryPage({required this.userId});

  Future<List<Map<String, dynamic>>> _fetchOrders() async {
    final dbHelper = DatabaseHelper.dataService;
    return await dbHelper.getOrdersByUser(userId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lịch sử đơn hàng'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _fetchOrders(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Không có đơn hàng nào'));
          } else {
            final orders = snapshot.data!;
            return ListView.builder(
              itemCount: orders.length,
              itemBuilder: (context, index) {
                final order = orders[index];
                return ListTile(
                  title: Text(
                    'Đơn hàng #${order['id']} - ${order['status']}',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    'Tổng tiền: ${NumberFormat('###,###,###').format(order['totalAmount'])} VND\nNgày đặt: ${order['orderDate']}',
                  ),
                  onTap: () {
                    // Thêm logic hiển thị chi tiết đơn hàng nếu cần
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}
