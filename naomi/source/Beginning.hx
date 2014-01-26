package;

import flixel.FlxSprite;
import flixel.FlxG;
import base.Timer;

class Beginning extends FlxSprite {
	public function new(playerSpawn : base.Object) {
		super(playerSpawn.x, playerSpawn.y);
		loadGraphic("assets/images/enterstairsanimation.png", true, false, 128, 128);
		animation.add("exiting", [0, 1, 2, 0], 3, false);
		animation.play("exiting");

		var enemy : base.Enemy = Type.createInstance(Type.resolveClass(
			playerSpawn.properties.get("type")), [playerSpawn.x, playerSpawn.y]);
		enemy.y  = enemy.y + height - enemy.height;
		enemy.x += width/2 - enemy.width/2;
		Reg.playState.enemies.add(enemy);
		FlxG.camera.follow(enemy);
		Timer.callIn(1, function() { 
			Reg.player.possess(enemy);
		});
	}
}