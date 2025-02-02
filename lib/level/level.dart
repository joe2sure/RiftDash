import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:rift_dash/actors/player.dart';


class Level extends World {
  late TiledComponent level;

  final String levelName;
  final Player player;
  Level({required this.levelName, required this.player});

  @override
  FutureOr<void> onLoad() async {
    level = await TiledComponent.load('$levelName.tmx', Vector2.all(16));

    add(level);

    final spawnPointsLayer = level.tileMap.getLayer<ObjectGroup>('Spawnpoints');

    for (final spawnPoint in spawnPointsLayer!.objects) {
      switch (spawnPoint.class_) {
        case 'Player':
          player.position =  Vector2(spawnPoint.x, spawnPoint.y);
          add(player);
          break;
        default:
          // final player = Player(
          //   character: 'Ninja Frog',
          //   position: Vector2(spawnPoint.x, spawnPoint.y),
          // );
          
      }
    }
    // add(Player(character: 'Ninja Frog'));
    return super.onLoad();
  }
}