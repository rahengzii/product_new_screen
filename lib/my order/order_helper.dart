// import 'package:ecom_practice/models/product_model.dart';
// import 'package:path/path.dart';
// import 'package:sqflite/sqflite.dart';

// class OrderSaver {
//   static Database? _database;

//   OrderSaver._();

//   static Future<Database> get database async {
//     if (_database != null) return _database!;
//     _database = await _initDatabase();
//     return _database!;
//   }

//   static Future<Database> _initDatabase() async {
//     String path = join(await getDatabasesPath(), 'orders_database6.db');
//     return await openDatabase(
//       path,
//       version: 3,
//       onCreate: (Database db, int version) async {
//         // Create orders table
//         await db.execute('''
//           CREATE TABLE orders(
//             id INTEGER PRIMARY KEY AUTOINCREMENT,
//             invoice_id TEXT NOT NULL,
//             date TEXT NOT NULL,
//             status TEXT NOT NULL
//           )
//         ''');

//         // Create order items table
//         await db.execute('''
//           CREATE TABLE order_items(
//             id INTEGER PRIMARY KEY AUTOINCREMENT,
//             invoice_id TEXT NOT NULL,
//             product_name TEXT NOT NULL,
//             description TEXT,
//             price REAL NOT NULL,
//             currency TEXT,
//             image_url TEXT,
//             price_sign TEXT,
//             selected_color TEXT,
//             quantity INTEGER NOT NULL,
//             address TEXT
//           )
//         ''');
//       },
//     );
//   }

//   // Save cart items as a new order
//   static Future<String> saveOrder(
//       List<ProductModel> cartItems, String address, String invoiceId) async {
//     final db = await database;

//     // Begin transaction
//     await db.transaction((txn) async {
//       // Insert order record
//       await txn.insert('orders', {
//         'invoice_id': invoiceId,
//         'date': DateTime.now().toIso8601String(),
//         'status': 'pending'
//       });

//       // Insert all cart items
//       for (var item in cartItems) {
//         await txn.insert('order_items', {
//           'invoice_id': invoiceId,
//           'product_name': item.name,
//           'description': item.description,
//           'price': item.price,
//           'currency': item.currency,
//           'image_url': item.imageUrl,
//           'price_sign': item.priceSign,
//           'selected_color': item.selectedColor,
//           'quantity': item.quantity,
//           'address': address,
//         });
//       }
//     });

//     return invoiceId;
//   }

//   // Get order details by invoice ID
//   static Future<Map<String, dynamic>> getOrder(String invoiceId) async {
//     final db = await database;

//     // Get order info
//     final List<Map<String, dynamic>> orderResult = await db.query(
//       'orders',
//       where: 'invoice_id = ?',
//       whereArgs: [invoiceId],
//     );

//     // Get order items
//     final List<Map<String, dynamic>> itemsResult = await db.query(
//       'order_items',
//       where: 'invoice_id = ?',
//       whereArgs: [invoiceId],
//     );

//     return {
//       'order': orderResult.first,
//       'items': itemsResult,
//     };
//   }

//   // Update order status
//   static Future<void> updateOrderStatus(
//       String invoiceId, String newStatus) async {
//     final db = await database;
//     await db.update(
//       'orders',
//       {'status': newStatus},
//       where: 'invoice_id = ?',
//       whereArgs: [invoiceId],
//     );
//   }

//   // Get all orders
//   static Future<List<Map<String, dynamic>>> getAllOrders() async {
//     final db = await database;
//     return await db.query('orders', orderBy: 'date DESC');
//   }

//   // Get items for a specific order
//   static Future<List<Map<String, dynamic>>> getOrderItems(
//       String invoiceId) async {
//     final db = await database;
//     return await db.query(
//       'order_items',
//       where: 'invoice_id = ?',
//       whereArgs: [invoiceId],
//     );
//   }

//   //delete order
//   static Future<void> deleteOrder(String invoiceId) async {
//     final db = await database;
//     await db.delete(
//       'orders',
//       where: 'invoice_id = ?',
//       whereArgs: [invoiceId],
//     );
//     await db.delete(
//       'order_items',
//       where: 'invoice_id = ?',
//       whereArgs: [invoiceId],
//     );
//   }
// }
import 'package:path/path.dart';
import 'package:product_new_screen/mainscreen.dart';
import 'package:sqflite/sqflite.dart';

class OrderSaver {
  static Database? _database;

  OrderSaver._();

  static Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  static Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'orders2.db');
    return await openDatabase(
      path,
      version: 4, // Increment version number
      onCreate: (Database db, int version) async {
        // Create orders table
        await db.execute('''
          CREATE TABLE orders(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            user_id INTEGER NOT NULL,
            invoice_id TEXT NOT NULL,
            date TEXT NOT NULL,
            status TEXT NOT NULL
          )
        ''');

        // Create order items table
        await db.execute('''
          CREATE TABLE order_items(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            user_id INTEGER NOT NULL,
            invoice_id TEXT NOT NULL,
            product_name TEXT NOT NULL,
            description TEXT,
            price REAL NOT NULL,
            currency TEXT,
            image_url TEXT,
            price_sign TEXT,
            selected_color TEXT,
            quantity INTEGER NOT NULL,
            address TEXT
          )
        ''');
      },
      onUpgrade: (Database db, int oldVersion, int newVersion) async {
        if (oldVersion < 4) {
          // Upgrade logic for version 4
          await db.execute(
              'ALTER TABLE orders ADD COLUMN user_id TEXT NOT NULL DEFAULT ""');
          await db.execute(
              'ALTER TABLE order_items ADD COLUMN user_id TEXT NOT NULL DEFAULT ""');
        }
      },
    );
  }

  // Save cart items as a new order
  static Future<void> saveOrder(List<Product> cartItems, String address,
      String invoiceId, int userId) async {
    final db = await database;

    // Begin transaction
    await db.transaction((txn) async {
      // Insert order record
      await txn.insert('orders', {
        'user_id': userId,
        'invoice_id': invoiceId,
        'date': DateTime.now().toIso8601String(),
        'status': 'proccess'
      });

      // Insert all cart items
      for (var item in cartItems) {
        await txn.insert('order_items', {
          'user_id': userId,
          'invoice_id': invoiceId,
          'product_name': item.name,
          'description': item.describtion,
          'price': item.price,
          'currency': "USD",
          'image_url': item.image,
          'price_sign': item.price_sign,
          'selected_color': item.selectedColor,
          'quantity': item.quantity,
          'address': address,
        });
      }
    });
  }

  // Get order details by invoice ID and user_id
  static Future<Map<String, dynamic>> getOrder(
      String invoiceId, int userId) async {
    final db = await database;

    // Get order info
    final List<Map<String, dynamic>> orderResult = await db.query(
      'orders',
      where: 'invoice_id = ? AND user_id = ?',
      whereArgs: [invoiceId, userId],
    );

    // Get order items
    final List<Map<String, dynamic>> itemsResult = await db.query(
      'order_items',
      where: 'invoice_id = ? AND user_id = ?',
      whereArgs: [invoiceId, userId],
    );

    return {
      'order': orderResult.first,
      'items': itemsResult,
    };
  }

  // Update order status
  static Future<void> updateOrderStatus(
      String invoiceId, String newStatus, int userId) async {
    final db = await database;
    await db.update(
      'orders',
      {'status': newStatus},
      where: 'invoice_id = ? AND user_id = ?',
      whereArgs: [invoiceId, userId],
    );
  }

  // Get all orders for a specific user
  static Future<List<Map<String, dynamic>>> getAllOrders(int userId) async {
    final db = await database;

    return await db.query(
      'orders',
      where: 'user_id = ?',
      whereArgs: [userId],
      orderBy: 'date DESC',
    );
  }

  // Get items for a specific order and user
  static Future<List<Map<String, dynamic>>> getOrderItems(
      String invoiceId, int userId) async {
    final db = await database;
    return await db.query(
      'order_items',
      where: 'invoice_id = ? AND user_id = ?',
      whereArgs: [invoiceId, userId],
    );
  }

  // Delete order for a specific user
  static Future<void> deleteOrder(String invoiceId, int userId) async {
    final db = await database;
    await db.delete(
      'orders',
      where: 'invoice_id = ? AND user_id = ?',
      whereArgs: [invoiceId, userId],
    );
    await db.delete(
      'order_items',
      where: 'invoice_id = ? AND user_id = ?',
      whereArgs: [invoiceId, userId],
    );
  }
}
