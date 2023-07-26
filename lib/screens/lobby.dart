// ignore_for_file: use_key_in_widget_constructors, must_be_immutable, prefer_const_constructors, sort_child_properties_last

import 'package:flutter/material.dart';
import '../constants.dart';
import '../screens/game.dart';

class LobbyScreen extends StatelessWidget {
  static String screenRoute = "/lobby-screen";

  TextEditingController textPlayer1 = TextEditingController();
  TextEditingController textPlayer2 = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            'Game',
            style: customFontWhite,
          ),
        ),
        backgroundColor: MainColor.primaryColor,
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/background.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                width: 300,
                decoration: BoxDecoration(
                  color: Color(0xff6CCCCF),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    textAlign: TextAlign.center,
                    controller: textPlayer1,
                    cursorColor: Colors.black,
                    decoration: InputDecoration(
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      hintText: "name of player 1",
                    ),
                  ),
                ),
              ),
              Container(
                width: 300,
                decoration: BoxDecoration(
                  color: Color(0xffFEBD69),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    textAlign: TextAlign.center,
                    controller: textPlayer2,
                    cursorColor: Colors.black,
                    decoration: InputDecoration(
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      hintText: "name of player 2",
                    ),
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pushNamed(
                    GameScreen.screenRoute,
                    arguments: {
                      'player1': textPlayer1.text.isNotEmpty
                          ? textPlayer1.text
                          : "Player 1",
                      'player2': textPlayer2.text.isNotEmpty
                          ? textPlayer2.text
                          : "Player 2",
                    },
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Text(
                    'start game',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                    Color(0xff3B1D7F),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
