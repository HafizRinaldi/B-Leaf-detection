import 'package:B_Leaf_Detection/utama.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  runApp(
    MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => const HalamanUtama(),
      },
    ),
  );
}
