import 'package:flutter/material.dart';
import 'package:iot/pages/logIn/signUpPage.dart';

import 'logInPage.dart';


class InitialPage extends StatelessWidget {
  static const String id = 'InitialPage';

  const InitialPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                  'images/background.png'), // Replace with your image path
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              const Center(
                child: Image(
                  image: AssetImage('images/logo.png'),
                ),
              ),
              const Text(
                "Welcome Back",
                style: TextStyle(
                    fontSize: 30.0,
                    fontWeight: FontWeight.w400,
                    color: Colors.white),
              ),
              const SizedBox(
                height: 20.0,
              ),
              SizedBox(
                width: 200.0,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    elevation: 2,
                    backgroundColor: Colors.transparent,
                    side: const BorderSide(
                      color: Colors.white,
                      width: 2.0
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(50.0),
                    ),
                  ),
                  onPressed: () {
                    Navigator.pushNamed(context, SignUpPage.id);
                  },
                  child: const Text('Sign Up',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20.0,
                      color: Colors.white
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 200.0,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius:
                      BorderRadius.circular(50.0),
                    ),
                  ),
                  onPressed: () {
                    Navigator.pushNamed(context, LogInPage.id);
                  },
                  child: const Text('Log In',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20.0,
                      color: Colors.black
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 80.0,
              )
            ],
          )),
    );
  }
}
