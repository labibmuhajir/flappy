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
    with HasGameRef<FlappyGame>, CollisionCallbacks {
  @override
  FutureOr<void> onLoad() async {
    final birdIdle = await gameRef.loadSprite(Assets.birdMidFlap);
    final birdUp = await gameRef.loadSprite(Assets.birdUpFlap);
    final birdDown = await gameRef.loadSprite(Assets.birdDownFlap);

    size = Vector2(50, 40);
    position = Vector2(50, gameRef.size.y / 2 - size.y / 2);
    current = BirdMovement.idle;
    sprites = {
      BirdMovement.idle: birdIdle,
      BirdMovement.up: birdUp,
      BirdMovement.down: birdDown
    };

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
        EffectController(
          duration: 0.2,
          curve: Curves.decelerate,
        ),
        onComplete: () => current = BirdMovement.down,
      ),
    );
    FlameAudio.play(Assets.flying);
    current = BirdMovement.up;
  }

  void gameOver() {
    FlameAudio.play(Assets.collision);
    gameRef.overlays.add(GameOver.id);
    gameRef.interval.pause();
    gameRef.pauseEngine();
  }

  void restart() {
    position = Vector2(50, gameRef.size.y / 2 - size.y / 2);
  }

  @override
  void onCollisionStart(
      Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollisionStart(intersectionPoints, other);
    gameOver();
  }
}
