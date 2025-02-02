import 'dart:async';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:rift_dash/components/player.dart';
import 'package:rift_dash/components/level.dart';

class RiftDash extends FlameGame
    with HasKeyboardHandlerComponents, DragCallbacks {
  @override
  Color backgroundColor() => const Color(0xFF211F30);
  late final CameraComponent cam;
  Player player = Player(character: 'Mask Dude');
  late JoystickComponent joystick;
  bool showJoystick = true;

  @override
  FutureOr<void> onLoad() async {
    // Load all images into cache
    await images.loadAllImages();

    final world = Level(levelName: 'level-02', player: player);

    cam = CameraComponent.withFixedResolution(
        world: world, width: 640, height: 360);
    cam.viewfinder.anchor = Anchor.topLeft;

    addAll([cam, world]);
    if(showJoystick){
    addJoystick();
    }
    return super.onLoad();
  }

  @override
  void update(double dt) {
    if(showJoystick){
    updateJoystick();
    }
    super.update(dt);
  }

  void addJoystick() {
    joystick = JoystickComponent(
      knob: SpriteComponent(
        sprite: Sprite(
          images.fromCache('HUD/Knob.png'),
        ),
      ),
      background: SpriteComponent(
        sprite: Sprite(
          images.fromCache(
            'HUD/Joystick.png',
          ),
        ),
      ),
      margin: const EdgeInsets.only(left: 32, bottom: 32),
    );

    add(joystick);
  }
  
  void updateJoystick() {
    switch (joystick.direction) {
      case JoystickDirection.left:
      player.horizontalMovement = -1;
      break;
      case JoystickDirection.up:
        // TODO: Handle this case.
        throw UnimplementedError();
      case JoystickDirection.upLeft:
      player.horizontalMovement = -1;
      case JoystickDirection.upRight:
      player.horizontalMovement = 1;
      case JoystickDirection.right:
      player.horizontalMovement = 1;
        throw UnimplementedError();
      case JoystickDirection.down:
        // TODO: Handle this case.
        throw UnimplementedError();
      case JoystickDirection.downRight:
      player.horizontalMovement = 1;
      case JoystickDirection.downLeft:
      player.horizontalMovement = -1;
      case JoystickDirection.idle:
      player.horizontalMovement = 0;
      
    }
  }
}
