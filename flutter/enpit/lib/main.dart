import 'package:flutter/material.dart';
import 'package:enpit/models/shop.dart';
import 'dart:async';
import 'package:enpit/models/shop_list.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'where2eat',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: [
        Locale('ja'), // Japanese
      ],
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

  void _changeShop() {
    setState(() {
      _shop = _shopList.getRandomShop;
    });
  }

  void _showFormDialog(BuildContext context) {
    final TextEditingController tec = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('お店の名前'),
              SizedBox(
                height: 16,
              ),
              TextField(
                controller: tec,
              ),
            ],
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('登録'),
              onPressed: () async {
                if (tec.text != '') {
                  await _shopList.add(
                    Shop(
                      name: tec.text,
                    ),
                  );
                  _changeShop();
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    _changeShop();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('where2eat'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
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
              SizedBox(height: 8),
              RaisedButton(
                child: Text('チェンジ'),
                onPressed: _changeShop,
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          _showFormDialog(context);
//          _insertShop(Shop(name: DateTime.now().toIso8601String()));
        },
      ),
    );
  }
}
