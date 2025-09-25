import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppLoader {
  AppLoader._privateConstructor();
  static final AppLoader instance = AppLoader._privateConstructor();

  bool _isDialogOpen = false;

  void showLoader({String? message}) {
    if (_isDialogOpen) return; // prevent multiple dialogs
    _isDialogOpen = true;

    Get.dialog(
      Center(
        child: Container(
          width: 120,
          height: 120,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Your image in the center
              Image.asset(
                "assets/logo.png", // put your image here
                height: 40,
              ),
              const SizedBox(height: 12),
              const CircularProgressIndicator(),
              if (message != null) ...[
                const SizedBox(height: 8),
                Text(
                  message,
                  style: const TextStyle(fontSize: 14),
                  textAlign: TextAlign.center,
                ),
              ],
            ],
          ),
        ),
      ),
      barrierDismissible: false,
    ).then((_) {
      _isDialogOpen = false;
    });
  }

  void hideLoader() {
    if (_isDialogOpen) {
      _isDialogOpen = false;
      Get.back();
    }
  }
}
