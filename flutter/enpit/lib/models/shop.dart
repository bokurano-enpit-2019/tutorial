/**
 * お店のModel
 * 現時点では店の名前と店IDのみ保持
 * */

import 'package:meta/meta.dart';

class Shop {
  final String name;
  final int id;

  Shop({
    this.id,
    @required this.name,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'id': id,
    };
  }

  static Shop fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
    return Shop(
      id: map['id'],
      name: map['name'],
    );
  }
}
