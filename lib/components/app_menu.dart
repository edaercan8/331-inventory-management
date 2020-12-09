import 'package:flutter/material.dart';

class AppMenu extends StatelessWidget implements PreferredSizeWidget {
  final Function setFormVisible;

  AppMenu({this.setFormVisible}) : super();

  @override
  Size get preferredSize => const Size.fromHeight(100);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text('Inventory Management System'),
      actions: <Widget>[
        IconButton(
          icon: const Icon(Icons.add_alert),
          tooltip: 'Add Product',
          onPressed: () => this.setFormVisible(true),
        ),
      ],
    );
  }
}
