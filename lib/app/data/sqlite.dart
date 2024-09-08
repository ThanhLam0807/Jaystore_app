import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:jaystore/app/model/cart.dart';

class DatabaseHelper {
  // Singleton pattern
  static final DatabaseHelper _databaseService = DatabaseHelper._internal();
  factory DatabaseHelper() => _databaseService;
  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    // Initialize the DB first time it is accessed
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, 'db_cart.db');
    print("Đường dẫn database: $databasePath"); // in đường dẫn chứa file database
    return await openDatabase(path, onCreate: _onCreate, version: 1);
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute(
      'CREATE TABLE Cart('
          'productID INTEGER PRIMARY KEY, '
          'name TEXT, '
          'price FLOAT, '
          'img TEXT, '
          'des TEXT, '
          'count INTEGER)',
    );
  }

  Future<void> insertProduct(Cart productModel) async {
    final db = await database;
    // Check if the product already exists in the cart
    Cart? existingProduct = await getProductById(productModel.productID);
    if (existingProduct != null) {
      // Product already exists, update the count
      productModel.count += existingProduct.count;
      await updateProductCount(productModel);
    } else {
      // Product does not exist, insert as new
      await db.insert(
        'Cart',
        productModel.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
  }

  Future<void> updateProductCount(Cart product) async {
    final db = await database;
    await db.update(
      'Cart',
      product.toMap(),
      where: 'productID = ?',
      whereArgs: [product.productID],
    );
  }

  Future<List<Cart>> products() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('Cart');
    return List.generate(maps.length, (index) => Cart.fromMap(maps[index]));
  }

  Future<Cart?> getProductById(int id) async {
    final db = await database;
    List<Map<String, dynamic>> results = await db.query(
      'Cart',
      where: 'productID = ?',
      whereArgs: [id],
    );
    if (results.isEmpty) {
      return null;
    } else {
      return Cart.fromMap(results.first);
    }
  }

  Future<void> minus(Cart product) async {
    final db = await database;
    if (product.count > 1) product.count--;
    await updateProductCount(product);
  }

  Future<void> add(Cart product) async {
    final db = await database;
    product.count++;
    await updateProductCount(product);
  }

  Future<void> deleteProduct(int id) async {
    final db = await database;
    await db.delete(
      'Cart',
      where: 'productID = ?',
      whereArgs: [id],
    );
  }

  Future<void> clear() async {
    final db = await database;
    await db.delete('Cart');
  }
}
