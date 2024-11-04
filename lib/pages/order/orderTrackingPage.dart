import 'package:ecommerce/model/order.dart';
import 'package:flutter/material.dart';

import '../../data/DB_helper.dart';

class OrderTrackingPage extends StatelessWidget {
  final int orderId;

  const OrderTrackingPage({super.key, required this.orderId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Theo dõi đơn hàng')),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: DatabaseHelper.dataService.getOrderStatusTimeline(orderId),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final statusTimeline = snapshot.data!;
          return ListView.builder(
            itemCount: statusTimeline.length,
            itemBuilder: (context, index) {
              final status =
                  OrderStatusModel.fromJson(statusTimeline[index]);
              return ListTile(
                title: Text(status.status),
                subtitle: Text(status.timestamp),
              );
            },
          );
        },
      ),
    );
  }
}
