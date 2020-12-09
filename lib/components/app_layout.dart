import 'package:flutter/material.dart';
import 'package:inventory_management/components/app_menu.dart';
import 'package:inventory_management/components/app_drawer.dart';

class AppLayout extends StatelessWidget {
  final Widget body;
  final Function setFormVisible;

  AppLayout({this.body, this.setFormVisible}) : super();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppMenu(setFormVisible: this.setFormVisible),
      drawer: AppDrawer(),
      body: Center(
        child: Container(
          padding: EdgeInsets.all(10.0),
          width: 600,
          child: this.body,
        ),
      ),
    );
  }
}
