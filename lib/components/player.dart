
// ignore_for_file: constant_pattern_never_matches_value_type

import 'dart:async';

import 'package:flame/components.dart';
import 'package:flutter/src/services/hardware_keyboard.dart';
import 'package:flutter/src/services/keyboard_key.g.dart';
import 'package:rift_dash/rift_dash.dart';

import 'collision_block.dart';

enum PlayerState { idle, running}



class Player extends SpriteAnimationGroupComponent with HasGameRef<RiftDash>, KeyboardHandler {
  String character;
  Player({position, this.character = 'Ninja Frog'}) : super(position: position);

  late final SpriteAnimation idleAnimation;
  late final SpriteAnimation runningAnimation;
  final double stepTime = 0.05;


  double horizontalMovement = 0.0;
  double moveSpeed = 100;
  Vector2 velocity = Vector2.zero();
  List<CollisionBlock> collisionBlocks = [];

  @override
  FutureOr<void> onLoad() {
    _loadAllAnimations();
    debugMode = true; // to make player collision visible
    return super.onLoad();
  }

  @override
  void update(double dt) {
    _updatePlayerState();
    _updatePlayerMovement(dt);
    super.update(dt);
  }

  @override
  bool onKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    horizontalMovement = 0;

    final isLeftKeyPressed = keysPressed.contains(LogicalKeyboardKey.keyA) || keysPressed.contains(LogicalKeyboardKey.arrowLeft,);
    final isRightKeyPressed = keysPressed.contains(LogicalKeyboardKey.keyD) || keysPressed.contains(LogicalKeyboardKey.arrowRight,);

    horizontalMovement += isLeftKeyPressed ? -1 : 0;
    horizontalMovement += isRightKeyPressed ? 1 : 0;

    return super.onKeyEvent(event, keysPressed);
  }

  void _loadAllAnimations() {
    idleAnimation = _spriteAnimation('Run', 12);
    runningAnimation = _spriteAnimation('Run', 12);

    // list of all animations
    animations = {
      PlayerState.idle: idleAnimation,
      PlayerState.running: runningAnimation  // Add running animation to the map
    };

    current = PlayerState.idle;
  }

  SpriteAnimation _spriteAnimation(String state, int amount) {
    return SpriteAnimation.fromFrameData(
      game.images.fromCache('Main Characters/$character/$state (32x32).png'),
      SpriteAnimationData.sequenced(
        amount: amount,
        stepTime: stepTime,
        textureSize: Vector2.all(32),
      ),
    );
  }

  void _updatePlayerState() {
    PlayerState playerState = PlayerState.idle;

    if(velocity.x < 0 && scale.x > 0) {
      flipHorizontallyAroundCenter();
    }else if (velocity.x > 0 && scale.x < 0){
      flipHorizontallyAroundCenter();
    }

    // check if moving is set to running
    if (velocity.x > 0 || velocity.x < 0) playerState = PlayerState.running;

    current = playerState;
  }

  
  void _updatePlayerMovement(double dt) {

    velocity.x = horizontalMovement * moveSpeed;
    position.x += velocity.x * dt;
  }
  
  
}


// // ignore_for_file: constant_pattern_never_matches_value_type

// import 'dart:async';

// import 'package:flame/components.dart';
// import 'package:flutter/src/services/hardware_keyboard.dart';
// import 'package:flutter/src/services/keyboard_key.g.dart';
// import 'package:rift_dash/rift_dash.dart';

// enum PlayerState { idle, running}
// enum PlayerDirection { left, right, none }


// class Player extends SpriteAnimationGroupComponent with HasGameRef<RiftDash>, KeyboardHandler {
//   String character;
//   Player({position, this.character = 'Ninja Frog'}) : super(position: position);

//   late final SpriteAnimation idleAnimation;
//   late final SpriteAnimation runningAnimation;
//   final double stepTime = 0.05;
//   bool isFacingRight = true;

//   PlayerDirection playerDirection = PlayerDirection.none;
//   double moveSpeed = 100;
//   Vector2 velocity = Vector2.zero();

//   @override
//   FutureOr<void> onLoad() {
//     _loadAllAnimations();
//     return super.onLoad();
//   }

//   @override
//   void update(double dt) {
//     _updatePlayerMovement(dt);
//     super.update(dt);
//   }

//   @override
//   bool onKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
//     final isLeftKeyPressed = keysPressed.contains(LogicalKeyboardKey.keyA) || keysPressed.contains(LogicalKeyboardKey.arrowLeft,);
//     final isRightKeyPressed = keysPressed.contains(LogicalKeyboardKey.keyD) || keysPressed.contains(LogicalKeyboardKey.arrowRight,);

//     if(isLeftKeyPressed && isRightKeyPressed) {
//       playerDirection = PlayerDirection.none;
//     }else if(isLeftKeyPressed) {
//       playerDirection = PlayerDirection.left;
//     }else if (isRightKeyPressed) {
//       playerDirection = PlayerDirection.right;
//     }else{
//       playerDirection = PlayerDirection.none;
//     }
//     return super.onKeyEvent(event, keysPressed);
//   }

//   void _loadAllAnimations() {
//     idleAnimation = _spriteAnimation('Run', 12);
//     runningAnimation = _spriteAnimation('Run', 12);

//     // list of all animations
//     animations = {
//       PlayerState.idle: idleAnimation,
//       PlayerState.running: runningAnimation  // Add running animation to the map
//     };

//     current = PlayerState.idle;
//   }

//   SpriteAnimation _spriteAnimation(String state, int amount) {
//     return SpriteAnimation.fromFrameData(
//       game.images.fromCache('Main Characters/$character/$state (32x32).png'),
//       SpriteAnimationData.sequenced(
//         amount: amount,
//         stepTime: stepTime,
//         textureSize: Vector2.all(32),
//       ),
//     );
//   }
  
//   void _updatePlayerMovement(double dt) {
//     double dirX = 0.0;
//     switch (playerDirection) {  // Changed from PlayerDirection to playerDirection
//       case PlayerDirection.left:
//         if(isFacingRight) {
//           flipHorizontallyAroundCenter();
//           isFacingRight = false;
//         }
//         current = PlayerState.running;
//         dirX -= moveSpeed;
//         break;
//       case PlayerDirection.right:
//         if(!isFacingRight) {
//           flipHorizontallyAroundCenter();
//           isFacingRight = true;
//         }
//         current = PlayerState.running;
//         dirX += moveSpeed;
//         break;
//       case PlayerDirection.none:
//         current = PlayerState.idle;
//         break;
//     }

//     velocity = Vector2(dirX, 0.0);
//     position += velocity * dt;
//   }
// }