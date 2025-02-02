import 'dart:async';
import 'dart:io';

import 'package:flame/components.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:rift_dash/components/player.dart';

import 'collision_block.dart';

class Level extends World {
  late TiledComponent level;

  final String levelName;
  final Player player;
  List<CollisionBlock> collisionBlocks = [];
  Level({required this.levelName, required this.player});

  @override
  FutureOr<void> onLoad() async {
    level = await TiledComponent.load('$levelName.tmx', Vector2.all(16));

    add(level);

    final spawnPointsLayer = level.tileMap.getLayer<ObjectGroup>('Spawnpoints');

    if (spawnPointsLayer != null) {
      for (final spawnPoint in spawnPointsLayer.objects) {
        switch (spawnPoint.class_) {
          case 'Player':
            player.position = Vector2(spawnPoint.x, spawnPoint.y);
            add(player);
            break;
          default:
          // final player = Player(
          //   character: 'Ninja Frog',
          //   position: Vector2(spawnPoint.x, spawnPoint.y),
          // );
        }
      }
    }

    final collisionsLayer = level.tileMap.getLayer<ObjectGroup>('Collisions');

    if(collisionsLayer != null) {
      for ( final collision in collisionsLayer.objects) {
        switch (collision .class_) {
          case 'Platform':
          final platform = CollisionBlock(
            position: Vector2(collision.x, collision.y),
            size: Vector2(collision.width, collision.height),
            isPlatform: true
          );

          collisionBlocks.add(platform);
          add(platform);
          break;
          default:
          final block = CollisionBlock(
            position: Vector2(collision.x, collision.y),
            size: Vector2(collision.width, collision.height),
          );
          collisionBlocks.add(block);
          add(block);
        }
      }
    }
    player.collisionBlocks = collisionBlocks;
    // add(Player(character: 'Ninja Frog'));
    return super.onLoad();
  }
}
