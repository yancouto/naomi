package levels;

import flixel.FlxObject;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxCamera;
import flixel.tweens.FlxTween;

import base.PlayState;
import base.Timer;

class IntroLevel extends PlayState {
	private var endPortal : FlxObject;
	private var plant : Flower;

	override public function create() : Void {
		var back = new FlxSprite(-120, -480).loadGraphic("assets/images/skyfinal.png", false);
		back.scrollFactor.x = .9;
		back.scrollFactor.y = 1;
		add(back);

		super.loadMap("intro");

		// Set a background color
		FlxG.cameras.bgColor = 0xff0b2b57;

		// Show the mouse (in case it hasn't been disabled)
		#if !FLX_NO_MOUSE
		FlxG.mouse.show();
		#end

		endPortal = map.objectMap.get("endPortal").members[0];

		plant = new Flower(map.objectMap.get("plant").members[0]);
		add(plant);

		var followed = new FlxObject(plant.x + plant.width/2, FlxG.camera.y + FlxG.height/2 - 480 - 600, 0, 0);
		FlxG.camera.follow(followed, FlxCamera.STYLE_NO_DEAD_ZONE);
		FlxTween.linearMotion(followed, followed.x, followed.y, followed.x, plant.y + plant.height/2, 200, false, {type: FlxTween.ONESHOT, 
			complete: function(self) { player.possess(plant); } });

		Reg.playBackgroundMusic("Castles in the Underground.mp3", 3);
	}

	override public function update() : Void {
		super.update();
		var rat = enemies.members[0];
		if(Reg.player.controlled != null && endPortal.overlaps(rat)) {
			player.possess(null);
			FlxG.camera.fade(0xff000000, 1.8, false, false);
			FlxG.camera.follow(null);

			/*
			* Rat moves right
			*/
			rat.drag.set(0, 0);
			rat.acceleration.set(0, 0);
			rat.velocity.set(100, 0);
			
			/*
			* Rat doesn't collide anymore
			*/
			enemies.clear();
			add(rat);
			
			Timer.callIn(2, function() { FlxG.switchState(new SimpleLevel()); });
		}
	}
}

class Flower extends base.Enemy {
	public function new(obj : base.Object) {
		super(obj.x, obj.y + obj.height - 60);
		loadGraphic("assets/images/flower_animation.png", true, false, 32, 60);
		animation.add("still", [0]);
		animation.add("dying", [1, 2], 1, false);
		animation.play("still");
		acceleration.y = 0;
		jumps = 0;

		healthColor = 0;
	}

	override public function update() : Void {
		super.update();
		if(Reg.player.controlled != null && Reg.player.controlled != this && animation.name != 'dying') 
			animation.play("dying");
	}
	override public function walkLeft() {}
	override public function walkRight() {}
	override public function jump() {}
}