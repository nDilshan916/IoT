import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../homePage.dart';
import 'logInPage.dart';

class SignUpPage extends StatefulWidget {
  static const String id = 'SignUpPage';

  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _auth = FirebaseAuth.instance;
  String username = '';
  String email = '';
  String password = '';
  late String confirmPassword;
  bool isPasswordVisible = false;
  bool isConfirmPasswordVisible = false;
  bool isEmailVerified = false;

  static const String specificEmail = 'example@example.com';

  Future<void> _saveUserName(String name) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('userName', name);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: double.infinity,
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(colors: [
                Color(0xffB81736),
                Color(0xff281537),
              ]),
            ),
            child: const Padding(
              padding: EdgeInsets.only(top: 60.0, left: 22),
              child: Text(
                'Create Your\nAccount',
                style: TextStyle(
                    fontSize: 35,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 250.0),
            child: Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40)),
                color: Colors.white,
              ),
              height: double.infinity,
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.only(left: 18.0, right: 18),
                child: ListView(
                  children: [
                    TextField(
                      onChanged: (value) {
                        setState(() {
                          username = value;
                        });
                      },
                      decoration: const InputDecoration(
                        label: Text(
                          'User Name',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xffB81736),
                          ),
                        ),
                      ),
                    ),
                    TextField(
                      onChanged: (value) {
                        setState(() {
                          email = value;
                          isEmailVerified = (email == specificEmail);
                        });
                      },
                      decoration: InputDecoration(
                        suffixIcon: Icon(
                          isEmailVerified
                              ? Icons.check
                              : Icons.check_circle_outline,
                          color: isEmailVerified ? Colors.green : Colors.grey,
                        ),
                        label: const Text(
                          'Gmail',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xffB81736),
                          ),
                        ),
                      ),
                    ),
                    TextField(
                      obscureText: !isPasswordVisible,
                      onChanged: (value) {
                        setState(() {
                          password = value;
                        });
                      },
                      decoration: InputDecoration(
                        suffixIcon: GestureDetector(
                          onTap: () {
                            setState(() {
                              isPasswordVisible = !isPasswordVisible;
                            });
                          },
                          child: Icon(
                            isPasswordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: Colors.grey,
                          ),
                        ),
                        label: const Text(
                          'Password',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xffB81736),
                          ),
                        ),
                      ),
                    ),
                    TextField(
                      obscureText: !isConfirmPasswordVisible,
                      onChanged: (value) {
                        setState(() {
                          confirmPassword = value;
                        });
                      },
                      decoration: InputDecoration(
                        suffixIcon: GestureDetector(
                          onTap: () {
                            setState(() {
                              isConfirmPasswordVisible =
                              !isConfirmPasswordVisible;
                            });
                          },
                          child: Icon(
                            isConfirmPasswordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: Colors.grey,
                          ),
                        ),
                        label: const Text(
                          'Confirm Password',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xffB81736),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const SizedBox(
                      height: 70,
                    ),
                    signUpButton(
                      username: username,
                      email: email,
                      password: password,
                      onTap: () async {
                        if ((email == specificEmail) &&
                            (password == confirmPassword)) {
                          try {
                            final newUser =
                            await _auth.createUserWithEmailAndPassword(
                                email: email, password: password);
                            await _saveUserName(username); // Save username
                            Navigator.pushNamed(context, HomePage.id);
                          } catch (e) {
                            print(e);
                          }
                        } else {
                          Alert(
                            context: context,
                            type: AlertType.error,
                            title: "ALERT",
                            desc: "Check the email and password again!",
                            buttons: [
                              DialogButton(
                                onPressed: () => Navigator.pop(context),
                                width: 120,
                                child: const Text(
                                  "Close",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 20),
                                ),
                              )
                            ],
                          ).show();
                        }
                      },
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          const Text(
                            "Already have account?",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.grey),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(context, LogInPage.id);
                            },
                            child: const Text(
                              "Log In",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 17,
                                  color: Colors.black),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class signUpButton extends StatelessWidget {
  const signUpButton({
    super.key,
    required this.username,
    required this.email,
    required this.password,
    required this.onTap,
  });

  final String username;
  final String email;
  final String password;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 55,
        width: 200,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          gradient: const LinearGradient(colors: [
            Color(0xffB81736),
            Color(0xff281537),
          ]),
        ),
        child: const Center(
          child: Text(
            'SIGN UP',
            style: TextStyle(
                fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
