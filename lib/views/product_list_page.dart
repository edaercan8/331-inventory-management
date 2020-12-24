import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProductListPage extends Page {
  ProductListPage() : super(key: ValueKey('ProductListPage'));

  Route createRoute(BuildContext context) {
    return MaterialPageRoute(
      settings: this,
      builder: (BuildContext context) {
        return ProductList();
      },
    );
  }
}

class ProductList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    CollectionReference products =
        FirebaseFirestore.instance.collection('products');

    return StreamBuilder<QuerySnapshot>(
        stream: products.snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Text("Loading");
          }

          return DataTable(
            columns: [
              DataColumn(label: Text('Name')),
              DataColumn(label: Text('Barcode')),
              DataColumn(label: Text('Stock Quantity'), numeric: true),
              DataColumn(label: Text('Order Quantity'), numeric: true),
            ],
            rows: snapshot.data.docs.map((DocumentSnapshot document) {
              return DataRow(
                cells: <DataCell>[
                  DataCell(Text(document.data()['name'])),
		  DataCell(Text(document.data()['barcode'])),
                  DataCell(Text(document.data()['quantity'].toString())),
                  DataCell(Text(document.data()['order'].toString())),
                ],
              );
            }).toList(),
          );
        });
  }
}
