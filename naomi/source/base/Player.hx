package base;

import flixel.FlxBasic;
import flixel.FlxSprite;
import flixel.FlxG;
import flixel.FlxCamera;

class Player extends FlxBasic {
	public var controlled(default, null) : Enemy;

	override public function new() {
		super();
		controlled = null;
	}

	public function possess(enemy : Enemy) : Void {
		controlled = enemy;
		FlxG.camera.follow(controlled, FlxCamera.STYLE_PLATFORMER);
		// more stuff here
	}

	override public function update() : Void {
		super.update();
		if(controlled == null) return;
		if(FlxG.keyboard.anyPressed(['A', 'LEFT']))
			controlled.walkLeft();
		else if(FlxG.keyboard.anyPressed(['D', 'RIGHT']))
			controlled.walkRight();
		if(FlxG.keyboard.anyJustPressed(['W', 'UP']))
			controlled.jump();
	}
}