package;

import flixel.FlxObject;
import base.Enemy;
import flixel.FlxSprite;
import flixel.FlxG;
import flixel.util.FlxPoint;
import flixel.group.FlxTypedGroup;

class Rogue extends Enemy {
	public static var wallGrip : TileMap.PObjectGroup;

	public function new(x : Float, y : Float) {
		super(x, y);

		loadGraphic("assets/images/rogueeanimation.png", true, true, 42, 84);
		animation.add("idle", [0]);
		animation.add("walking",[0, 1, 2, 1], 10);
		animation.add("air", [3]);
		animation.play("idle");
		facing = FlxObject.RIGHT;

		health = 100;

		jumps = 1;
		jumpSpeed = 370;

		base_speed = 250;
		drag.x = 700;
	
		mass = 40;
		maxVelocity.x = base_speed;
	}

	private static var collided : Bool;
	private static function filter(_, __) : Bool
		return !collided;

	private static function doWallGrip(r : Rogue, w : FlxObject) : Void {
		collided = true;
		if(r.velocity.y == 8) return;
		if(r.velocity.y > 0)
			r.maxVelocity.y = 40;
		if(r == Reg.player.controlled && FlxG.keyboard.anyJustPressed(['W','UP'])) {
			var left : Bool = w.overlapsPoint(new FlxPoint(r.x, r.y)) || w.overlapsPoint(new FlxPoint(r.x, r.y + r.height));
			r.maxVelocity.y = 1000000;
			r.velocity.y = -1.5 * r.base_speed;
			if(left) {
				r.x += 2;
				r.velocity.x = 2*r.base_speed;
			} else {
				r.x -= 2;
				r.velocity.x = -2*r.base_speed;
			}
		}
	}

	override public function update() : Void {
		super.update();
		collided = false;
		maxVelocity.y = 1000000;
		FlxG.overlap(this, wallGrip, doWallGrip, filter);
		if(!onFloor || collided)
			animation.play("air");
	}

	override private function deadParts() : Void {
		var n = 6;
		var size = 55;
		var height = 40;
		var img = new FlxSprite().loadGraphic("assets/images/ROGUEPARTS.png", false);
		for(i in 0...n) {
			var temp = new FlxSprite().makeGraphic(size, height, 0x00000000);
			temp.stamp(img, -i*size, 0);
			temp.velocity.set(Math.random() * 600 - 300, -Math.random() * 600);
			temp.setPosition(x + Math.random()*width, y + Math.random()*height);
			temp.acceleration.y = 420;
			temp.angularVelocity = Math.random()*100;
			Reg.playState.add(temp);
		}
	}
}