import 'package:flutter/material.dart';
import 'package:google_maps/pages/map_page.dart';
import 'package:google_maps/pages/searchbar_animation.dart';
import 'package:google_maps/pages/second_map_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ThirdMapPage(),
    );
  }
}
