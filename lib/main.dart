import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flappy/game/flappy_game.dart';
import 'package:flappy/screen/game_over.dart';
import 'package:flappy/screen/main_menu.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Flame.device.fullScreen();

  final game = FlappyGame();
  game.pauseEngine();

  runApp(
    GameWidget(
      game: game,
      initialActiveOverlays: const [MainMenu.id],
      overlayBuilderMap: {
        MainMenu.id: (context, _) => MainMenu(
              onTap: game.startGame,
            ),
        GameOver.id: (context, _) => GameOver(
              onRestart: game.restart,
              onResume: game.resume,
              score: game.playerScore,
            )
      },
    ),
  );
}
