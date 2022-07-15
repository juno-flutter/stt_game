import 'package:flutter/material.dart';
import 'color_schemes.g.dart';
import 'my_home_page.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  ScrollbarThemeData scrollbarThemeData(){
    return ScrollbarThemeData(
        thumbVisibility: MaterialStateProperty.all(true),
        thickness: MaterialStateProperty.all(10),
        thumbColor: MaterialStateProperty.all(Colors.red[100]),
        radius: const Radius.circular(10),
        minThumbLength: 50);
  }
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: '낱말 게임',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // primarySwatch: Colors.blue,
        useMaterial3: true,
        colorScheme: lightColorScheme,
        scrollbarTheme: scrollbarThemeData(),
      ),
      darkTheme: ThemeData(
        // primarySwatch: Colors.blue,
        useMaterial3: true,
        colorScheme: darkColorScheme,
        scrollbarTheme: scrollbarThemeData(),
      ),
      themeMode: ThemeMode.system,
      home: MyHomePage(),
    );
  }
}

