import 'package:flutter/material.dart';

// Search bar shown on the search page
class FixedSearchBar extends StatefulWidget with PreferredSizeWidget {
  final Function callback;

  FixedSearchBar({this.callback});

  @override
  _FixedSearchBarState createState() => _FixedSearchBarState();

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}

class _FixedSearchBarState extends State<FixedSearchBar> {
  TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();

    // Update state every time the TextField's input changes
    _controller.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      iconTheme: IconThemeData(color: Colors.black),
      elevation: 0,
      title: TextField(
        textAlignVertical: TextAlignVertical.center,
        textInputAction: TextInputAction.search,
        autofocus: true,
        controller: _controller,
        style: TextStyle(color: Colors.black),
        decoration: InputDecoration(
          hintText: "Search",
          border: InputBorder.none,
          focusedBorder: InputBorder.none,
          suffixIcon: _controller.text.isNotEmpty
              ? IconButton(
                icon: Icon(Icons.clear),
                onPressed: () => _controller.clear(),
                color: Colors.black
              )
              : Icon(null)
        ),
        onSubmitted: (input) {
          widget.callback(input);
        },
      ),
    );
  }
}