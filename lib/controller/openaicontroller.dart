import 'package:ai/services/nijatech_ai.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OpenaiController extends GetxController {
  var loading = false.obs;

  final apikey = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    getApiKey();
  }

  Future<void> getApiKey() async {
    loading.value = true;
    try {
      final data = await apiService.getapikey();
      apikey.text = data['apiKey'] ?? ''; 
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      loading.value = false;
    }
  }

  Future<void> saveApiKey() async {
    loading.value = true;
    try {
      final success = await apiService.saveapikey(
        apiKey: apikey.text,
      );

      if (success) {
        Get.snackbar('Success', 'API Key saved');
      } else {
        Get.snackbar('Error', 'Failed to save API Key');
      }
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      loading.value = false;
    }
  }

  Future<void> deleteApiKey() async {
    loading.value = true;
    try {
      final success = await apiService.deleteapikey(); // corrected
      if (success) {
        clearFields();
        Get.snackbar('Success', 'API Key deleted');
      } else {
        Get.snackbar('Error', 'Failed to delete API Key');
      }
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      loading.value = false;
    }
  }

  void clearFields() {
    apikey.clear();
  }
}
