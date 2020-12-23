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
  bool _buildUsingCache = false;
  Product _cachedProduct;
  String _scannedBarcode = "";
  Logic _logic = Logic();

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
        onPressed: () => scanBarcode(),
        height: 40,
      ),
      body: _buildUsingCache ? _buildCachedProduct() : _buildScannedProduct(),
    );
  }

  Future<void> scanBarcode() async {
    String barcodeScanRes;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          "#ff6666", "Cancel", true, ScanMode.BARCODE);
      if (barcodeScanRes == "-1") { // Don't update any state if we cancel the scan
        return;
      }
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _buildUsingCache = false;
      _scannedBarcode = barcodeScanRes;
    });
  }

  void _setProduct(Product product) {
    setState(() {
      _cachedProduct = product;
      _buildUsingCache = true;
    });
  }

  // Builds the body using the product cached from a manual search
  Widget _buildCachedProduct() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(height:10),
            Text("Barcode", style: Theme.of(context).textTheme.headline5),
            Text(_cachedProduct.barcode),
            SizedBox(height: 10),

            Text("Product Summary", style: Theme.of(context).textTheme.headline5),
            Text("Name", style: Theme.of(context).textTheme.subtitle2),
            Text(_cachedProduct.toString()),
            Text("Ingredients", style: Theme.of(context).textTheme.subtitle2),
            Text(StringUtils.withoutFirstAndLastChars(_cachedProduct.ingredients.toString())),
            Text("Vegan", style: Theme.of(context).textTheme.subtitle2),
            Text(_cachedProduct.isVegan() ? "Yes" : "No"),
            Text("Vegetarian", style: Theme.of(context).textTheme.subtitle2),
            Text(_cachedProduct.isVegetarian() ? "Yes" : "No"),
            Text("Palm Oil", style: Theme.of(context).textTheme.subtitle2),
            Text(_cachedProduct.hasPalmOil() ? "Yes" : "No"),
            Text("Allergens", style: Theme.of(context).textTheme.subtitle2),
            Text(StringUtils.withoutFirstAndLastChars(_cachedProduct.allergens.toString())),
            SizedBox(height: 10),

            Text("Non-vegan ingredients", style: Theme.of(context).textTheme.headline5),
            Text(StringUtils.formattedAsListView(_cachedProduct.getNonVeganIngredients())),
            SizedBox(height: 10),

            Text("Non-vegetarian ingredients", style: Theme.of(context).textTheme.headline5),
            Text(StringUtils.formattedAsListView(_cachedProduct.getNonVegetarianIngredients())),
            SizedBox(height: 10),

            Text("Palm oil ingredients", style: Theme.of(context).textTheme.headline5),
            Text(StringUtils.formattedAsListView(_cachedProduct.getPalmOilIngredients())),
            SizedBox(height: 10),

            Text("Allergens", style: Theme.of(context).textTheme.headline5),
            Text(StringUtils.withoutFirstAndLastChars(_cachedProduct.allergens.toString())),
            SizedBox(height: 50),
          ]
        ),
      )
    );
  }

  // Builds the body using the scanned barcode
  Widget _buildScannedProduct() {
    if (_scannedBarcode == "") {
      return _buildEmptyView();
    }

    Future<Product> futureProduct = _logic.fetchProduct(_scannedBarcode);

    return FutureBuilder<Product>(
      future: futureProduct,
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case (ConnectionState.waiting):
            return Center(child: CircularProgressIndicator());
          default:
            if (snapshot.hasError) {
              return Text("${snapshot.error}");
            } else if (snapshot.data == null) {
              return _buildEmptyView();
            }

            return Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text("Barcode", style: Theme.of(context).textTheme.headline5),
                    Text(snapshot.data.barcode),
                    SizedBox(height: 10),

                    Text("Product Summary", style: Theme.of(context).textTheme.headline5),
                    Text("Name", style: Theme.of(context).textTheme.subtitle2),
                    Text(snapshot.data.toString()),
                    Text("Ingredients", style: Theme.of(context).textTheme.subtitle2),
                    Text(StringUtils.withoutFirstAndLastChars(snapshot.data.ingredients.toString())),
                    Text("Vegan", style: Theme.of(context).textTheme.subtitle2),
                    Text(snapshot.data.isVegan() ? "Yes" : "No"),
                    Text("Vegetarian", style: Theme.of(context).textTheme.subtitle2),
                    Text(snapshot.data.isVegetarian() ? "Yes" : "No"),
                    Text("Palm Oil", style: Theme.of(context).textTheme.subtitle2),
                    Text(snapshot.data.hasPalmOil() ? "Yes" : "No"),
                    Text("Allergens", style: Theme.of(context).textTheme.subtitle2),
                    Text(StringUtils.withoutFirstAndLastChars(snapshot.data.allergens.toString())),
                    SizedBox(height: 10),

                    Text("Non-vegan ingredients", style: Theme.of(context).textTheme.headline5),
                    Text(StringUtils.formattedAsListView(snapshot.data.getNonVeganIngredients())),
                    SizedBox(height: 10),

                    Text("Non-vegetarian ingredients", style: Theme.of(context).textTheme.headline5),
                    Text(StringUtils.formattedAsListView(snapshot.data.getNonVegetarianIngredients())),
                    SizedBox(height: 10),

                    Text("Palm oil ingredients", style: Theme.of(context).textTheme.headline5),
                    Text(StringUtils.formattedAsListView(snapshot.data.getPalmOilIngredients())),
                    SizedBox(height: 10),

                    Text("Allergens", style: Theme.of(context).textTheme.headline5),
                    Text(StringUtils.withoutFirstAndLastChars(snapshot.data.allergens.toString())),
                    SizedBox(height: 10),
                  ]
                ),
            )
          );
        }
      },
    );
  }

  // Builds the body when the product does not exist
  Widget _buildEmptyView() {
    return Container(
      alignment: Alignment.center,
      child: Text("Product not found. Scanned barcode: $_scannedBarcode"),
    );
  }
}