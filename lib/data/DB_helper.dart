import 'package:ecommerce/model/currentUser.dart'; 
import 'package:ecommerce/model/product.dart'; 
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../controller/controller.dart';
import '../model/cart.dart';
import '../model/order.dart';


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
    return openDatabase(join(await getDatabasesPath(), "project4.db"),
        onCreate: (db, version) {
      db.execute(
          'CREATE TABLE users(id INTEGER PRIMARY KEY AUTOINCREMENT, username TEXT, email TEXT UNIQUE, password TEXT, phone TEXT, avatarUrl TEXT, emailAddress TEXT, role TEXT DEFAULT "user")');
      db.execute(
          'CREATE TABLE cart (productId INTEGER NOT NULL, quantity INTEGER NOT NULL, price REAL NOT NULL, userId INTEGER NOT NULL, count INTEGER DEFAULT 0, FOREIGN KEY(userId) REFERENCES users(id) ON DELETE CASCADE)');
      db.execute(
          'CREATE TABLE Address(id INTEGER PRIMARY KEY, address TEXT, isDefault INTEGER, userId INTEGER, FOREIGN KEY(userId) REFERENCES users(id) ON DELETE CASCADE)');
      db.execute(
        'CREATE TABLE orders ('
        'orderId INTEGER PRIMARY KEY AUTOINCREMENT, '
        'userId INTEGER , '
        'amount REAL, '
        'address TEXT, '
        'status TEXT DEFAULT "Processing", '
        'date TEXT)',
      );
      db.execute('''
  CREATE TABLE OrderItems (
    id INTEGER PRIMARY KEY,
    orderId INTEGER,
    productName TEXT,
    quantity INTEGER,
    price REAL,
    FOREIGN KEY(orderId) REFERENCES Orders(id)
  )
''');
      // Tạo tài khoản admin
      db.insert(
        'users',
        {
          'username': 'admin',
          'email': 'admin@gmail.com',
          'emailAddress': 'admin@gmail.com',
          'password': 'admin',
          'role': 'admin',
        },
        conflictAlgorithm: ConflictAlgorithm.ignore,
      );
    }, version: 1);
  }

  // 1
  //sign up
  Future<void> createUser(String username, String email, String password,
      {String? avatarUrl, String role = 'user'}) async {
    final db = await database;
    await db.insert(
      'users',
      {
        'username': username,
        'email': email,
        'emailAddress': email,
        'password': password,
        'avatarUrl': avatarUrl,
        'role': role, // Assign the role during user creation
      },
      conflictAlgorithm: ConflictAlgorithm.ignore,
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
  // Cart Functions
  Future<int> addCart(Cart cart, int userId) async {
    final db = await database;
    print(
        'Adding to cart: ${cart.product.id}, quantity: ${cart.quantity.value}, userId: $userId');
    final result = await db.insert('cart', {
      'productId': cart.product.id,
      'quantity': cart.quantity.value,
      'price': cart.price,
      'userId': userId,
      'count': cart.count,
    });
    print(
        'Inserted cart item with productId: ${cart.product.id}, userId: $userId');
    return result;
  }

  Future<List<Cart>> getCart(int userId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps =
        await db.query('cart', where: 'userId = ?', whereArgs: [userId]);

    print('Retrieved ${maps.length} cart items for userId: $userId');

    return List.generate(maps.length, (i) {
      return Cart.fromMap(maps[i]);
    });
  }

  Future<int> updateCart(Cart cart, int userId) async {
    final db = await database;
    return await db.update(
        'cart',
        {
          'quantity': cart.quantity.value,
          'price': cart.price,
          'count': cart.count,
        },
        where: 'productId = ? AND userId = ?',
        whereArgs: [cart.product.id, userId]);
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

  Future<void> updateOrderStatus(int orderId, String newStatus) async {
    final db = await database;
    await db.update(
      'orders',
      {'status': newStatus},
      where: 'orderId = ?',
      whereArgs: [orderId],
    );
  }

  Future<void> insertOrder(OrderModel order) async {
    final db = await _initDatabase();
    await db.insert(
      'orders',
      order.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Giả sử bạn có phương thức getOrders() như sau:
  Future<List<OrderModel>> getOrders() async {
    final db = await database;
    var res = await db.query("orders");

    List<OrderModel> list =
        res.map((item) => OrderModel.fromMap(item)).toList();
    return list;
  }

  Future<List<OrderModel>> getOrdersByUserId(int userId) async {
    final db = await database;
    var res = await db.query(
      "orders",
      where: "userId = ?",
      whereArgs: [userId],
    );
    List<OrderModel> orderList =
        res.map((item) => OrderModel.fromMap(item)).toList();
    print(
        "Total orders for userId $userId: ${orderList.length}");
    return orderList;
  }
   Future<List<OrderModel>> getOrdersByUser() async {
    final db = await database;
    var res = await db.query(
      "orders",      
    );
    List<OrderModel> orderList =
        res.map((item) => OrderModel.fromMap(item)).toList();
    return orderList;
  }

  // Future<void> updateOrder(OrderModel order) async {
  //   final db = await _initDatabase();
  //   await db.update(
  //     'orders',
  //     order.toMap(),
  //     where: 'orderId = ?',
  //     whereArgs: [order.orderId],
  //   );
  // }

  // Future<void> deleteOrder(int orderId) async {
  //   final db = await _initDatabase();
  //   await db.delete(
  //     'orders',
  //     where: 'orderId = ?',
  //     whereArgs: [orderId],
  //   );
  // }

  // Future<List<OrderItem>> getOrderItemsByOrderId(int orderId) async {
  //   final db = await database;
  //   final result = await db.query(
  //     'OrderItems',
  //     where: 'orderId = ?',
  //     whereArgs: [orderId],
  //   );

  //   return result.map((e) => OrderItem.fromMap(e)).toList();
  // }
  Future<void> insertOrderItem(OrderItem orderItem) async {
    final db = await database;
    await db.insert(
      'OrderItems',
      orderItem.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
}
