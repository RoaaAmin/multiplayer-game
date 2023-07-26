import 'dart:async';
import 'package:flutter/material.dart';

class Brick extends StatefulWidget {
  @override
  _BrickState createState() => _BrickState();
}

class _BrickState extends State<Brick> {
  bool _isMovingRight = true;

  @override
  void initState() {
    super.initState();
    // Start the timer when the widget is initialized
    Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        // Toggle the direction of movement
        _isMovingRight = !_isMovingRight;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/levelUp.jpeg'), // Replace 'background2.jpeg' with the path to your background image
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            AnimatedPositioned(
              duration: Duration(seconds: 1), // Animation duration
              curve: Curves.linear,
              left: _isMovingRight
                  ? (MediaQuery.of(context).size.width - MediaQuery.of(context).size.width / 4)
                  : 0,
              top: (MediaQuery.of(context).size.height - 20) / 2,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  color: Colors.amberAccent,
                  height: 20,
                  width: MediaQuery.of(context).size.width / 4,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
