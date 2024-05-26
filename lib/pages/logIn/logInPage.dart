import 'package:flutter/material.dart';
import 'package:iot/pages/logIn/signUpPage.dart';

class LogInPage extends StatefulWidget {
  const LogInPage({Key? key}) : super(key: key);
  static const String id = 'LogInPage';

  @override
  State<LogInPage> createState() => _LogInPageState();
}

class _LogInPageState extends State<LogInPage> {
   String email = '';
   String password = '';
  bool isPasswordVisible = false;

  // Specific email to verify against
  static const String specificEmail = 'example@example.com';
  bool isEmailVerified = false;

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
                'Hello\nSign in!',
                style: TextStyle(
                    fontSize: 30,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 200.0),
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
                      keyboardType: TextInputType.emailAddress,
                      onChanged: (value) {
                        setState(() {
                          email = value;
                          isEmailVerified = (email == specificEmail);
                        });
                      },
                      decoration: InputDecoration(
                        suffixIcon: Icon(
                          isEmailVerified ? Icons.check : Icons.check_circle_outline,
                          color: isEmailVerified ? Colors.green : Colors.grey,
                        ),
                        label: Text(
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
                        password = value;
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
                    const Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        'Forgot Password?',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 17,
                          color: Color(0xff281537),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 70,
                    ),
                    signButton(
                      email: email,
                      password: password,
                      onTap: () {
                        // Verify email and password
                        if (isEmailVerified) {
                          print('Email is verified');
                          // Here you can add further verification logic for the password
                          print(password);
                        } else {
                          print('Email is not verified');
                          // Handle incorrect email address
                        }
                      },
                    ),
                    const SizedBox(height: 20.0),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          const Text(
                            "Don't have account?",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.grey),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(context, SignUpPage.id);
                            },
                            child: const Text(
                              "Sign up",
                              style: TextStyle(
                                ///done login page
                                  fontWeight: FontWeight.bold,
                                  fontSize: 17,
                                  color: Colors.black),
                            ),
                          ),
                        ],
                      ),
                    ),
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

class signButton extends StatelessWidget {
  const signButton(
      {Key? key,
        required this.email,
        required this.password,
        required this.onTap});

  final String email;
  final String password;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(top: 95.0),
        height: 55,
        width: 300,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          gradient: const LinearGradient(colors: [
            Color(0xffB81736),
            Color(0xff281537),
          ]),
        ),
        child: const Center(
          child: Text(
            'SIGN IN',
            style: TextStyle(
                fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
