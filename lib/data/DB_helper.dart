import 'package:ecommerce/model/currentUser.dart'; // Import CurrentUser model
import 'package:ecommerce/model/product.dart'; // Import Product model
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../controller/controller.dart';
import '../model/cart.dart';

class DatabaseHelper {
  static final DatabaseHelper dataService = DatabaseHelper._internal();
  factory DatabaseHelper() => dataService;
  DatabaseHelper._internal();
  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    return openDatabase(join(await getDatabasesPath(), "fashion.db"),
        onCreate: (db, version) {
      db.execute(
          'CREATE TABLE users(id INTEGER PRIMARY KEY AUTOINCREMENT, username TEXT, email TEXT UNIQUE, password TEXT, phone TEXT, avatarUrl TEXT, emailAddress TEXT)');
      db.execute(
          'CREATE TABLE cart (productId INTEGER NOT NULL, quantity INTEGER NOT NULL, price REAL NOT NULL, userId INTEGER NOT NULL, count INTEGER DEFAULT 0, FOREIGN KEY(userId) REFERENCES users(id) ON DELETE CASCADE)');
      db.execute(
          'CREATE TABLE Address(id INTEGER PRIMARY KEY, address TEXT, isDefault INTEGER, userId INTEGER, FOREIGN KEY(userId) REFERENCES users(id) ON DELETE CASCADE)');
      db.execute(
          'CREATE TABLE orders (id INTEGER PRIMARY KEY AUTOINCREMENT, userId INTEGER, date TEXT, total REAL, status TEXT, FOREIGN KEY(userId) REFERENCES users(id) ON DELETE CASCADE)');
      db.execute(
          'CREATE TABLE order_status (orderId INTEGER, status TEXT, timestamp TEXT, FOREIGN KEY(orderId) REFERENCES orders(id) ON DELETE CASCADE)');
    }, version: 1);
  }

  // 1
  //sign up
  Future<void> createUser(String username, String email, String password,
      {String? avatarUrl}) async {
    final db = await database;
    await db.insert(
      'users',
      {
        'username': username,
        'email': email,
        'emailAddress': email,
        'password': password,
        'avatarUrl': avatarUrl
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Get user by email
  //sign in
  Future<List<Map<String, dynamic>>> getUser(String email) async {
    final db = await database;
    final result = await db.query(
      'users',
      where: 'email = ?',
      whereArgs: [email],
    );

    return result.isNotEmpty ? result : [];
  }

  //2
    Future<int> addCart(Cart cart, int userId) async {
    final db = await database;
    return await db.insert('cart', {
      'productId': cart.product.id,
      'quantity': cart.quantity.value,
      'price': cart.price,
      'userId': userId,
      'count': cart.count,
    });
  }

  Future<List<Cart>> getCart(int userId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('cart',
        where: 'userId = ?', whereArgs: [userId]);

    return List.generate(maps.length, (i) {
      return Cart.fromMap(maps[i]);
    });
  }

  Future<int> updateCart(Cart cart, int userId) async {
    final db = await database;
    return await db.update('cart', {
      'quantity': cart.quantity.value,
      'price': cart.price,
      'count': cart.count,
    }, where: 'productId = ? AND userId = ?', whereArgs: [cart.product.id, userId]);
  }

  Future<int> deleteCart(int productId, int userId) async {
    final db = await database;
    return await db.delete('cart',
        where: 'productId = ? AND userId = ?', whereArgs: [productId, userId]);
  }

  Future<void> clearCart(int userId) async {
    final db = await database;
    await db.delete('cart', where: 'userId = ?', whereArgs: [userId]);
  }

//3
//account
  // Password Complexity Check
  bool _isPasswordValid(String password) {
    final passwordRegExp =
        RegExp(r'^(?=.*[A-Za-z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$');
    return passwordRegExp.hasMatch(password);
  }

  // Change Password
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {
    final db = await database;

    if (!_isPasswordValid(newPassword)) {
      throw Exception(
          "Mật khẩu mới phải dài ít nhất 8 ký tự, bao gồm chữ cái, số và ký tự đặc biệt.");
    }

    if (newPassword != confirmPassword) {
      throw Exception("Mật khẩu mới và xác nhận không khớp.");
    }

    final userResult = await db.query(
      'users',
      where: 'id = ? AND password = ?',
      whereArgs: [CurrentUser().id, currentPassword],
    );

    if (userResult.isEmpty) {
      throw Exception("Mật khẩu hiện tại không đúng.");
    }

    await db.update(
      'users',
      {'password': newPassword},
      where: 'id = ?',
      whereArgs: [CurrentUser().id],
    );
  }

  Future<void> deleteUserAccountWithPassword(String password) async {
    final db = await database;
    final userResult = await db.query(
      'users',
      where: 'id = ? AND password = ?',
      whereArgs: [CurrentUser().id, password],
    );

    if (userResult.isEmpty) {
      throw Exception("Mật khẩu không đúng.");
    }

    await db.delete(
      'users',
      where: 'id = ?',
      whereArgs: [CurrentUser().id],
    );
  }

  Future<void> saveUser(Map<String, dynamic> user) async {
    final db = await database;
    await db.insert('Users', user,
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

//4
//profile
  Future<void> updateUser(int userId, Map<String, dynamic> userData) async {
    final db = await database;
    await db.update(
      'users',
      userData,
      where: 'id = ?',
      whereArgs: [userId],
    );
  }

  Future<Map<String, dynamic>?> getProfile() async {
    final db = await database;
    List<Map<String, dynamic>> users = await db.query('users', limit: 1);
    return users.isNotEmpty ? users.first : null;
  }

  // Get user by ID profile
  Future<List<Map<String, dynamic>>> getUserById(int userId) async {
    final db = await database;
    final result = await db.query(
      'users',
      where: 'id = ?',
      whereArgs: [userId],
    );

    return result.isNotEmpty ? result : [];
  }

//5
// Update user avatar
  Future<void> updateUserAvatar(int userId, String avatarUrl) async {
    final db = await database;
    await db.update(
      'users',
      {'avatarUrl': avatarUrl},
      where: 'id = ?',
      whereArgs: [userId],
    );
  }

  // 6
  // Add or update address with user ID
  Future<void> addOrUpdateAddress(Map<String, dynamic> address,
      {required bool setAsDefault}) async {
    final db = await database;
    int userId = CurrentUser().id!;
    address['userId'] = userId;
    if (setAsDefault) {
      await db.update(
        'Address',
        {'isDefault': 0},
        where: 'userId = ?',
        whereArgs: [userId],
      );
    }
    await db.insert(
      'Address',
      address,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<Map<String, dynamic>?> getDefaultAddress(int userId) async {
    final db = await database;
    List<Map<String, dynamic>> result = await db.query('Address',
        where: 'userId = ? AND isDefault = ?', whereArgs: [userId, 1]);

    if (result.isNotEmpty) {
      return result.first;
    }
    return null;
  }

  // Set a specific address as default
  Future<void> setDefaultAddress(int id) async {
    final db = await database;
    await db.update('Address', {'isDefault': 0});
    await db.update(
      'Address',
      {'isDefault': 1},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Edit an existing address
  Future<void> updateAddress(int id, Map<String, dynamic> address) async {
    final db = await database;
    await db.update(
      'Address',
      address,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Delete an address
  Future<void> deleteAddress(int id) async {
    final db = await database;
    await db.delete('Address', where: 'id = ?', whereArgs: [id]);

    final defaultAddress = await getDefaultAddress(CurrentUser().id!);
    if (defaultAddress == null) {
      List<Map<String, dynamic>> remainingAddresses = await getAddresses();
      if (remainingAddresses.isNotEmpty) {
        await setDefaultAddress(remainingAddresses.first['id']);
      }
    }
  }

  // Fetch all addresses
  Future<List<Map<String, dynamic>>> getAddresses() async {
    final db = await database;
    return await db.query('Address');
  }

  // Fetch all addresses for the current user
  Future<List<Map<String, dynamic>>> getUserAddresses(int userId) async {
    final db = await database;
    return await db.query(
      'Address',
      where: 'userId = ?',
      whereArgs: [userId],
    );
  }

  // 7. Quản lý Lịch Sử Đơn Hàng
  // Future<void> addOrderHistory(
  //     int userId, String orderDate, String status) async {
  //   final db = await database;
  //   await db.insert(
  //     'OrderHistory',
  //     {
  //       'userId': userId,
  //       'orderDate': orderDate,
  //       'status': status,
  //     },
  //     conflictAlgorithm: ConflictAlgorithm.replace,
  //   );
  // }

  // // Lấy lịch sử đơn hàng của người dùng
  // Future<List<Map<String, dynamic>>> getOrderHistory(int userId) async {
  //   final db = await database;
  //   return await db.query(
  //     'OrderHistory',
  //     where: 'userId = ?',
  //     whereArgs: [userId],
  //     orderBy: 'orderDate DESC',
  //   );
  // }

  // // Cập nhật trạng thái đơn hàng
  // Future<void> updateOrderStatus(int orderId, String status) async {
  //   final db = await database;
  //   await db.update(
  //     'OrderHistory',
  //     {'status': status},
  //     where: 'id = ?',
  //     whereArgs: [orderId],
  //   );
  // }

  // 8. Quản lý Tùy Chọn Thông Báo
  Future<void> setNotificationSettings(int userId,
      {bool? orderNotification, bool? promotionNotification}) async {
    final db = await database;
    await db.insert(
      'NotificationSettings',
      {
        'userId': userId,
        'orderNotification': orderNotification == true ? 1 : 0,
        'promotionNotification': promotionNotification == true ? 1 : 0,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Lấy trạng thái thông báo của người dùng
  Future<Map<String, dynamic>?> getNotificationSettings(int userId) async {
    final db = await database;
    List<Map<String, dynamic>> result = await db.query(
      'NotificationSettings',
      where: 'userId = ?',
      whereArgs: [userId],
      limit: 1,
    );
    return result.isNotEmpty ? result.first : null;
  }

  // Cập nhật tùy chọn thông báo
  Future<void> updateNotificationSettings(int userId,
      {bool? orderNotification, bool? promotionNotification}) async {
    final db = await database;
    Map<String, dynamic> updateData = {};
    if (orderNotification != null) {
      updateData['orderNotification'] = orderNotification ? 1 : 0;
    }
    if (promotionNotification != null) {
      updateData['promotionNotification'] = promotionNotification ? 1 : 0;
    }
    await db.update(
      'NotificationSettings',
      updateData,
      where: 'userId = ?',
      whereArgs: [userId],
    );
  }

//9 order
  Future<void> createOrder(int userId, double total) async {
    final db = await database;
    await db.insert(
      'orders',
      {
        'userId': userId,
        'date': DateTime.now().toIso8601String(),
        'total': total,
        'status': 'Đang xử lý',
      },
    );
  }

  Future<void> updateOrderStatus(int orderId, String status) async {
    final db = await database;
    await db.update(
      'orders',
      {'status': status},
      where: 'id = ?',
      whereArgs: [orderId],
    );
    await db.insert(
      'order_status',
      {
        'orderId': orderId,
        'status': status,
        'timestamp': DateTime.now().toIso8601String(),
      },
    );
  }

  Future<List<Map<String, dynamic>>> getUserOrderHistory(int userId) async {
    final db = await database;
    return await db.query(
      'orders',
      where: 'userId = ?',
      whereArgs: [userId],
    );
  }
  Future<List<Map<String, dynamic>>> getOrderStatusTimeline(int orderId) async {
    final db = await database;
    return await db.query(
      'order_status',
      where: 'orderId = ?',
      whereArgs: [orderId],
      orderBy: 'timestamp ASC',
    );
}
 // Thêm đơn hàng vào bảng 'orders'
  Future<int> insertOrder({required int userId, required double totalAmount, required String status}) async {
    final db = await database;
    return await db.insert('orders', {
      'userId': userId,
      'totalAmount': totalAmount,
      'status': status,
      'orderDate': DateTime.now().toIso8601String(),
    });
  }

  // Thêm sản phẩm của đơn hàng vào bảng 'order_items'
  Future<void> insertOrderItem({required int orderId, required int productId, required int quantity, required double price}) async {
    final db = await database;
    await db.insert('order_items', {
      'orderId': orderId,
      'productId': productId,
      'quantity': quantity,
      'price': price,
    });
  }

  // Lấy danh sách đơn hàng của người dùng
  Future<List<Map<String, dynamic>>> getOrdersByUser(int userId) async {
    final db = await database;
    return await db.query(
      'orders',
      where: 'userId = ?',
      whereArgs: [userId],
      orderBy: 'orderDate DESC',
    );
  }
}
