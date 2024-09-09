import 'dart:async';
import 'dart:math';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flappy/components/background.dart';
import 'package:flappy/components/bird.dart';
import 'package:flappy/components/ground.dart';
import 'package:flappy/components/cactus_group.dart';
import 'package:flappy/components/cloud.dart';
import 'package:flappy/game/assets.dart';
import 'package:flappy/screen/game_over.dart';
import 'package:flappy/screen/main_menu.dart';
import 'package:flutter/painting.dart';

class FlappyGame extends FlameGame with TapDetector, HasCollisionDetection {
  late Bird bird;
  late Timer interval = Timer(5, repeat: true, autoStart: false);
  late TextComponent score;
  final List<CactusGroup> _pipes = [];
  int level = 1;

  int playerScore = 0;
  Random abc = Random();

  @override
  FutureOr<void> onLoad() async {
    await addAll([
      Background(),
      Cloud(),
      Ground(),
      bird = Bird(),
      score = createScore()
    ]);
  }

  TextComponent createScore() {
    return TextComponent(
        position: Vector2(size.x / 2, size.y / 2 * 0.2),
        text: "Score: $playerScore",
        textRenderer: TextPaint(
          style: const TextStyle(
            fontSize: 40,
            fontWeight: FontWeight.bold,
            fontFamily: 'Game',
          ),
        ));
  }

  void startGame() {
    overlays.remove(MainMenu.id);
    resumeEngine();
    final time = 3 + abc.nextDouble() * 5 - level;
    final newInterval = Timer(time, repeat: true, autoStart: false);

    intervalCallback() async {
      final newPipe = CactusGroup();
      _pipes.add(newPipe);
      await add(newPipe);
      interval.stop();
      interval = newInterval;
      interval.start();
    }

    newInterval.onTick = intervalCallback;
    interval.onTick = intervalCallback;
    interval.start();
  }

  void resume() {
    playerScore = 0;
    bird.restart();
    for (final pipe in _pipes) {
      pipe.removeFromParent();
    }
    interval.reset();
    interval.start();
    overlays.remove(GameOver.id);
    resumeEngine();
  }

  void restart() {
    level = 1;
    resume();
  }

  void removePipe(CactusGroup pipe) {
    _pipes.remove(pipe);
  }

  void addScore(int score) {
    FlameAudio.play(Assets.point);
    playerScore += score;
  }

  @override
  void onTap() {
    super.onTap();
    bird.fly();
  }

  @override
  void update(double dt) {
    super.update(dt);
    interval.update(dt);
    score.text = "Score: $playerScore";

    if (playerScore > 10 && playerScore % 10 == 0) {
      final newLevel = playerScore / 10;
      level = newLevel.toInt();
    }
  }
}
