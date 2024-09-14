import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:kkh_events/screens/components/CustomNotification.dart';
import 'package:kkh_events/screens/components/bottom_modal_sign_up_form.dart';
import 'package:kkh_events/screens/components/login_bottom_modal.dart';
import 'package:kkh_events/screens/main_main.dart';

class LoginAndSignupScreen extends StatelessWidget {
  const LoginAndSignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background image
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: const AssetImage(
                    'assets/images/loginbg.gif'), // Replace with your background image path
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                    Colors.black54.withOpacity(0.3), BlendMode.screen),
              ),
            ),
          ),
          // Centered logo
          Align(
            alignment: Alignment.center,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  'assets/images/naiyorounded.png', // Replace with your logo image path
                  height: 150, // Set the desired height of the logo
                ),
                const SizedBox(
                    height: 30), // Spacing between the logo and the buttons
              ],
            ),
          ),
          // Content
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ElevatedButton.icon(
                    onPressed: () async {
                      bool? result = await showModalBottomSheet<bool>(
                        context: context,
                        isScrollControlled: true,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20.0),
                            topRight: Radius.circular(20.0),
                          ),
                        ),
                        builder: (BuildContext context) {
                          return Padding(
                            padding: EdgeInsets.only(
                              bottom: MediaQuery.of(context).viewInsets.bottom,
                            ), // Adjust for keyboard
                            child:
                                const LoginModal(), // Use the bottom modal form here
                          );
                        },
                      );

                      if (result == true) {
                        // If login was successful, navigate to the main screen
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                MainMainScreen(), // Replace with your main screen
                          ),
                        );
                      } else {
                        // Optionally handle failed login here
                        CustomNotification.show(
                            context, "Please try logging in again.");
                      }
                    },
                    icon: const FaIcon(FontAwesomeIcons.lock,
                        color: Colors.black87),
                    label: const Text(
                      'Log In',
                      style: TextStyle(fontSize: 18, color: Colors.black87),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 55),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                        side:
                            BorderSide(color: Colors.grey.shade400, width: 1.5),
                      ),
                      elevation: 3.0,
                    ),
                  ),

                  const SizedBox(height: 15),
                  // Log In with Google Button
                  ElevatedButton.icon(
                    onPressed: () {},
                    icon: const FaIcon(FontAwesomeIcons.google,
                        color: Colors.black87),
                    label: const Text('Log In with Google',
                        style: TextStyle(fontSize: 18, color: Colors.black87)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 55),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                        side:
                            BorderSide(color: Colors.grey.shade400, width: 1.5),
                      ),
                      elevation: 3.0,
                    ),
                  ),
                  const SizedBox(height: 30),
                  // Additional UI Elements (Optional)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Don’t have an account?',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                      TextButton(
                        onPressed: () {
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(20.0),
                                topRight: Radius.circular(20.0),
                              ),
                            ),
                            builder: (BuildContext context) {
                              return Padding(
                                padding: EdgeInsets.only(
                                  bottom:
                                      MediaQuery.of(context).viewInsets.bottom,
                                ), // Adjust for keyboard
                                child:
                                    BottomModalSignupForm(), // Use the bottom modal form here
                              );
                            },
                          );
                        },
                        child: const Text(
                          'Sign Up',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16),
                        ),
                      ),
                    ],
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
