import 'package:flutter/material.dart';
import 'package:joya_app/screens/login_screnn.dart';
import 'package:joya_app/screens/regisdter_screen.dart';
import 'package:joya_app/utils/colors.dart';

class AuthToggleScreen extends StatefulWidget {
  const AuthToggleScreen({super.key});

  @override
  State<AuthToggleScreen> createState() => _AuthToggleScreenState();
}

class _AuthToggleScreenState extends State<AuthToggleScreen> {
  var selectedTab = 'Login';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Go ahead and set up your account',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: primaryColor,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [

          /// Toggle Bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              height: 50,
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(25),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedTab = 'Login';
                        });
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        decoration: BoxDecoration(
                          color: selectedTab == 'Login'
                              ? primaryColor
                              : Colors.white,
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: Center(
                          child: Text(
                            "Login",
                            style: TextStyle(
                              color: selectedTab == 'Login'
                                  ? Colors.white
                                  : Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedTab = 'Register';
                        });
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        decoration: BoxDecoration(
                          color: selectedTab == 'Register'
                              ? primaryColor
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: Center(
                          child: Text(
                            "Register",
                            style: TextStyle(
                              color: selectedTab == 'Register'
                                  ? Colors.white
                                  : Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          Expanded(
            child: selectedTab == 'Login'
                ? LoginScreen()
                : RegisterScreen(),
          ),

        ],
      ),
    );
  }
}
