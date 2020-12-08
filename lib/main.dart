import 'package:can_i_eat_this/view/root.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Sets status bar to be transparent
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(statusBarColor: Colors.transparent));

    return MaterialApp(
      title: 'Flutter Demo',
      home: Root(),
//      theme: AppTheme.lightThemeData,
      debugShowCheckedModeBanner: false,
    );
  }
}
