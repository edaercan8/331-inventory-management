import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:inventory_management/views/product_form_page.dart';
import 'package:inventory_management/views/product_list_page.dart';
import 'package:inventory_management/views/scan_result_page.dart';
import 'package:inventory_management/components/app_layout.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

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
  String _scanBarcode = 'Unknown';
  bool formVisible = false;

  void setFormVisible(bool state) {
    setState(() {
      this.formVisible = state;
    });
  }

  Future<void> scanBarcodeNormal() async {
    String barcodeScanRes;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          "#ff6666", "Cancel", true, ScanMode.BARCODE);
      print(barcodeScanRes);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _scanBarcode = barcodeScanRes;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: this.title,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: FutureBuilder(
          // Initialize FlutterFire:
          future: _initialization,
          builder: (context, snapshot) {
            // Check for errors
            if (snapshot.hasError) {
              return Text(snapshot.error.toString());
            }

            // Once complete, show your application
            if (snapshot.connectionState == ConnectionState.done) {
              return AppLayout(
                setFormVisible: this.setFormVisible,
                scanBarcodeNormal: this.scanBarcodeNormal,
                body: Navigator(
                  pages: [
                    ProductListPage(),
                    if (this.formVisible)
                      ProductFormPage(setFormVisible: this.setFormVisible),
                    if (this._scanBarcode != "Unknown")
                      ScanResultPage(barcodeScanRes: this._scanBarcode),
                  ],
                  onPopPage: (route, result) => route.didPop(result),
                ),
              );
            }

            // Otherwise, show something whilst waiting for initialization to complete
            return Text('Loading...');
          },
        ));
  }
}
