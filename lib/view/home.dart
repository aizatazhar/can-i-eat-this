import 'package:can_i_eat_this/controller/logic.dart';
import 'package:can_i_eat_this/model/product.dart';
import 'package:can_i_eat_this/util/StringUtils.dart';
import 'package:can_i_eat_this/view/search_page.dart';
import 'package:can_i_eat_this/widget/floating_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Product _product;
  String _scanBarcode = "";
  Logic logic = Logic();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: FloatingSearchBar(searchPage: SearchPage(callback: _setProduct)),
      floatingActionButton: FlatButton(
        child: Wrap(
          children: [
            Icon(Icons.camera_alt, color: Colors.white, size: 22),
            SizedBox(width: 10),
            Text("Scan", style: TextStyle(color: Colors.white, fontSize: 18)),
          ]
        ),
        color: Colors.redAccent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        onPressed: () => scanBarcodeNormal(),
        height: 40,
      ),
      body: _product == null ? _buildEmptyView() : _buildBody(),
    );
  }

  Widget _buildEmptyView() {
    return Container(
      alignment: Alignment.center,
      child: Text("Search for a product. Scanned barcode: $_scanBarcode"),
    );
  }

  Widget _buildBody() {
    return Builder(builder: (BuildContext context) {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text("Barcode", style: Theme.of(context).textTheme.headline5),
              Text("${_product.barcode}"),
              SizedBox(height: 10),

              Text("Product Summary", style: Theme.of(context).textTheme.headline5),
              Text("Name", style: Theme.of(context).textTheme.subtitle2),
              Text(_product.toString()),
              Text("Ingredients", style: Theme.of(context).textTheme.subtitle2),
              Text(StringUtils.withoutFirstAndLastChars(_product.ingredients.toString())),
              Text("Vegan", style: Theme.of(context).textTheme.subtitle2),
              Text(_product.isVegan() ? "Yes" : "No"),
              Text("Vegetarian", style: Theme.of(context).textTheme.subtitle2),
              Text(_product.isVegetarian() ? "Yes" : "No"),
              Text("Palm Oil", style: Theme.of(context).textTheme.subtitle2),
              Text(_product.hasPalmOil() ? "Yes" : "No"),
              Text("Allergens", style: Theme.of(context).textTheme.subtitle2),
              Text(StringUtils.withoutFirstAndLastChars(_product.allergens.toString())),
              SizedBox(height: 10),

              Text("Non-vegan ingredients", style: Theme.of(context).textTheme.headline5),
              Text(StringUtils.formattedAsListView(_product.getNonVeganIngredients())),
              SizedBox(height: 10),

              Text("Non-vegetarian ingredients", style: Theme.of(context).textTheme.headline5),
              Text(StringUtils.formattedAsListView(_product.getNonVegetarianIngredients())),
              SizedBox(height: 10),

              Text("Palm oil ingredients", style: Theme.of(context).textTheme.headline5),
              Text(StringUtils.formattedAsListView(_product.getPalmOilIngredients())),
              SizedBox(height: 10),

              Text("Allergens", style: Theme.of(context).textTheme.headline5),
              Text(StringUtils.withoutFirstAndLastChars(_product.allergens.toString())),
              SizedBox(height: 10),
            ]
          ),
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
      if (barcodeScanRes != "-1") {
        fetchedProduct = await logic.fetchProduct(barcodeScanRes);
      }
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