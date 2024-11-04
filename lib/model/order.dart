class OrderModel {
  final int id;
  final int userId;
  final String date;
  final double total;
  final String status;

  OrderModel({
    required this.id,
    required this.userId,
    required this.date,
    required this.total,
    required this.status,
  });

  factory OrderModel.fromJson(Map<String, dynamic> data) {
    return OrderModel(
      id: data['id'],
      userId: data['userId'],
      date: data['date'],
      total: data['total'],
      status: data['status'],
    );
  }
}

class OrderStatusModel {
  final String status;
  final String timestamp;

  OrderStatusModel({
    required this.status,
    required this.timestamp,
  });

  factory OrderStatusModel.fromJson(Map<String, dynamic> data) {
    return OrderStatusModel(
      status: data['status'],
      timestamp: data['timestamp'],
    );
  }
}
