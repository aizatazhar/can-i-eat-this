import 'package:can_i_eat_this/controller/logic.dart';
import 'package:can_i_eat_this/model/product.dart';
import 'package:can_i_eat_this/widget/fixed_search_bar.dart';
import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  String _searchInput = "";
  Logic logic = Logic();

  @override
  Widget build(BuildContext context) {
    print(_searchInput);
    return Scaffold(
      appBar: FixedSearchBar(callback: setSearchInput),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 0),
        child: _buildSearchResults(_searchInput)
      ),
      backgroundColor: Colors.blueGrey,
    );
  }

  void setSearchInput(String searchInput) {
    setState(() {
      _searchInput = searchInput;
    });
  }

  Widget _buildSearchResults(String searchInput) {
    Future<Product> futureProduct = logic.fetchProduct(_searchInput);

    return FutureBuilder<Product>(
      future: futureProduct,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
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
                  print("Open product/ingredient on home page");
                },
              )
            ],
          );
        } else if (snapshot.hasError) {
          return Text("${snapshot.error}");
        }

        // By default, show a loading spinner.
        return CircularProgressIndicator();
      },
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