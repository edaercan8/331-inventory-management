import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:inventory_management/views/product_form_page.dart';
import 'package:inventory_management/views/product_list_page.dart';
import 'package:inventory_management/components/app_layout.dart';

void main() {
  runApp(App());
}

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  final String title = 'Medical Inventory Manager';

  bool formVisible = false;

  void setFormVisible(bool state) {
    setState(() {
      this.formVisible = state;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      // Initialize FlutterFire:
      future: _initialization,
      builder: (context, snapshot) {
        // Check for errors
        if (snapshot.hasError) {
          return Text("Error!");
        }

        // Once complete, show your application
        if (snapshot.connectionState == ConnectionState.done) {
          return MaterialApp(
            title: this.title,
            theme: ThemeData(
              primarySwatch: Colors.blue,
            ),
            home: AppLayout(
              setFormVisible: this.setFormVisible,
              body: Navigator(
                pages: [
                  ProductListPage(),
                  if (this.formVisible)
                    ProductFormPage(setFormVisible: this.setFormVisible),
                ],
                onPopPage: (route, result) => route.didPop(result),
              ),
            ),
          );
        }

        // Otherwise, show something whilst waiting for initialization to complete
        return Text('Loading...');
      },
    );
  }
}
