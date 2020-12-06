import 'package:can_i_eat_this/view/home.dart';
import 'package:can_i_eat_this/widget/app_theme.dart';
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
      home: Home(),
//      theme: AppTheme.lightThemeData,
      debugShowCheckedModeBanner: false,
    );
  }
}
