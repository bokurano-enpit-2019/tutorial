/**
 * お店の集合のModel
 * 実態としてはLocal SQLite DBとの通信を担わせる
 * */

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:enpit/models/shop.dart';

class ShopList {
  static const String TABLE_NAME = 'shops';
  Database _db;

  // DBを取得する
  Future<Database> _database() async {
    // 既に取得済みならばその値を返す
    if (_db != null) return _db;
    // 未取得ならば取得する
    this._db = await openDatabase(
      // DBのファイルへのパス
      join(await getDatabasesPath(), 'shops.db'),
      // DBが存在しなかった場合、作成
      onCreate: (Database db, int version) async {
        await db.execute(
          'CREATE TABLE $TABLE_NAME (id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT)',
        );
      },
      version: 1,
    );
    return _db;
  }

  // DBへShopデータを追加
  Future<void> add(Shop s) async {
    final Database db = await _database();
    db.insert(
      TABLE_NAME,
      s.toMap(),
    );
  }

  // 全お店データからランダムに1つ取得する
  Future<Shop> get getRandomShop async {
    final Database db = await _database();

    // 全お店データからランダムに1つ取得
    List<Map<String, dynamic>> maps = await db.rawQuery(
      'SELECT * FROM $TABLE_NAME ORDER BY RANDOM() LIMIT 1',
    );

    // お店のデータは1つだけだが、配列で取得されてしまうので適切に処理する
    // お店が1つも無い場合ダミーデータを入れる
    Map<String, dynamic> map =
        maps.length > 0 ? maps.first : {'name': 'お店を追加してください', 'id': 0};
    return Shop.fromMap(map);
  }

  // Modelが利用されなくなったタイミングでDBとの接続を破棄
  void dispose() async {
    final db = await _database();
    await db.close();
  }
}
