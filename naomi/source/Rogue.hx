package;

import flixel.FlxObject;
import base.Enemy;
import flixel.FlxG;
import flixel.util.FlxPoint;
import flixel.group.FlxTypedGroup;

class Rogue extends Enemy {
	public static var wallGrip : TileMap.PObjectGroup;

	public function new(x : Float, y : Float) {
		super(x, y);
		
		loadGraphic("assets/images/rogueeanimation.png", true, true, 42, 84);
		animation.add("idle", [0]);
		animation.add("walking", [0, 1, 2, 1], 10);
		animation.play("idle");
		facing = FlxObject.RIGHT;

		health = 100;

		jumps = 1;
		jumpSpeed = 370;

		base_speed = 250;
		drag.x = 700;
	
		mass = 10;
		maxVelocity.x = base_speed;
	}

	private static var collided : Bool;
	private static function filter(_, __) : Bool
		return !collided;

	private static function doWallGrip(r : Rogue, w : FlxObject) : Void {
		collided = true;
		r.maxVelocity.y = 40;
		if(r == Reg.player.controlled && FlxG.keyboard.anyJustPressed(['W','UP'])) {
			var left : Bool = w.overlapsPoint(new FlxPoint(r.x, r.y));
			r.maxVelocity.y = 1000000;
			r.velocity.y = -1.5 * r.base_speed;
			if(left) {
				r.x += 2;
				r.velocity.x = r.base_speed;
			} else {
				r.x -= 2;
				r.velocity.x = -r.base_speed;
			}
		}
	}

	override public function update() : Void {
		super.update();
		collided = false;
		if(velocity.y > 0)
			FlxG.overlap(this, wallGrip, doWallGrip, filter);
		else
			maxVelocity.y = 1000000;
	}
}