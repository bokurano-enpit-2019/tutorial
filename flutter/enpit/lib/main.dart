// dart packages
import 'dart:async';

// UI packages
import 'package:flutter/material.dart';
import 'package:enpit/widgets/form_dialog.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

// model packages
import 'package:enpit/models/shop.dart';
import 'package:enpit/models/shop_list.dart';

void main() => runApp(MyApp());

// アプリケーションの基幹部分
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'where2eat',
      // 日本語対応
      supportedLocales: [
        Locale('ja'),
      ],
      // ホームページのレンダリング
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final ShopList _shopList = ShopList();
  Future<Shop> _shop;

  // 表示されているお店を変更する
  void _changeShop() {
    setState(() {
      _shop = _shopList.getRandomShop;
    });
  }

  // FormDialogを起動
  void _showFormDialog(BuildContext context) async {
    String text = await FormDialog.show<String>(context);
    await _shopList.add(
      Shop(
        name: text,
      ),
    );
    _changeShop();
  }

  // アプリ起動時に文字を表示する
  @override
  void initState() {
    _changeShop();
    super.initState();
  }

  // アプリ終了時にDBをクローズ
  @override
  void dispose() {
    _shopList.dispose();
  }

  // ホームページ本体
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 画面上部のバー
      appBar: AppBar(
        title: Text('where2eat'),
      ),
      // ホームページ本体の本体(語彙力)
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              // _shopが変更されたら表示も変更
              FutureBuilder(
                future: _shop,
                builder: (BuildContext context, AsyncSnapshot<Shop> snap) {
                  return Text(
                    snap.data?.name ?? '',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  );
                },
              ),
              SizedBox(height: 32),
              SizedBox(
                height: 64,
                width: 128,
                child: RaisedButton(
                  child: const Text(
                    'チェンジ',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  onPressed: _changeShop,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ],
          ),
        ),
      ),
      // お店データを追加するFAB
      // タップされたらダイアログを見せてデータの入力を促す
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          _showFormDialog(context);
        },
      ),
    );
  }
}
