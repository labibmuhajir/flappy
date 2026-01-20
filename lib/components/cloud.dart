import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flappy/game/assets.dart';
import 'package:flappy/game/flappy_game.dart';

class Cloud extends SpriteComponent with HasGameReference<FlappyGame> {
  Cloud();

  @override
  FutureOr<void> onLoad() async {
    final cloud = await Flame.images.load(Assets.clouds);
    sprite = Sprite(cloud);
    position = Vector2(0, -10);
    size = Vector2(game.size.x, 30);
    add(
      RectangleHitbox(position: Vector2(0, 0), size: Vector2(game.size.x, 1)),
    );
  }
}
