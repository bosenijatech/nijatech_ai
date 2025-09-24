import 'package:ai/authscreen/landingscreen.dart';
import 'package:ai/screens/adminscreen/adminscreen.dart';
import 'package:get/get.dart';

import '../authscreen/loginscreen.dart';

final List<GetPage> getPages = [

  GetPage(name: '/', page: () =>  LandingScreen()),
  GetPage(name: '/login', page: () =>  Loginscreen()),
  GetPage(name: '/admin', page: () =>  Adminscreen()),
 
];
