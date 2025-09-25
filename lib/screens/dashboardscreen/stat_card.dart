import 'package:flutter/material.dart';

class StatCard extends StatelessWidget {
  final String amount;
  final String title;
  final String imagePath; // asset image path
  final Color backgroundColor; // color behind image
  final Color imageColor;

  const StatCard({
    super.key,
    required this.amount,
    required this.title,
    required this.imagePath,
    required this.backgroundColor,
    required this.imageColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Text section
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                amount,
                style: const TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                title,
                style: const TextStyle(fontSize: 14, color: Colors.black),
              ),
            ],
          ),
          // Image inside circular colored background
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: backgroundColor,
              shape: BoxShape.rectangle, // circular background
            ),
            child: Image.asset(
              imagePath,
              width: 30,
              height: 30,
              color: imageColor,
            ),
          ),
        ],
      ),
    );
  }
}
