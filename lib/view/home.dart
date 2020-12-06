import 'dart:convert';

import 'package:can_i_eat_this/model/Product.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Future<Product> futureProduct;

  @override
  void initState() {
    super.initState();
    futureProduct = fetchProduct('https://world.openfoodfacts.org/api/v0/product/062020000248.json');
//    futureProduct = fetchProduct('h.json');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("test"),
      ),
      body: FutureBuilder<Product>(
        future: futureProduct,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Text(snapshot.data.name + " " + snapshot.data.ingredients.toString());
          } else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          }

          // By default, show a loading spinner.
          return CircularProgressIndicator();
        },
      ),
    );
  }

  Future<Product> fetchProduct(String url) async {
    final response = await http.get(url);

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response, then parse the JSON.
      return Product.fromJson(jsonDecode(response.body));
    } else {
      // If the server did not return a 200 OK response, then throw an exception.
      throw Exception('Failed to load product');
    }
  }

}