import 'package:can_i_eat_this/widget/fixed_search_bar.dart';
import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  String _searchInput = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: FixedSearchBar(callback: setSearchInput),
      body: Container(
        child: Center(child: Text(_searchInput)),
      ),
      backgroundColor: Colors.blueGrey,
    );
  }

  void setSearchInput(String searchInput) {
    setState(() {
      _searchInput = searchInput;
    });
  }

}
