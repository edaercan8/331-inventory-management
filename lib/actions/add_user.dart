import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddProduct extends StatelessWidget {
  final String name;

  AddProduct(this.name);

  @override
  Widget build(BuildContext context) {
    // Create a CollectionReference called products that references the firestore collection
    CollectionReference products =
	    FirebaseFirestore.instance.collection('products');

    Future<void> addProduct() {
      // Call the products CollectionReference to add a new product
      return products
          .add({
            'name': name,
          })
          .then((value) => print("Product Added"))
          .catchError((error) => print("Failed to add product: $error"));
    }

    return FlatButton(
      onPressed: addUser,
      child: Text(
        "Add User",
      ),
    );
  }
}
