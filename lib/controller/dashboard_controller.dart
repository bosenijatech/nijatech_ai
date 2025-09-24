import 'package:ai/services/nijatech_ai.dart';
import 'package:get/get.dart';

import '../model/invoice_model.dart';


class DashboardController extends GetxController {
  var suppliers = <Supplier>[].obs;
  var isLoading = true.obs;
  var error = "".obs;

  @override
  void onInit() {
    super.onInit();
    fetchInvoices();
  }

  void fetchInvoices() async {
    try {
      isLoading.value = true;
      error.value = "";

      final data = await apiService.getInvoices();
      suppliers.value = data;
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }
}
