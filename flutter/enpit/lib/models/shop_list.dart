import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:enpit/models/shop.dart';

class ShopList {
  static const String TABLE_NAME = 'shops';

  Future<Database> _database() async {
    return openDatabase(
      join(await getDatabasesPath(), 'shops.db'),
      onCreate: (Database db, int version) async {
        await db.execute(
          'CREATE TABLE $TABLE_NAME (id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT)',
        );
      },
      version: 1,
    );
  }

  Future<void> add(Shop s) async {
    final Database db = await _database();
    db.insert(
      TABLE_NAME,
      s.toMap(),
    );
  }

  Future<Shop> get getRandomShop async {
    final Database db = await _database();
    List<Map<String, dynamic>> maps = await db.rawQuery(
      'SELECT * FROM $TABLE_NAME ORDER BY RANDOM() LIMIT 1',
    );
    Map<String, dynamic> map =
        maps.length > 0 ? maps.first : {'name': 'お店を追加してください', 'id': 0};
    return Shop.fromMap(map);
  }
}
