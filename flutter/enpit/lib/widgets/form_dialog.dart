import 'package:flutter/material.dart';

class FormDialog extends StatefulWidget {
  final Function onSubmit;

  FormDialog({Key key, @required this.onSubmit}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _FormDialogState();
  }

  static Future<T> show<T>(BuildContext context) async {
    return await showDialog(
      context: context,
      builder: (BuildContext context) {
        return FormDialog(
          onSubmit: (String text) async {
            if (text != '') {
              Navigator.of(context).pop(text);
            }
          },
        );
      },
    );
  }
}

class _FormDialogState extends State<FormDialog> {
  final TextEditingController _tec = TextEditingController();

  @override
  Widget build(BuildContext context) {
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
            controller: _tec,
          ),
        ],
      ),
      actions: <Widget>[
        FlatButton(
          child: Text('登録'),
          onPressed: () {
            widget.onSubmit(_tec.text);
          },
        ),
      ],
    );
  }
}
