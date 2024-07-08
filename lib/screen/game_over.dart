import 'package:flappy/game/assets.dart';
import 'package:flutter/material.dart';

class GameOver extends StatelessWidget {
  const GameOver(
      {super.key,
      required this.onRestart,
      required this.onResume,
      required this.score});

  static const id = 'game_over';

  final VoidCallback onRestart;
  final VoidCallback onResume;
  final int score;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Material(
        color: Colors.black.withOpacity(0.4),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Score: $score',
                style: const TextStyle(
                  color: Colors.white,
                  fontFamily: 'Game',
                  fontWeight: FontWeight.bold,
                  fontSize: 60,
                ),
              ),
              const SizedBox(
                height: 24,
              ),
              Image.asset(Assets.gameOver),
              const SizedBox(
                height: 16,
              ),
              ElevatedButton(
                onPressed: onRestart,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                ),
                child: const Text(
                  'Restart',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              ElevatedButton(
                onPressed: onResume,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                ),
                child: const Text(
                  'Resume',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
