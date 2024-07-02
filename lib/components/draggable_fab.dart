import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/scheduler.dart';
import '../pages/settingPages/techSup/chat.dart';

class DraggableFloatingActionButton extends StatefulWidget {
  @override
  _DraggableFloatingActionButtonState createState() =>
      _DraggableFloatingActionButtonState();
}

class _DraggableFloatingActionButtonState
    extends State<DraggableFloatingActionButton> with TickerProviderStateMixin {
  Offset offset = Offset(30, 30); // Initial position of the FAB
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _loadOffset();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..repeat(reverse: true);
    _animation = Tween<double>(begin: 0.5, end: 1.5).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _loadOffset() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      offset = Offset(
        prefs.getDouble('fab_dx') ?? 30,
        prefs.getDouble('fab_dy') ?? 30,
      );
    });
  }

  void _saveOffset(Offset newOffset) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('fab_dx', newOffset.dx);
    await prefs.setDouble('fab_dy', newOffset.dy);
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: offset.dx,
      top: offset.dy,
      child: Draggable(
        feedback: FloatingActionButton(
          onPressed: () {},
          backgroundColor: Colors.blueGrey[800],
          child: Stack(
              alignment: Alignment.center,
              fit: StackFit.expand,
              children: [
                Icon(
                  FontAwesomeIcons.message,
                  color: Colors.white,
                  size: 30,
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 5),
                  child: Icon(
                    FontAwesomeIcons.robot,
                    size: 10,
                    color: Colors.white,
                  ),
                )
              ]
          ),
        ),
        child: FloatingActionButton(
          onPressed: () {
            Navigator.pushNamed(context, ChatScreen.id);
          },
          backgroundColor: Colors.blueGrey[800],
          child: ScaleTransition(
            scale: _animation,
            child: Stack(
              alignment: Alignment.center,
              fit: StackFit.expand,
              children: [
                Icon(
                FontAwesomeIcons.message,
                color: Colors.white,
              ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 5),
                  child: Icon(
                    FontAwesomeIcons.robot,
                    size: 10,
                    color: Colors.white,
                  ),
                )
              ]
            ),
          ),
        ),
        childWhenDragging: Container(),
        onDraggableCanceled: (Velocity velocity, Offset newOffset) {
          final screenWidth = MediaQuery.of(context).size.width;
          final screenHeight = MediaQuery.of(context).size.height;
          final buttonSize = 56.0; // Default size of FAB

          // Calculate the nearest edge (left or right)
          double finalX = newOffset.dx;
          if (newOffset.dx + buttonSize / 2 < screenWidth / 2) {
            // Snap to left edge
            finalX = 0;
          } else {
            // Snap to right edge
            finalX = screenWidth - buttonSize;
          }

          // Ensure the FAB stays within vertical bounds
          double finalY = newOffset.dy;
          if (finalY < 0) {
            finalY = 0;
          } else if (finalY > screenHeight - buttonSize) {
            finalY = screenHeight - buttonSize;
          }

          setState(() {
            offset = Offset(finalX, finalY);
          });

          _saveOffset(Offset(finalX, finalY));
        },
      ),
    );
  }
}
