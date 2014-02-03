package levels;

import base.PlayState;
import flixel.FlxObject;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.tweens.FlxTween;
import base.Timer;

class IntroLevel extends PlayState {
	private var endPortal : FlxObject;
	private var plant : Flower;
	/**
	 * Function that is called up when to state is created to set it up. 
	 */
	override public function create() : Void {
		var back = new FlxSprite().loadGraphic("assets/images/skyfinal.png", false);
		back.scrollFactor.x = .9;
		back.scrollFactor.y = 1;
		FlxTween.linearMotion(back, -120, 0, -120, -480, 30, true, {type: FlxTween.PERSIST});
		add(back);
		super.loadMap("intro");
		// Set a background color
		FlxG.cameras.bgColor = 0xff0088ff;
		FlxG.camera.fade(0xff000000, 1, true);

		// Show the mouse (in case it hasn't been disabled)
		#if !FLX_NO_MOUSE
		FlxG.mouse.show();
		#end

		endPortal = map.objectMap.get("endPortal").members[0];

		plant = new Flower(map.objectMap.get("plant").members[0]);
		add(plant);
		player.possess(plant);


		Reg.playBackgroundMusic("Castles in the Underground.mp3", 3);
	}

	override public function update() : Void {
		super.update();
		if(Reg.player.controlled != null && endPortal.overlaps(enemies)) {
			player.possess(null);
			FlxG.camera.fade(0xff000000, 2.8, false, false);
			Timer.callIn(3, function() { FlxG.switchState(new SimpleLevel()); });
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
		if(Reg.player.controlled != this && animation.name != 'dying') 
			animation.play("dying");
	}
	override public function walkLeft() {}
	override public function walkRight() {}
	override public function jump() {}
}