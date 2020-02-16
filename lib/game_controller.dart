import 'dart:math';
import 'dart:ui';
import 'package:flame/flame.dart';
import 'package:flame/game/game.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'components/enemy.dart';
import 'components/health_bar.dart';
import 'components/highscore_text.dart';
import 'components/instructions.dart';
import 'components/player.dart';
import 'components/playerscore.dart';
import 'components/score_text.dart';
import 'components/start_button.dart';
import 'enemy_spawner.dart';
import 'state.dart';

class GameController extends Game {
  final SharedPreferences storage;
  Random rand;
  Size screenSize;
  double tileSize;
  Player player;
  List<Enemy> enemies;
  EnemySpawner enemySpawner;
  HealthBar healthBar;
  int score;
  ScoreText scoreText;
  GameState state;
  HighScoreText highScoreText;
  StartButton startButton;
  Instructions instructions;
  PlayerScoreText playerScoreText;

  GameController(this.storage) {
    initialize();
  }

  void initialize() async {
    resize(await Flame.util.initialDimensions());
    state = GameState.menu;
    rand = Random();
    player = Player(this);
    enemies = List<Enemy>();
    enemySpawner = EnemySpawner(this);
    healthBar = HealthBar(this);
    score = 0;
    scoreText = ScoreText(this);
    highScoreText = HighScoreText(this);
    startButton = StartButton(this);
    instructions = Instructions(this);
    playerScoreText = PlayerScoreText(this);
  }

  void render(Canvas c) {
    Rect background = Rect.fromLTWH(0, 0, screenSize.width, screenSize.height);
    Paint backgroundPaint = Paint()..color = Color(0xFFFAFAFA);
    c.drawRect(background, backgroundPaint);

    player.render(c);

    if (state == GameState.menu) {
      startButton.render(c);
      instructions.render(c);
      highScoreText.render(c);
      playerScoreText.render(c);
    } else if (state == GameState.playing) {
      enemies.forEach((Enemy enemy) => enemy.render(c));
      scoreText.render(c);
      healthBar.render(c);
    }
  }

  void update(double t) {
    if (state == GameState.menu) {
      startButton.update(t);
      instructions.update(t);
      highScoreText.update(t);
      playerScoreText.update(t);
    } else if (state == GameState.playing) {
      enemies.forEach((Enemy enemy) => enemy.update(t));
      enemySpawner.update(t);
      enemies.removeWhere((Enemy enemy) => enemy.isDead);
      scoreText.update(t);
      player.update(t);
      healthBar.update(t);
    }
  }

  void resize(Size size) {
    screenSize = size;
    tileSize = screenSize.width / 10;
  }

  void onTapDown(TapDownDetails d) {
    if (state == GameState.menu) {
      state = GameState.playing;
    } else if (state == GameState.playing) {
      enemies.forEach((Enemy enemy) {
        if (enemy.enemyRect.contains(d.globalPosition)) {
          enemy.onTapDown();
        }
      });
    }
  }

  void spawnEnemy() {
    double x, y;
    switch (rand.nextInt(4)) {
      case 0:
        // top
        x = rand.nextDouble() * screenSize.width;
        y = -tileSize * 2.5;
        break;
      case 1:
        // right
        x = screenSize.width + tileSize * 2.5;
        y = rand.nextDouble() * screenSize.height;
        break;
      case 2:
        // bottom
        x = rand.nextDouble() * screenSize.height;
        y = screenSize.width + tileSize * 2.5;
        break;
      case 3:
        // left
        x = -tileSize * 2.5;
        y = rand.nextDouble() * screenSize.height;
        break;
    }
    enemies.add(Enemy(this, x, y));
  }
}
