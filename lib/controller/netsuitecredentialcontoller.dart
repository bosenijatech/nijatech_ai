import 'package:ai/services/nijatech_ai.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class NetsuiteController extends GetxController {
  var loading = false.obs;

  final consumerKey = TextEditingController();
  final consumerSecret = TextEditingController();
  final tokenId = TextEditingController();
  final tokenSecret = TextEditingController();
  final accountId = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    fetchCreds();
  }

  Future<void> fetchCreds() async {
    loading.value = true;
    try {
      final data = await apiService.getCreds();
      consumerKey.text = data['consumerKey'] ?? '';
      consumerSecret.text = data['consumerSecret'] ?? '';
      tokenId.text = data['token'] ?? '';
      tokenSecret.text = data['tokenSecret'] ?? '';
      accountId.text = data['accountId'] ?? '';
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      loading.value = false;
    }
  }

  Future<void> saveCreds() async {
    loading.value = true;
    try {
      final success = await apiService.saveCreds(
        consumerKey: consumerKey.text,
        consumerSecret: consumerSecret.text,
        token: tokenId.text,
        tokenSecret: tokenSecret.text,
        accountId: accountId.text,
      );

      if (success) {
        Get.snackbar('Success', 'Credentials saved');
      } else {
        Get.snackbar('Error', 'Failed to save credentials');
      }
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      loading.value = false;
    }
  }

  Future<void> deleteCreds() async {
    loading.value = true;
    try {
      final success = await apiService.deleteCreds();
      if (success) {
        clearFields();
        Get.snackbar('Success', 'Credentials deleted');
      } else {
        Get.snackbar('Error', 'Failed to delete credentials');
      }
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      loading.value = false;
    }
  }

  void clearFields() {
    consumerKey.clear();
    consumerSecret.clear();
    tokenId.clear();
    tokenSecret.clear();
    accountId.clear();
  }
}
