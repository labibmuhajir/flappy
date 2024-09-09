import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flappy/game/assets.dart';
import 'package:flappy/game/config.dart';
import 'package:flappy/game/flappy_game.dart';
import 'package:flappy/game/cactus_position.dart';

class Cactus extends SpriteComponent with HasGameRef<FlappyGame> {
  Cactus({required this.height, required this.pipePosition});

  @override
  double height;
  final CactusPosition pipePosition;

  @override
  FutureOr<void> onLoad() async {
    final pipe = await Flame.images.load(Assets.pipe);
    final pipeRotated = await Flame.images.load(Assets.pipeRotated);
    size = Vector2(50, height);

    switch (pipePosition) {
      case CactusPosition.top:
        position.y = 0;
        sprite = Sprite(pipeRotated);
        break;
      case CactusPosition.bottom:
        sprite = Sprite(pipe);
        position.y = gameRef.size.y - size.y - Config.groundHeight;
        break;
    }
    add(RectangleHitbox());
  }
}
