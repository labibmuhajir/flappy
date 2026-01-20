import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flappy/game/assets.dart';
import 'package:flappy/game/bird_movement.dart';
import 'package:flappy/game/config.dart';
import 'package:flappy/game/flappy_game.dart';
import 'package:flappy/screen/game_over.dart';
import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';

class Bird extends SpriteGroupComponent<BirdMovement>
    with HasGameReference<FlappyGame>, CollisionCallbacks {
  @override
  FutureOr<void> onLoad() async {
    final birdIdle = await game.loadSprite(Assets.birdMidFlap);
    final birdUp = await game.loadSprite(Assets.birdUpFlap);
    final birdDown = await game.loadSprite(Assets.birdDownFlap);

    sprites = {
      BirdMovement.idle: birdIdle,
      BirdMovement.up: birdUp,
      BirdMovement.down: birdDown,
    };

    size = Vector2(50, 40);
    position = Vector2(50, game.size.y / 2 - size.y / 2);
    current = BirdMovement.idle;

    add(CircleHitbox());
  }

  @override
  void update(double dt) {
    super.update(dt);
    position.y += Config.birdVelocity * dt;
  }

  void fly() {
    add(
      MoveByEffect(
        Vector2(0, Config.gravity),
        EffectController(duration: 0.2, curve: Curves.decelerate),
        onComplete: () => current = BirdMovement.down,
      ),
    );
    FlameAudio.play(Assets.flying);
    current = BirdMovement.up;
  }

  void gameOver() {
    FlameAudio.play(Assets.collision);
    game.overlays.add(GameOver.id);
    game.interval.pause();
    game.pauseEngine();
  }

  void restart() {
    position = Vector2(50, game.size.y / 2 - size.y / 2);
  }

  @override
  void onCollisionStart(
    Set<Vector2> intersectionPoints,
    PositionComponent other,
  ) {
    super.onCollisionStart(intersectionPoints, other);
    gameOver();
  }
}
