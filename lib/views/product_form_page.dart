import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

class ProductFormPage extends Page {
  final Function setFormVisible;
  ProductFormPage({this.setFormVisible})
      : super(key: ValueKey('ProductFormPage'));

  Route createRoute(BuildContext context) {
    return MaterialPageRoute(
      settings: this,
      builder: (BuildContext context) {
        return ProductForm(setFormVisible: this.setFormVisible);
      },
    );
  }
}

class ProductForm extends StatefulWidget {
  final Function setFormVisible;
  ProductForm({this.setFormVisible}) : super();
  @override
  _ProductFormState createState() =>
      _ProductFormState(setFormVisible: this.setFormVisible);
}

class _FormData {
  String name;
  int quantity;
  String barcode = '';
}

class _ProductFormState extends State<ProductForm> {
  final _formKey = GlobalKey<FormState>();
  _FormData _data = _FormData();
  final Function setFormVisible;
  var textController = new TextEditingController();
  String name;

  _ProductFormState({this.setFormVisible}) : super();

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
      this.textController.text = barcodeScanRes;
    });
  }

  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: ListView(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(bottom: 10),
            child: TextFormField(
                decoration: const InputDecoration(
                  hintText: 'Enter the Product\'s Name',
                ),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Field required';
                  }
                  return null;
                },
                onSaved: (String value) {
                  this._data.name = value;
                }),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 10),
            child: TextFormField(
                decoration: const InputDecoration(
                  hintText: 'Enter the Current Stock Quantity',
                ),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Field required';
                  }
                  return null;
                },
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                onSaved: (String value) {
                  this._data.quantity = num.tryParse(value);
                }),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 10),
            child: TextFormField(
                decoration: const InputDecoration(
                  hintText: 'Scan the Product\'s Barcode',
                ),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Field required';
                  }
                  return null;
                },
                controller: this.textController,
                onSaved: (String value) {
                  this._data.barcode = value;
                }),
          ),
          Row(
            children: <Widget>[
              ElevatedButton(
                onPressed: () => this.scanBarcodeNormal(),
                child: Text('Scan'),
              ),
              Padding(
                padding: EdgeInsets.only(left: 10),
                child: ElevatedButton(
                  onPressed: () {
                    // Validate returns true if the form is valid, otherwise false.
                    if (_formKey.currentState.validate()) {
                      _formKey.currentState.save();
                      CollectionReference products =
                          FirebaseFirestore.instance.collection('products');

                      Future<void> addProduct() {
                        return products
                            .add({
                              'name': this._data.name,
                              'quantity': this._data.quantity,
			      'barcode': this._data.barcode,
                              'order': 0,
                            })
                            .then((value) => this.setFormVisible(false))
                            .catchError((error) =>
                                print("Failed to add product: $error"));
                      }

                      addProduct();
                    }
                  },
                  child: Text('Add'),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 10),
                child: ElevatedButton(
                  onPressed: () => this.setFormVisible(false),
                  child: Text('Cancel'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
