import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import '../../services/nijatech_ai.dart';
import '../widgets/app_utils.dart';

class GoogleCredsController extends GetxController {
  var creds = <dynamic>[].obs; // store API data
  var loading = true.obs;

  final emailUser = ''.obs;
  final emailPass = ''.obs;
  final emailHost = ''.obs;

  @override
  void onInit() {
    super.onInit();
    getallgooglecred();
  }

  //get
  void getallgooglecred() async {
    try {
      loading.value = true;
      final response = await apiService.getallgooglecreds();

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        creds.value = data['googleCreds'] ?? [];
      } else {
        print("Error: ${response.statusCode}");
      }
    } catch (e) {
      print("Exception: $e");
    } finally {
      loading.value = false;
    }
  }

  //add
  Future<bool> addgooglecreds(String user, String pass, String host) async {
    try {
      loading.value = true;

      // Wrap your object in a list
      final body = [
        {"emailUser": user, "emailPass": pass, "host": host},
      ];

      final response = await apiService.addgooglecreds(body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return true; // success
      } else {
        print("Failed to add: ${response.body}");
        return false;
      }
    } catch (e) {
      print("Exception: $e");
      return false;
    } finally {
      loading.value = false;
    }
  }

  //edit
  Future<bool> editgooglecreds(
    int index,
    String user,
    String pass,
    String host,
  ) async {
    try {
      final cred = creds[index];
      final id = cred['_id'];
      final body = {"emailUser": user, "emailPass": pass, "emailHost": host};
      final response = await apiService.editgooglecreds(id, body);

      if (response.statusCode == 200) {
        // Update local list
        creds[index] = {
          ...creds[index],
          "emailUser": user,
          "emailPass": pass,
          "emailHost": host,
          "addedAt": DateTime.now().toIso8601String(),
        };
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  //delete

  Future<bool> deleteCred(int index) async {
  try {
    final cred = creds[index];
    final id = cred['_id']; // backend ID
    final response = await apiService.deletegooglecreds(id);

    if (response.statusCode == 200 || response.statusCode == 204) {
      // Re-fetch the updated list from backend
       getallgooglecred();

      Get.snackbar(
        'Deleted',
        'Credential deleted successfully',
        snackPosition: SnackPosition.BOTTOM,
      );
      return true;
    } else {
      Get.snackbar(
        'Error',
        'Failed to delete credential',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    }
  } catch (e) {
    Get.snackbar(
      'Error',
      'Something went wrong',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red,
      colorText: Colors.white,
    );
    return false;
  }
}


}
