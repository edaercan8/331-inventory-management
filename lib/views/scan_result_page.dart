import 'package:flutter/material.dart';

class ScanResultPage extends Page {
  final String barcodeScanRes;

  ScanResultPage({this.barcodeScanRes})
      : super(key: ValueKey('ScanResultPage'));

  Route createRoute(BuildContext context) {
    return MaterialPageRoute(
      settings: this,
      builder: (BuildContext context) {
        return Text(this.barcodeScanRes);
      },
    );
  }
}
