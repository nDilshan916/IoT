import 'package:flutter/material.dart';
import 'package:iot/components/bottom_bar.dart';

class SwitchPage extends StatelessWidget {
  static const String id = 'SwitchPage';
  const SwitchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'Switch Page',
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
                'images/background.png'), // Replace with your image path
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'images/AC switch.png',
                            // Adjust width and height if needed
                            width: 100,
                            height: 100,
                          ),
                          SizedBox(
                              height: 8), // Add some space between image and text
                          Text(
                            'AC',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [

                          Image.asset(
                            'images/fan switch.png',
                            // Adjust width and height if needed
                            width: 100,
                            height: 100,
                          ),
                          SizedBox(
                              height: 8), // Add some space between image and text
                          Text(
                            'Fan',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                )),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'images/light switch.png',
                    // Adjust width and height if needed
                    width: 100,
                    height: 100,
                  ),
                  SizedBox(height: 8), // Add some space between image and text
                  Text(
                    'Light',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'images/living room switch.png',
                          // Adjust width and height if needed
                          width: 100,
                          height: 100,
                        ),
                        SizedBox(height: 8), // Add some space between image and text
                        Text(
                          'Living Room',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'images/room switch.png',
                          // Adjust width and height if needed
                          width: 100,
                          height: 100,
                        ),
                        SizedBox(height: 8), // Add some space between image and text
                        Text(
                          'Room',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),),
                ],
              ),
            ),
            bottomBar(currentPageId: id),
          ],
        ),
      ),
    );
  }
}
