import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../constant/app_color.dart';
import '../../../controller/googlecredentialcontroller.dart';
import '../../../services/nijatech_ai.dart';

class Googlecredentialscreen extends StatefulWidget {
  const Googlecredentialscreen({super.key});

  @override
  State<Googlecredentialscreen> createState() => _GooglecredentialscreenState();
}

class _GooglecredentialscreenState extends State<Googlecredentialscreen> {
  final _formKey = GlobalKey<FormState>();
  final GoogleCredsController controller = Get.put(GoogleCredsController());

  final TextEditingController emailuser = TextEditingController();
  final TextEditingController emailpass = TextEditingController();
  final TextEditingController emailhost = TextEditingController();
  int? editIndex; // null means adding new, not editing

  bool _obscureText = true;

  // Save function
  void _addCreds() async {
    if (_formKey.currentState!.validate()) {
      bool success;
      if (editIndex != null) {
        // Editing existing credential
        success = await controller.editgooglecreds(
          editIndex!,
          emailuser.text.trim(),
          emailpass.text.trim(),
          emailhost.text.trim(),
        );
      } else {
        // Adding new credential
        success = await controller.addgooglecreds(
          emailuser.text.trim(),
          emailpass.text.trim(),
          emailhost.text.trim(),
        );
      }

      if (success) {
        controller.getallgooglecred();
        _clearFields();
        setState(() => editIndex = null); // reset after edit
        Get.snackbar(
          'Success',
          editIndex != null
              ? 'Credential updated successfully'
              : 'Credential added successfully',
          snackPosition: SnackPosition.BOTTOM,
        );
      } else {
        Get.snackbar(
          'Error',
          'Failed to save credential',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    }
  }

  void _clearFields() {
    emailuser.clear();
    emailpass.clear();
    emailhost.clear();
  }

  InputDecoration _inputDecoration({
    required String hint,
    bool isPassword = false,
  }) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: AppColor.litgrey),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColor.primary),
      ),
      suffixIcon: isPassword
          ? IconButton(
              icon: Icon(
                _obscureText ? Icons.visibility_off : Icons.visibility,
                color: AppColor.primary,
              ),
              onPressed: () {
                setState(() {
                  _obscureText = !_obscureText;
                });
              },
            )
          : null,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: Padding(
        padding: const EdgeInsets.all(24.0), // same padding for all sides
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Left container (form) at top
            Container(
              width: 400, // fixed width for form
              padding: const EdgeInsets.all(24), // unified padding
              decoration: BoxDecoration(
                color: AppColor.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    blurRadius: 15,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min, // fit content
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "EMAIL USER",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: emailuser,
                      cursorColor: AppColor.primary,
                      decoration: _inputDecoration(hint: 'EMAIL USER'),
                      validator: (value) =>
                          value!.isEmpty ? 'Enter value' : null,
                    ),
                    const SizedBox(height: 15),
                    const Text(
                      "EMAIL PASSWORD",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      obscureText: _obscureText,
                      controller: emailpass,
                      cursorColor: AppColor.primary,
                      decoration: _inputDecoration(
                        hint: 'MAIL PASSWORD',
                        isPassword: true,
                      ),
                      validator: (value) =>
                          value!.isEmpty ? 'Enter value' : null,
                    ),
                    const SizedBox(height: 15),
                    const Text(
                      "EMAIL HOST",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: emailhost,
                      cursorColor: AppColor.primary,
                      decoration: _inputDecoration(hint: 'EMAIL HOST'),

                      validator: (value) =>
                          value!.isEmpty ? 'Enter value' : null,
                    ),
                    const SizedBox(height: 25),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          onPressed: _clearFields,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 32,
                              vertical: 12,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            'Clear',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: _addCreds,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColor.primary,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 32,
                              vertical: 12,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                           editIndex != null ? 'Save' : 'Add', // dynamically show text
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(width: 24), // spacing between left and right
            // Right side (grid)
            Expanded(
              child: Obx(() {
                if (controller.loading.value) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (controller.creds.isEmpty) {
                  return const Center(child: Text("No credentials found"));
                }

                return GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childAspectRatio: 4,
                  ),
                  itemCount: controller.creds.length,
                  itemBuilder: (context, index) {
                    final cred = controller.creds[index];
                    return Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.3),
                            blurRadius: 15,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.all(10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                cred['emailUser'] ?? 'No Email',
                                style: const TextStyle(fontSize: 16),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                cred['emailHost'] ?? 'No Date',
                                style: const TextStyle(color: Colors.grey),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              MouseRegion(
                                cursor: SystemMouseCursors.click,
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      editIndex =
                                          index; // track which credential is being edited
                                      final cred = controller.creds[index];
                                      emailuser.text = cred['emailUser'] ?? '';
                                      emailpass.text = cred['emailPass'] ?? '';
                                      emailhost.text = cred['emailHost'] ?? '';
                                      _obscureText =
                                          true; // keep password hidden initially
                                    });
                                  },
                                  child: const Icon(
                                    Icons.edit,
                                    color: Colors.blue,
                                    size: 20,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              MouseRegion(
                                cursor: SystemMouseCursors.click,
                                child: GestureDetector(
                                  onTap: () => controller.deleteCred(index),
                                  child: const Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                    size: 20,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
