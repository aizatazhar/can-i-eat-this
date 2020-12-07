import 'package:flutter/material.dart';

// Search bar shown on the home page
class FloatingSearchBar extends StatelessWidget with PreferredSizeWidget {
  final Widget searchPage;

  FloatingSearchBar({this.searchPage});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Positioned(
          top: MediaQuery.of(context).padding.top + 5,
          right: 10,
          left: 10,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: Colors.white
            ),
            child: Row(
              children: <Widget>[
                Material(
                  type: MaterialType.transparency,
                  child: IconButton(
                    splashColor: Colors.grey,
                    icon: Icon(Icons.menu),
                    onPressed: () {
                      print("Open drawer");
//                      Scaffold.of(context).openDrawer();
                    },
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.only(left: 5),
                    child: GestureDetector(
                      child: Text(
                        "Search",
                        style: TextStyle(fontSize: 16),
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => searchPage),
                        );
                      },
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.settings),
                  onPressed: () => print("Open settings page"),
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}