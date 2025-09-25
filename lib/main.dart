import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'router/getx_routes.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      getPages: getPages,
      theme: ThemeData(
        fontFamily: "Poppins",
      
    ),
    );
  
  }
}
