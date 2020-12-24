import 'package:flutter/material.dart';

class AppMenu extends StatelessWidget implements PreferredSizeWidget {
  final Function setFormVisible;
  final Function scanBarcodeNormal;

  AppMenu({this.setFormVisible, this.scanBarcodeNormal}) : super();

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
        IconButton(
          icon: const Icon(Icons.camera_alt),
          tooltip: 'Scan Barcode',
          onPressed: () => this.scanBarcodeNormal(),
        ),
      ],
    );
  }
}
