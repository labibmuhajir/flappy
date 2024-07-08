import 'dart:async';
import 'dart:math';

import 'package:flame/components.dart';
import 'package:flappy/components/pipe.dart';
import 'package:flappy/game/config.dart';
import 'package:flappy/game/flappy_game.dart';
import 'package:flappy/game/pipe_position.dart';

class PipeGroup extends PositionComponent with HasGameRef<FlappyGame> {
  final _random = Random();

  @override
  FutureOr<void> onLoad() {
    position.x = gameRef.size.x;

    final heightMinusGround = gameRef.size.y - Config.groundHeight;
    final spacing = _random.nextInt((heightMinusGround / 2).round()) +
        (130 - (game.level * 10));
    final centerY = _random.nextInt(heightMinusGround.round()) + 100;

    final topHeight = heightMinusGround - centerY - spacing;
    final bottomHeight = heightMinusGround - topHeight - (spacing * 2);
    final newPipes = [
      Pipe(pipePosition: PipePosition.top, height: topHeight),
      Pipe(pipePosition: PipePosition.bottom, height: bottomHeight),
    ];

    addAll(newPipes);
  }

  @override
  void update(double dt) {
    super.update(dt);
    position.x -= Config.gameSpeed * dt + (game.level / 10);

    if (position.x < -10) {
      removeFromParent();
      game.removePipe(this);
      game.addScore(1);
    }
  }
}
