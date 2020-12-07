import 'package:can_i_eat_this/model/product.dart';
import 'package:can_i_eat_this/view/search_page.dart';
import 'package:can_i_eat_this/widget/floating_search_bar.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Product _product;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: FloatingSearchBar(searchPage: SearchPage(callback: _setProduct)),
      body: _buildBody(),
      backgroundColor: Colors.blueGrey,
    );
  }

  Widget _buildBody() {
    if (_product == null) {
      return Text("hello 2");
    }

    return Text(_product.name);
  }
  
  void _setProduct(Product product) {
    setState(() {
      _product = product;
    });
  }
}