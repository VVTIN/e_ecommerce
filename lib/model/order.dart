class OrderModel {
  final int orderId;
  final int userId;
  final double amount;
  final String address;
  String status;
  final DateTime date; // Change this to DateTime instead of String

  OrderModel({

    required this.orderId,
    required this.userId,
    required this.amount,
    required this.address,
    this.status = 'Processing',
    required this.date,
  });

  factory OrderModel.fromMap(Map<String, dynamic> json) {
    return OrderModel(
      orderId: json['orderId'],
      userId: json['userId'],
      amount: json['amount'],
      address: json['address'],
      status: json['status'] ?? 'Processing',
      date: DateTime.parse(json['date']), // Parse date string to DateTime
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'orderId': orderId,
      'userId': userId,
      'amount': amount,
      'address': address,
      'status': status,
      'date': date.toIso8601String(), // Convert DateTime to ISO string
    };
  }
}
class OrderItem {
  final int id;
  final int orderId;
  final String productName;
  final int quantity;
  final double price;

  OrderItem({
    required this.id,
    required this.orderId,
    required this.productName,
    required this.quantity,
    required this.price,
  });

  // Hàm chuyển đổi từ Map (kết quả từ database) thành OrderItem
  factory OrderItem.fromMap(Map<String, dynamic> map) {
    return OrderItem(
      id: map['id'],
      orderId: map['orderId'],
      productName: map['productName'],
      quantity: map['quantity'],
      price: map['price'].toDouble(),
    );
  }

  // Hàm chuyển đổi từ OrderItem sang Map để lưu vào database (nếu cần)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'orderId': orderId,
      'productName': productName,
      'quantity': quantity,
      'price': price,
    };
  }
}
class CartItem {
  final int productId;
  final String productName;
  final double price;
  final int quantity;

  CartItem({
    required this.productId,
    required this.productName,
    required this.price,
    required this.quantity,
  });
}
