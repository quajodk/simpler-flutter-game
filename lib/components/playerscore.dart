import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

import '../game_controller.dart';

class PlayerScoreText {
  final GameController gameController;
  TextPainter painter;
  Offset position;

  PlayerScoreText(this.gameController) {
    painter = TextPainter(
        textAlign: TextAlign.center, textDirection: TextDirection.ltr);
    position = Offset.zero;
  }

  void render(Canvas c) {
    painter.paint(c, position);
  }

  void update(double t) {
    int playerScore = gameController.storage.getInt('player_score') ?? 0;

    painter.text = TextSpan(
      text: 'Your Score: $playerScore',
      style: TextStyle(
        color: Colors.black,
        fontSize: 24.0,
      ),
    );
    painter.layout();

    position = Offset(
      (gameController.screenSize.width / 2) - (painter.width / 2),
      (gameController.screenSize.height * 0.3) - (painter.height / 2),
    );
  }
}
