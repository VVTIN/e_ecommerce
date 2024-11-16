class OrderModel {
  final int? orderId;
  final int userId;
  final double amount;
  final String address;
  String status;
  final DateTime date; // Change this to DateTime instead of String
  final List<OrderItem> orderItems; // Add this field

  OrderModel({
    this.orderId,
    required this.userId,
    required this.amount,
    required this.address,
    this.status = 'Processing',
    required this.date,
    required this.orderItems, // Make sure orderItems is passed in the constructor
  });

  factory OrderModel.fromMap(Map<String, dynamic> json) {
    var orderItemsFromJson = json['orderItems'] as List?; 
    List<OrderItem> orderItemsList = [];
    if (orderItemsFromJson != null) {
      orderItemsList = orderItemsFromJson.map((item) => OrderItem.fromMap(item)).toList();
    }

    return OrderModel(
      orderId: json['orderId'],
      userId: json['userId'],
      amount: json['amount'],
      address: json['address'],
      status: json['status'] ?? 'Processing',
      date: DateTime.parse(json['date']),
      orderItems: orderItemsList, // Convert the JSON list to OrderItem list
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'orderId': orderId,
      'userId': userId,
      'amount': amount,
      'address': address,
      'status': status,
      'date': date.toIso8601String(),
      // Add orderItems to the map if you want to store them directly
    };
  }

  OrderModel copyWith({
    int? orderId,
    int? userId,
    double? amount,
    String? address,
    String? status,
    DateTime? date,
    List<OrderItem>? orderItems, // Add this to allow updating orderItems in copyWith
  }) {
    return OrderModel(
      orderId: orderId ?? this.orderId,
      userId: userId ?? this.userId,
      amount: amount ?? this.amount,
      address: address ?? this.address,
      status: status ?? this.status,
      date: date ?? this.date,
      orderItems: orderItems ?? this.orderItems, // Ensure this gets updated in copyWith
    );
  }
}

class OrderItem {
  final int id;         // This is the id of the OrderItem (primary key)
  final int orderId;    // This is the orderId (foreign key referring to orders table)
  final int productId;
  final int quantity;
  final double price;
  final double discount;

  OrderItem({
    required this.id,         // Primary key of the OrderItem
    required this.orderId,    // Foreign key linking to the orders table
    required this.productId,
    required this.quantity,
    required this.price,
    required this.discount,
  });

  factory OrderItem.fromMap(Map<String, dynamic> map) {
    return OrderItem(
      id: map['id'],           // Get id from database
      orderId: map['orderId'], // Get orderId from database
      productId: map['productId'],
      quantity: map['quantity'],
      price: map['price'],
      discount: map['discount'] ?? 0.0,  // Default discount to 0 if not provided
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,               // Insert id into database
      'orderId': orderId,     // Insert orderId into database
      'productId': productId,
      'quantity': quantity,
      'price': price,
      'discount': discount,
    };
  }

  OrderItem copyWith({
    int? id,
    int? productId,
    int? orderId,
    int? quantity,
    double? price,
    double? discount,
  }) {
    return OrderItem(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      orderId: orderId ?? this.orderId,
      quantity: quantity ?? this.quantity,
      price: price ?? this.price,
      discount: discount ?? this.discount,
    );
  }
}
class CartItem {
  final int productId;
  final String productName;
  final double price;
  final int quantity;
  final double discount; // Added discount field

  CartItem({
    required this.productId,
    required this.productName,
    required this.price,
    required this.quantity,
    this.discount = 0.0, // Default discount value is 0.0
  });

  // Method to calculate total price for the item, considering discount
  double get totalPrice {
    return (price - (price * discount / 100)) * quantity; // Adjust total price after discount
  }

  // Optional: toJson() method for database insertion
  Map<String, dynamic> toJson() {
    return {
      'productId': productId,
      'productName': productName,
      'price': price,
      'quantity': quantity,
      'discount': discount,
    };
  }
}
