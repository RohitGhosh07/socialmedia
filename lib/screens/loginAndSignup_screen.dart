import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class LoginAndSignupScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background image
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                    'assets/images/download (1).gif'), // Replace with your background image path
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                    Colors.black54.withOpacity(0.3), BlendMode.screen),
              ),
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
                  // Sign In Button
                  ElevatedButton.icon(
                    onPressed: () {},
                    icon: FaIcon(FontAwesomeIcons.user, color: Colors.black87),
                    label: Text('Sign In',
                        style: TextStyle(fontSize: 18, color: Colors.black87)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      minimumSize: Size(double.infinity, 55),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                        side:
                            BorderSide(color: Colors.grey.shade400, width: 1.5),
                      ),
                      elevation: 3.0,
                    ),
                  ),
                  SizedBox(height: 15),
                  // Log In Button
                  ElevatedButton.icon(
                    onPressed: () {},
                    icon: FaIcon(FontAwesomeIcons.lock, color: Colors.black87),
                    label: Text('Log In',
                        style: TextStyle(fontSize: 18, color: Colors.black87)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      minimumSize: Size(double.infinity, 55),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                        side:
                            BorderSide(color: Colors.grey.shade400, width: 1.5),
                      ),
                      elevation: 3.0,
                    ),
                  ),
                  SizedBox(height: 15),
                  // Log In with Google Button
                  ElevatedButton.icon(
                    onPressed: () {},
                    icon:
                        FaIcon(FontAwesomeIcons.google, color: Colors.black87),
                    label: Text('Log In with Google',
                        style: TextStyle(fontSize: 18, color: Colors.black87)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      minimumSize: Size(double.infinity, 55),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                        side:
                            BorderSide(color: Colors.grey.shade400, width: 1.5),
                      ),
                      elevation: 3.0,
                    ),
                  ),
                  SizedBox(height: 30),
                  // Additional UI Elements (Optional)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Don’t have an account?',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: Text(
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
