import 'package:flutter/material.dart';
import 'themes/custome_theme.dart';
import 'views/login_page.dart';
import 'views/all_media_page.dart';

void main() {
  runApp(
    const MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Melt',
      theme: CustomTheme.darkTheme,
      home: AllMediaPage(),
    );
  }
}
