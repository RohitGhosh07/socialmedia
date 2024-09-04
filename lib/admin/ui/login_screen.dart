import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:kkh_events/admin/class/login_api_class.dart';
import 'package:kkh_events/admin/custom_widgets.dart';
import 'package:kkh_events/admin/routes/routes.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Card Container
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 10,
                        offset: Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Upper Half - Image
                      ClipRRect(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                        ),
                        child: Image.asset(
                          'assets/images/KKH Events.png',
                          height: MediaQuery.of(context).size.height * 0.25,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Heading - KKH Admin Panel
                      const Text(
                        'KKH Admin Panel',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      // Sub Heading - Login
                      const Text(
                        'Login',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Input Field - Username (Rounded)
                      TextField(
                        controller: usernameController,
                        decoration: InputDecoration(
                          labelText: 'Username',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          prefixIcon: Icon(Icons.person),
                        ),
                      ),
                      const SizedBox(height: 15),
                      // Input Field - Password (Rounded)
                      TextField(
                        controller: passwordController,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          prefixIcon: Icon(Icons.lock),
                        ),
                        obscureText: true,
                      ),
                      const SizedBox(height: 20),
                      // Button - Login
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          foregroundColor: Colors.white,
                          minimumSize: Size(double.infinity, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        icon: const FaIcon(FontAwesomeIcons.signInAlt),
                        onPressed: () {
                          loginUser();
                        },
                        label: const Text('Login'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  bool validate() {
    if (usernameController.text.trim().isEmpty) {
      CustomWidgets.errorSnackBar(content: 'Username is required');
      return false;
    }
    if (passwordController.text.trim().isEmpty) {
      CustomWidgets.errorSnackBar(content: 'Password is required');
      return false;
    }
    return true;
  }

  void loginUser() {
    // unfocus keyboard
    FocusScope.of(context).unfocus();
    if (validate()) {
      CustomWidgets.showLoadingLoader();
      // Call API to login
      LoginApiClass.loginApi(
              usernameController.text.trim(), passwordController.text.trim())
          .then((value) {
        Get.back();
        if (value?.success == true) {
          CustomWidgets.successSnackBar(content: value?.message ?? '');
          LoginApiClass.saveData(value ?? LoginApiClass());
          Future.delayed(const Duration(seconds: 1), () {
            Get.back();
            Get.offAllNamed(Routes.splash);
          });
        } else {
          CustomWidgets.errorSnackBar(content: value?.message ?? '');
        }
      });
    }
  }
}
