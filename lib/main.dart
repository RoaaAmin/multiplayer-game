import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flame/game.dart';
import 'package:flame_realtime_shooting/game/game.dart';
import 'package:flame_realtime_shooting/person.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

import 'package:social_share/social_share.dart';
import 'boxes.dart';
import 'game/brick.dart'; // Import the 'social_share' package if you haven't already.

void main() async {
  await Supabase.initialize(
    url: 'https://xamfvrmdcjekpzsczrmh.supabase.co',
    anonKey:
    'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InhhbWZ2cm1kY2pla3B6c2N6cm1oIiwicm9sZSI6ImFub24iLCJpYXQiOjE2OTAxNzMwNzIsImV4cCI6MjAwNTc0OTA3Mn0.BSiS_mMcKnonxwqu9FRbXKrDZNMNd-YPnr10-lcYRYc',
    realtimeClientOptions: const RealtimeClientOptions(eventsPerSecond: 40),
  );
  Hive.initFlutter();
  Hive.registerAdapter(PersonAdapter());
  boxPersons = await Hive.openBox<Person>('personBox');
  runApp(const MyApp());
}

final supabase = Supabase.instance.client;

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'UFO Shooting Game',
      debugShowCheckedModeBanner: false,
      home: GamePage(),
    );
  }
}


class GamePage extends StatefulWidget {
  const GamePage({Key? key}) : super(key: key);

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  late final MyGame _game;
  late int num = 0;
  late String img;
  bool _playSound = true;

  void sound(String path){
    final player = AudioPlayer();
    player.play(UrlSource('assets/audio/blaster-2-81267.mp3'));

  }


  /// Holds the RealtimeChannel to sync game states
  RealtimeChannel? _gameChannel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
              boxPersons.length > 5
                  ? img = 'assets/images/levelUp.jpeg'
                  : img = 'assets/images/background2.jpeg',
              fit: BoxFit.cover),
          GameWidget(game: _game),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    _game = MyGame(
      onGameStateUpdate: (position, health) async {
        ChannelResponse response;
        do {
          response = await _gameChannel!.send(
            type: RealtimeListenTypes.broadcast,
            event: 'game_state',
            payload: {'x': position.x, 'y': position.y, 'health': health},
          );

          // wait for a frame to avoid infinite rate limiting loops
          await Future.delayed(Duration.zero);
          setState(() {});
        } while (response == ChannelResponse.rateLimited && health <= 0);
      },
      onGameOver: (playerWon) async {
        num++;
        setState(() {
          boxPersons.put(
              'key_$num',
              Person(
                score: num,
              ));
        });
        await showDialog(
          barrierDismissible: false,
          context: context,
          builder: ((context) {
            return AlertDialog(
              title: Text(playerWon ? 'You Won!' : 'You lost...'),
              actions: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    playerWon
                        ? const Icon(Icons.sentiment_very_satisfied_outlined)
                        : const Icon(Icons.sentiment_very_dissatisfied_rounded),
                  ],
                ),
                TextButton(
                  onPressed: () async {
                    Navigator.of(context).pop();
                    await supabase.removeChannel(_gameChannel!);
                    _openLobbyDialog();
                  },
                  child: const Text(
                    'Back to Lobby',
                    style: TextStyle(color: Colors.green),
                  ),
                ),
                TextButton(
                  //icon: Icon(Icons.share, color: Colors.green),
                  child: const Text(
                    'Share',
                    style: TextStyle(color: Colors.green),
                  ),
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      builder: (context) {
                        return Container(
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // Add sharing options here
                              ListTile(
                                leading: const Icon(FontAwesomeIcons.whatsapp,
                                    color: Colors.green),
                                title: const Text("Share with WhatsApp"),
                                onTap: () async {
                                  final shareText = playerWon
                                      ? 'I won the Shooting Game!'
                                      : 'I lost the Shooting Game!';
                                  await SocialShare.shareWhatsapp(shareText);
                                  Navigator.of(context).pop();
                                },
                              ),
                              ListTile(
                                leading: Icon(FontAwesomeIcons.telegram,
                                    color: Colors.blue[400]),
                                title: const Text("Share with Telegram"),
                                onTap: () async {
                                  final shareText = playerWon
                                      ? 'I won the Shooting Game!'
                                      : 'I lost the Shooting Game!';
                                  await SocialShare.shareTelegram(shareText);
                                  Navigator.of(context).pop();
                                },
                              ),
                              ListTile(
                                leading: const Icon(FontAwesomeIcons.twitter,
                                    color: Colors.lightBlueAccent),
                                title: const Text("Share with Twitter"),
                                onTap: () async {
                                  final shareText = playerWon
                                      ? 'I won the Shooting Game!'
                                      : 'I lost the Shooting Game!';
                                  await SocialShare.shareTwitter(shareText);
                                  Navigator.of(context).pop();
                                },
                              ),
                              ListTile(
                                leading: const Icon(FontAwesomeIcons.sms,
                                    color: Colors.orange),
                                title: const Text("Share with SMS"),
                                onTap: () async {
                                  final shareText = playerWon
                                      ? 'I won the UFO Shooting Game!'
                                      : 'I lost the UFO Shooting Game!';
                                  await SocialShare.shareSms(shareText);
                                  Navigator.of(context).pop();
                                },
                              ),
                              ListTile(
                                leading: Icon(FontAwesomeIcons.textHeight,
                                    color: Colors.teal[700]),
                                title: const Text("Copy as text"),
                                onTap: () async {
                                  final copyText = playerWon
                                      ? 'I won the UFO Shooting Game!'
                                      : 'I lost the UFO Shooting Game!';
                                  await Clipboard.setData(ClipboardData(
                                      text:
                                      copyText)); // Use Clipboard.setData to copy the text
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                ),
              ],
            );
          }),
        );
      },
    );

    // await for a frame so that the widget mounts
    await Future.delayed(Duration.zero);

    if (mounted) {
      _openLobbyDialog();
    }
  }

// Method to play the sound repeatedly until stopped
  void _playSoundRepeatedly(String path) {
    Timer.periodic(Duration(milliseconds: 500), (_) {
      if (_playSound) {
        sound(path);
      }
    });
  }
  void _openLobbyDialog() {
    // Stop the sound when the game is over
    _playSound = false;
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return _LobbyDialog(
            onGameStarted: (gameId) async {
              // await a frame to allow subscribing to a new channel in a realtime callback
              await Future.delayed(Duration.zero);

              setState(() {});

              _game.startNewGame();
              _playSound = true;

              // Play the sound repeatedly using Timer instead of a while loop
              _playSoundRepeatedly('assets/audio/blaster-2-81267.mp3');


              _gameChannel = supabase.channel(gameId,
                  opts: const RealtimeChannelConfig(ack: true));

              _gameChannel!.on(RealtimeListenTypes.broadcast,
                  ChannelFilter(event: 'game_state'), (payload, [_]) {
                    final position =
                    Vector2(payload['x'] as double, payload['y'] as double);
                    final opponentHealth = payload['health'] as int;
                    _game.updateOpponent(
                      position: position,
                      health: opponentHealth,
                    );

                    if (opponentHealth <= 0) {
                      if (!_game.isGameOver) {
                        _game.isGameOver = true;
                        _game.onGameOver(true);
                      }
                    }
                  }).subscribe();
            },
          );
        });
  }
}

class _LobbyDialog extends StatefulWidget {
  const _LobbyDialog({
    required this.onGameStarted,
  });

  final void Function(String gameId) onGameStarted;

  @override
  State<_LobbyDialog> createState() => _LobbyDialogState();
}

class _LobbyDialogState extends State<_LobbyDialog> {
  List<String> _userids = [];
  bool _loading = false;

  /// Unique identifier for each players to identify eachother in lobby
  final myUserId = const Uuid().v4();

  late final RealtimeChannel _lobbyChannel;

  @override
  void initState() {
    super.initState();

    _lobbyChannel = supabase.channel(
      'lobby',
      opts: const RealtimeChannelConfig(self: true),
    );
    _lobbyChannel.on(RealtimeListenTypes.presence, ChannelFilter(event: 'sync'),
            (payload, [ref]) {
          // Update the lobby count
          final presenceState = _lobbyChannel.presenceState();

          setState(() {
            _userids = presenceState.values
                .map((presences) =>
            (presences.first as Presence).payload['user_id'] as String)
                .toList();
          });
        }).on(RealtimeListenTypes.broadcast, ChannelFilter(event: 'game_start'),
            (payload, [_]) {
          // Start the game if someone has started a game with you
          final participantIds = List<String>.from(payload['participants']);
          if (participantIds.contains(myUserId)) {
            final gameId = payload['game_id'] as String;
            widget.onGameStarted(gameId);
            Navigator.of(context).pop();
          }
        }).subscribe(
          (status, [ref]) async {
        if (status == 'SUBSCRIBED') {
          await _lobbyChannel.track({'user_id': myUserId});
        }
      },
    );
  }

  @override
  void dispose() {
    final player = AudioPlayer();
    player.dispose();
    supabase.removeChannel(_lobbyChannel);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Lobby'),
      content: _loading
          ? const SizedBox(
        height: 100,
        child: Center(child: CircularProgressIndicator()),
      )
          : Text('${_userids.length} users waiting'),
      actions: [
        boxPersons.length > 5
            ? const Icon(Icons.switch_access_shortcut)
            : const Icon(Icons.sports_score),
        Text('the score : ${boxPersons.length} '),
        TextButton(
          onPressed: _userids.length < 2
              ? null
              : () async {
            setState(() {
              _loading = true;
            });

            final opponentId =
            _userids.firstWhere((userId) => userId != myUserId);
            final gameId = const Uuid().v4();
            await _lobbyChannel.send(
              type: RealtimeListenTypes.broadcast,
              event: 'game_start',
              payload: {
                'participants': [
                  opponentId,
                  myUserId,
                ],
                'game_id': gameId,
              },
            );
          },
          child: const Text(
            'start',
            style: TextStyle(
              color: Colors.green,
            ),
          ),
        ),
      ],
    );
  }
}
