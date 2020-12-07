
import 'package:can_i_eat_this/model/product.dart';
import 'package:can_i_eat_this/widget/floating_search_bar.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: FloatingSearchBar(),
      body: Container(),
      backgroundColor: Colors.blueGrey,
    );
  }
}