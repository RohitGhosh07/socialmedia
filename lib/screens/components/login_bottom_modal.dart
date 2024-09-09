import 'package:flutter/material.dart';
import 'package:kkh_events/api/routes/login.dart';
import 'package:kkh_events/screens/components/CustomNotification.dart';
import 'package:kkh_events/screens/main_main.dart';

class LoginModal extends StatefulWidget {
  const LoginModal({super.key});

  @override
  _LoginModalState createState() => _LoginModalState();
}

class _LoginModalState extends State<LoginModal> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  Future<void> _login() async {
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    try {
      // Assuming LoginAPI.login() triggers the request and returns a response
      LoginAPI response = await LoginAPI.login(
        context,
        email,
        password,
      );
      if (response.message == "Logged in successfully") {
        CustomNotification.show(context, "Login Successful");

        // Close the modal and send 'true' to indicate success
        Navigator.pop(context, true);
      } else {
        CustomNotification.show(context, "Login Failed: ${response.message}");

        // Close the modal and send 'false' to indicate failure
        Navigator.pop(context, false);
      }
    } catch (e) {
      CustomNotification.show(context, "Error: $e");

      // Close the modal and send 'false' to indicate error
      Navigator.pop(context, false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(30.0),
          topRight: Radius.circular(30.0),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 50,
              height: 5,
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(3),
              ),
            ),
            const Text(
              'Welcome Back!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                labelStyle: const TextStyle(color: Colors.grey),
                filled: true,
                fillColor: Colors.grey[100],
                contentPadding: const EdgeInsets.symmetric(
                    vertical: 16.0, horizontal: 20.0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 15),
            TextFormField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password',
                labelStyle: const TextStyle(color: Colors.grey),
                filled: true,
                fillColor: Colors.grey[100],
                contentPadding: const EdgeInsets.symmetric(
                    vertical: 16.0, horizontal: 20.0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _login,
              child: const Text('Login',
                  style: TextStyle(fontSize: 18, color: Colors.white)),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                backgroundColor: Colors.blueAccent,
                shadowColor: Colors.blueAccent.withOpacity(0.3),
                elevation: 5,
              ),
            ),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: () {
                // Add your "Forgot Password" navigation or logic here
                print("Forgot Password tapped");
              },
              child: const Text(
                'Forgot Password?',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.blueAccent,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
            const SizedBox(height: 10),
            GestureDetector(
              onTap: () {
                // Add your "Sign Up" navigation or logic here
                print("Sign Up tapped");
              },
              child: const Text(
                'Don\'t have an account? Sign Up',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.blueAccent,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
