import 'dart:math';
import 'package:flutter/material.dart';

// Color getRandomColor() {
//   final Random random = Random();
//   return Color.fromARGB(
//     255,
//     random.nextInt(256), // Red
//     random.nextInt(256), // Green
//     random.nextInt(256), // Blue
//   );
// }

Color getRandomColor() {
  final Random random = Random();
  return Color.fromARGB(
    255,
    100 + random.nextInt(170), // Red: 100–199
    100 + random.nextInt(170), // Green: 100–199
    100 + random.nextInt(170), // Blue: 100–199
  );
}
