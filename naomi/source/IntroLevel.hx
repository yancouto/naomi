package;

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
		var back = new FlxSprite(0, 0).loadGraphic("assets/images/skyfinal.png", false);
		back.scrollFactor.x = .7;
		back.scrollFactor.y = 0;
		FlxTween.linearMotion(back, 0, 0, 0, -780, 30, true, {type: FlxTween.PERSIST});
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
		player.decay.running = false;


		FlxG.sound.playMusic("assets/music/castles in the underground.mp3", .5);
	}

	override public function update() : Void {
		super.update();
		if(endPortal.overlaps(enemies)) {
			player.controlled = null;
			FlxG.camera.fade(0xff000000, 4.8, false, false);
			Timer.callIn(5, function() { FlxG.switchState(new LevelDemo()); });
		}
	}
}

class Flower extends base.Enemy {
	public function new(obj : base.Object) {
		super(obj.x, obj.y);
		loadGraphic("assets/images/floweranimation.png", true, false, 35, 60);
		animation.add("still", [0]);
		animation.add("dying", [1, 2], 2, false);
		animation.play("still");
		acceleration.y = 0;
		jumps = 0;
	}

	override public function update() : Void {
		super.update();
		if(Reg.player.controlled != this && animation.name != 'dying') 
			animation.play("dying");
		if(animation.name == 'still')
			Reg.player.decay.running = false;
	}
	override public function walkLeft() {}
	override public function walkRight() {}
	override public function jump() {}
}