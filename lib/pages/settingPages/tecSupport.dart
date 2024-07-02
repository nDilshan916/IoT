import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iot/components/bottom_bar.dart';
import 'package:iot/pages/settingPages/tecSupport.dart';
import 'package:iot/pages/settingPages/techSup/chat.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class TecSupport extends StatefulWidget {
  static const String id = 'TecSupport';

  const TecSupport({super.key});

  @override
  State<TecSupport> createState() => _TecSupportState();
}

class _TecSupportState extends State<TecSupport> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tec Support'),
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/background.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              height: 50,
            ),
            SizedBox(
              height: 350,
              child: Card(
                margin: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50),
                ),
                color: Colors.blueGrey[900],
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      'Contact Us',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 30,
                          fontStyle: FontStyle.italic),
                    ),
                    TechCard(
                      icon: Icon(Icons.mail),
                      text: 'Mail Us',
                    ),
                    TechCard(
                      icon: Icon(Icons.call),
                      text: 'Call Us',
                    ),
                    TechCard(
                      icon: Icon(FontAwesomeIcons.whatsapp),
                      text: 'Send Us',
                    ),
                    ElevatedButton(
                      onPressed: () {
                        // Navigator.pushNamed(context, ChatScreen.id);
                      },
                      child: const Text('Chat with AI'),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 50,
            ),
            bottomBar(currentPageId: TecSupport.id),
          ],
        ),
      ),
    );
  }
}

class TechCard extends StatelessWidget {
  const TechCard({
    super.key,
    required this.icon,
    required this.text,
  });

  final Icon icon;
  final String text;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 250,
      child: ElevatedButton(
        onPressed: () {},
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            icon,
            SizedBox(
              width: 10,
            ),
            Text(text)
          ],
        ),
      ),
    );
  }
}
