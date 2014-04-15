package levels;

import flixel.FlxObject;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxCamera;
import flixel.tweens.FlxTween;

import base.PlayState;
import base.Timer;

class FirstLevel extends PlayState {

	override public function create() : Void {
		super.loadMap("1");

		// Set a background color
		FlxG.cameras.bgColor = 0xff0b2b57;

		// Show the mouse (in case it hasn't been disabled)
		#if !FLX_NO_MOUSE
		FlxG.mouse.visible = true;
		#end

		var obj = map.objectMap.get("tunnel").members[0];
		var rat = new FlxSprite(obj.x, obj.y + obj.height - 32).loadGraphic("assets/images/rat_animation.png", true, true, 64, 32);
		rat.animation.add("walking", [0, 1], 4);
		rat.animation.play("walking");

		player.possess(null);
		FlxG.camera.follow(null);
		FlxG.camera.focusOn(rat.getGraphicMidpoint());

		/*
		* Rat moves right
		*/
		rat.drag.set(0, 0);
		rat.acceleration.set(0, 0);
		rat.velocity.set(100, 0);
		add(rat);
		
		Timer.callIn(2, function() {
			var newRat = new Rat(new base.Object(rat.x, rat.y, rat.width, rat.height, new Map<String, String>()));
			enemies.add(newRat);
			player.possess(newRat);
			rat.destroy();
			FlxG.camera.follow(Reg.player, FlxCamera.STYLE_PLATFORMER, 5);
		});

		Reg.playBackgroundMusic("Castles in the Underground.mp3", 3);
	}
}