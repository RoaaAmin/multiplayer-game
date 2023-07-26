// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:multiplayer_games_flutter/screens/home.dart';

class StartPage extends StatelessWidget {
  const StartPage({super.key});

  static String screenRoute = "/start_page";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/background3.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  "Mini Games",
                  style: GoogleFonts.coiny(
                    textStyle: TextStyle(
                      color: Color(0xffF69819),
                      letterSpacing: 3,
                      fontSize: 45,
                    ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Color(0xffFEBE69),
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 50.0, vertical: 10),
                    child: TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, HomeScreen.screenRoute);
                      },
                      child: Text(
                        "Play",
                        style: GoogleFonts.coiny(
                          textStyle: TextStyle(
                            color: Color(0xffEC5F4E),
                            letterSpacing: 3,
                            fontSize: 55,
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
      ),
    );
  }
}
