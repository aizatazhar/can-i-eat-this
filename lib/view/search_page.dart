import 'package:can_i_eat_this/controller/logic.dart';
import 'package:can_i_eat_this/model/product.dart';
import 'package:can_i_eat_this/widget/fixed_search_bar.dart';
import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  final Function callback;

  SearchPage({this.callback});

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  bool _isFirstSearch = true; // prevents an empty search when first opening screen
  String _searchInput = "";
  Logic _logic = Logic();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: FixedSearchBar(callback: setSearchInput),

      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 0),
        child: _isFirstSearch ? _buildEmptyView() : _buildSearchResults(_searchInput)
      ),
    );
  }

  void setSearchInput(String searchInput) {
    setState(() {
      _searchInput = searchInput;
      _isFirstSearch = false;
    });
  }

  Widget _buildSearchResults(String searchInput) {
    Future<Product> futureProduct = _logic.fetchProduct(_searchInput);

    return FutureBuilder<Product>(
      future: futureProduct,
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case (ConnectionState.waiting):
            return Center(child: CircularProgressIndicator());
          default:
            if (snapshot.hasError) {
              return Text("${snapshot.error}");
            }

            if (snapshot.data == null) {
              return Container(child: _buildEmptyView());
            }

            return ListView(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Text("Products", style: TextStyle(fontSize: 16),)
                ),
                ListTile(
                  title: Text(snapshot.data.name),
                  leading: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.lunch_dining),
                    ],
                  ),
                  contentPadding: EdgeInsets.symmetric(horizontal: 20),
                  subtitle: Wrap(children: [
                    Text(snapshot.data.ingredients.toString())
                  ]),
                  onTap: () {
                    this.widget.callback(snapshot.data);
                    Navigator.pop(context);
                  },
                )
              ],
            );
        }
      },
    );
  }

  Widget _buildEmptyView() {
    return Container(
      alignment: Alignment.center,
      child: Text("No such product found"),
    );
  }
}