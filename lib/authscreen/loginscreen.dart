import 'dart:convert';
import 'package:ai/services/nijatech_ai.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../constant/app_assets.dart';
import '../constant/app_color.dart';
import '../model/loginmodel.dart';
import '../screens/adminscreen/adminscreen.dart';
import '../widgets/app_utils.dart';

class Loginscreen extends StatefulWidget {
  const Loginscreen({super.key});

  @override
  State<Loginscreen> createState() => _LoginscreenState();
}

class _LoginscreenState extends State<Loginscreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _obscureText = true;
  bool loading = false;

  // ---------------- LOGIN FUNCTION ----------------

  void login() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      AppUtils.showSingleDialogPopup(
        context,
        "Error",
        "OK",
        () => Navigator.pop(context),
        null,
      );
      return;
    }

    setState(() => loading = true);

    try {
      final response = await apiService.login(email, password);
      setState(() => loading = false);

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);

        if (jsonResponse.containsKey("access_token")) {
          // ✅ Success
          final loginModel = LoginModel.fromJson(jsonResponse);

          final prefs = await SharedPreferences.getInstance();
          await prefs.setString("name", email);
          await prefs.setString("accessToken", loginModel.accessToken);
          await prefs.setString("tokenType", loginModel.tokenType);

          Get.offAllNamed('/admin');
        } else {
          // ❌ Wrong username/password
          final errorMsg = jsonResponse["detail"] ?? "Invalid credentials";
          AppUtils.showSingleDialogPopup(
            context,
            errorMsg,
            "OK",
            () => Navigator.pop(context),
            null,
          );
        }
      } else {
        // ❌ Server error
        final jsonResponse = jsonDecode(response.body);
        final errorMsg =
            jsonResponse["detail"] ?? "Server error: ${response.statusCode}";
        AppUtils.showSingleDialogPopup(
          context,
          errorMsg,
          "OK",
          () => Navigator.pop(context),
          null,
        );
      }
    } catch (e) {
      setState(() => loading = false);
      AppUtils.showSingleDialogPopup(
        context,
        e.toString(),
        "OK",
        () => Navigator.pop(context),
        null,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background image
          SizedBox.expand(
            child: Image.asset(AppAssets.gradient_bg, fit: BoxFit.cover),
          ),

          // Semi-transparent overlay
          Container(color: Colors.black.withOpacity(0.3)),

          // Centered login card
          Center(
            child: Container(
              width: 430,
              padding: const EdgeInsets.all(30),
              decoration: BoxDecoration(
                color: AppColor.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    spreadRadius: 2,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    "Login",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Provide Email And Password To Access Admin Panel",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: AppColor.darkGrey,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Email Field
                  TextField(
                    controller: emailController,
                    cursorColor: AppColor.primary,
                    decoration: InputDecoration(
                      hintText: "hi@gmail.com",
                      hintStyle: TextStyle(color: AppColor.litgrey),
                      suffixIcon: const Icon(
                        Icons.person,
                        color: AppColor.grey,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: AppColor.primary),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Password Field
                  TextField(
                    controller: passwordController,
                    obscureText: _obscureText,
                    cursorColor: AppColor.primary,
                    decoration: InputDecoration(
                      hintText: "********",
                      hintStyle: TextStyle(color: AppColor.litgrey),
                      prefixIcon: Icon(Icons.lock, color: AppColor.litgrey),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureText
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: AppColor.grey,
                        ),
                        onPressed: () {
                          setState(() => _obscureText = !_obscureText);
                        },
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: AppColor.primary),
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),

                  // Forgot Password
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () {},
                        child: Text(
                          "Forgot Password",
                          style: TextStyle(color: AppColor.grey),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Login Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: login,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColor.primary,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: loading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text(
                              "Login",
                              style: TextStyle(
                                fontSize: 16,
                                color: AppColor.white,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
