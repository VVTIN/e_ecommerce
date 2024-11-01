import 'package:ecommerce/model/currentUser.dart'; // Import CurrentUser model
import 'package:ecommerce/model/product.dart'; // Import Product model
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

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
  }, version: 1); 
}


  // User Management account
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

  // Cart Management
  //add to cart
  Future<void> addToCart(int productId, int quantity, double price) async {
    final db = await database;
    if (CurrentUser().id == null) {
      throw Exception("User is not logged in. Cannot add to cart.");
    }

    // Kiểm tra tồn tại trong giỏ hàng
    var existingItem = await db.query(
      'cart',
      where: 'userId = ? AND productId = ?',
      whereArgs: [CurrentUser().id, productId],
    );

    if (existingItem.isNotEmpty) {
      // Cập nhật số lượng nếu sản phẩm đã tồn tại
      int existingQuantity =
          existingItem.first['quantity'] as int; // Ép kiểu về int
      await updateCart(productId, existingQuantity + quantity);
    } else {
      await db.insert(
        'cart',
        {
          'productId': productId,
          'quantity': quantity,
          'price': price,
          'userId': CurrentUser().id,
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
  }

  // Get the user's cart
  Future<List<Map<String, dynamic>>> getUserCart() async {
    final db = await database;
    final result = await db.query(
      'cart',
      where: 'userId = ?',
      whereArgs: [CurrentUser().id],
    );

    if (result.isEmpty) {
      print("No cart items found.");
      return [];
    }

    return result;
  }

  // Remove item from cart
  Future<void> removeFromCart(int productId) async {
    final db = await database;
    await db.delete(
      'cart',
      where: 'userId = ? AND productId = ?',
      whereArgs: [CurrentUser().id, productId],
    );
  }

  // Update item quantity in cart
  Future<void> updateCart(int productId, int quantity) async {
    final db = await database;
    await db.update(
      'cart',
      {'quantity': quantity},
      where: 'userId = ? AND productId = ?',
      whereArgs: [CurrentUser().id, productId],
    );
  }

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


  // Address Functions
  // Add or update address with user ID
  Future<void> addOrUpdateAddress(Map<String, dynamic> address, {required bool setAsDefault}) async {
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
    List<Map<String, dynamic>> result = await db.query(
      'Address', 
      where: 'userId = ? AND isDefault = ?', 
      whereArgs: [userId, 1]
    );
    
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

}
