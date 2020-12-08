import 'package:can_i_eat_this/controller/logic.dart';
import 'package:can_i_eat_this/model/product.dart';
import 'package:can_i_eat_this/view/search_page.dart';
import 'package:can_i_eat_this/widget/floating_search_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Product _product;
  String _scanBarcode = 'Unknown';
  Logic logic = Logic();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: FloatingSearchBar(searchPage: SearchPage(callback: _setProduct)),
      body: _buildBody(),
      backgroundColor: Colors.blueGrey,
    );
  }

  Widget _buildBody() {
    return Builder(builder: (BuildContext context) {
      return Container(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            RaisedButton(
              onPressed: () => scanBarcodeNormal(),
              child: Text("Start barcode scan")
            ),
            Text("Scan result: $_scanBarcode"),
            Text(_product == null ? "Not searched yet" : _product.name)
          ]
        )
      );
    });
  }
  
  void _setProduct(Product product) {
    setState(() {
      _product = product;
    });
  }

  Future<void> scanBarcodeNormal() async {
    String barcodeScanRes;
    Product fetchedProduct;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          "#ff6666", "Cancel", true, ScanMode.BARCODE);
      fetchedProduct = await logic.fetchProduct(barcodeScanRes);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
      fetchedProduct = null;
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _scanBarcode = barcodeScanRes;
      _product = fetchedProduct;
    });
  }
}