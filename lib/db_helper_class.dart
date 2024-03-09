import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:sqflite_todo/user_model.dart';

class DatabaseHelper {
  static final _databaseName = "edugaon.db";
  static final _databaseVersion = 1;
  static final tableName = "products";
  static final id = "product_id";
  static final title = "product_title"; // Corrected the variable name
  static final description = "product_description";
  static final image = "product_image";

  static Future<Database> _getDB() async {
    return openDatabase(
      join(await getDatabasesPath(), _databaseName),
      version: _databaseVersion,
      onCreate: (db, _version) async => await db.execute(
        'CREATE TABLE $tableName('
            '$id INTEGER PRIMARY KEY, '
            '$title TEXT NOT NULL, '
            '$description TEXT NOT NULL, '
            '$image TEXT'
            ')',
      ),
    );
  }

  Future inset(ProductModel productModel)async{
    Database? db =await _getDB();
    return await db.insert(tableName, productModel.toMap());
  }

  Future<List<ProductModel>> getData() async{
    final db =await _getDB();
    final List<Map<String, dynamic>> maps =await db.query(tableName);
    return maps.map((e) => ProductModel.fromJson(e)).toList();
  }
  Future<int> updateData(ProductModel productModel) async{
    final db =await _getDB();
    return db.update(tableName, productModel.toMap(),where: 'product_id = ? ' ,whereArgs: [productModel.id]);
  }
  Future<int> deleteData(int id) async{
    final db =await _getDB();
    return db.delete(tableName,where: 'product_id = ?',whereArgs:[id]);
    }
}