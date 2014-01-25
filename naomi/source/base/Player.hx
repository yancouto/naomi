package base;

import flixel.FlxBasic;
import flixel.FlxSprite;
import flixel.FlxG;
import flixel.FlxCamera;
using base.Utils;

class Player extends FlxBasic {
	public var controlled(default, null) : Enemy;
	private var soulShot : SoulShot;

	public function new() {
		super();
		controlled = null;
		soulShot = null;
	}

	public function possess(enemy : Enemy) : Void {
		controlled = enemy;
		FlxG.camera.follow(controlled, FlxCamera.STYLE_PLATFORMER, 5);
		// more stuff here
	}

	override public function update() : Void {
		super.update();
		if(soulShot != null)  {
			soulShot.update();
			if(!soulShot.exists) {
				soulShot = null;
				FlxG.camera.follow(controlled, FlxCamera.STYLE_PLATFORMER, 5);
			}
			return;
		}
		if(controlled == null) return;
		if(FlxG.keyboard.anyPressed(['A', 'LEFT']))
			controlled.walkLeft();
		else if(FlxG.keyboard.anyPressed(['D', 'RIGHT']))
			controlled.walkRight();
		if(FlxG.keyboard.anyJustPressed(['W', 'UP']))
			controlled.jump();

		if(FlxG.mouse.justPressed) {
			soulShot = new SoulShot(controlled.x, controlled.y);
			FlxG.camera.follow(soulShot, FlxCamera.STYLE_LOCKON, 5);
		}
	}

	override public function draw() : Void {
		super.draw();
		if(soulShot != null)
			soulShot.draw();
	}
}

private class SoulShot extends FlxSprite {
	private static inline var base_speed : Float = 600;

	public function new(x : Float, y : Float) {
		super(x, y);
		makeGraphic(16, 16, 0xff00aa55);
		velocity.set(FlxG.mouse.screenX - x, FlxG.mouse.screenY - y).normalize().mult(base_speed);
	}

	override public function update() : Void {
		super.update();
		if(overlaps(Reg.playState.map.collidableTiles))
			destroy();
		FlxG.overlap(this, Reg.playState.enemies, function(a, b) { possiblePossession(b); });
	}

	private function possiblePossession(enemy : Enemy) {
		if(enemy != Reg.playState.player.controlled) {
			Reg.playState.player.possess(enemy);
			destroy();
		}
	}
}