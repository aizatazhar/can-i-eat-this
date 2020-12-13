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
      backgroundColor: Colors.blueGrey,
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
              return Container(child: Text("No products found"));
            }

            return ListView(
              children: [
                ListTile(
                  title: Text(snapshot.data.name),
                  leading: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.lunch_dining),
                    ],
                  ),
                  contentPadding: EdgeInsets.symmetric(horizontal: 20),
                  tileColor: Colors.blueGrey.shade300,
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
      child: Text("Search for an ingredient or product!"),
    );
  }
}

//ExpansionTile(
//title: Text("Products"),
//initiallyExpanded: true,
////          trailing: Icon(null),
//children: [
//Text("hello"),
//Text("hello2")
//],
//),