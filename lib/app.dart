import 'package:flutter/material.dart';

import 'package:inventory_management/views/product_form_page.dart';
import 'package:inventory_management/views/product_list_page.dart';

class App extends MaterialApp {
  final bool formVisible;
  App()
      : super(
          title: 'Medical Inventory System',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: Navigator(
            pages: [
              ProductListPage(),
              if (this.formVisible) ProductFormPage(),
            ],
            onPopPage: (route, result) => route.didPop(result),
          ),
        );
}
