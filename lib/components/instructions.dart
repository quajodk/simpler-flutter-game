import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

import '../game_controller.dart';

class Instructions {
  final GameController gameController;
  TextPainter painter;
  Offset position;

  Instructions(this.gameController) {
    painter = TextPainter(
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );
    position = Offset.zero;
  }

  void render(Canvas c) {
    painter.paint(c, position);
  }

  void update(double t) {
    painter.text = TextSpan(
      text:
          'Tap 3 times on an enemy to kill it  \n Do not allow the enemy to you - the blue box \n kill as many as you can to beat the highscore',
      style: TextStyle(
        color: Colors.black,
        fontSize: 14.0,
      ),
    );
    painter.layout();

    position = Offset(
      (gameController.screenSize.width / 2) - (painter.width / 2),
      (gameController.screenSize.height * 0.8) - (painter.height / 2),
    );
  }
}
