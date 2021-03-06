package;

import flixel.FlxObject;
import base.Enemy;
import flixel.FlxSprite;
import flixel.FlxG;
import flixel.util.FlxPoint;
import flixel.group.FlxTypedGroup;

class Rogue extends Enemy {
	public static var wallGrip : TileMap.PObjectGroup;

	public function new(obj : base.Object) {
		super(obj.x, obj.y + obj.height - 84);

		loadGraphic("assets/images/rogueeanimation.png", true, true, 42, 84);
		animation.add("idle", [0]);
		animation.add("walking",[0, 1, 2, 1], 10);
		animation.add("fallin", [3]);
		animation.add("jumping", [4]);
		animation.play("idle");

		if(obj.properties.get("facing") == "left")
			facing = FlxObject.LEFT;
		else
			facing = FlxObject.RIGHT;

		health = 100;

		jumps = 1;
		jumpSpeed = 370;

		base_speed = 200;
		drag.x = 700;
	
		mass = 40;
		maxVelocity.x = base_speed;

		healthColor = 0xff32cd32;
	}

	private static var collided : Bool;
	private static function filter(_, __) : Bool
		return !collided;

	private static var pt = new FlxPoint(0, 0);
	private static function doWallGrip(r : Rogue, w : FlxObject) : Void {
		collided = true;
		if(r.velocity.y == 8) return;
		if(r.velocity.y > 0)
			r.maxVelocity.y = 40;
		if(r == Reg.player.controlled && FlxG.keys.anyJustPressed(['W', 'SPACE']) && r.velocity.y != 8) {
			if((r.y + r.height) - w.y < r.height/4) return;
			var left : Bool = w.overlapsPoint(pt.set(r.x, r.y)) || w.overlapsPoint(pt.set(r.x, r.y + r.height));
			r.maxVelocity.y = 1000000;
			r.velocity.y = -1.5 * r.base_speed;
			if(left) {
				r.x += 2;
				r.velocity.x = r.onFloor? r.base_speed/2 : 2 * r.base_speed;
			} else {
				r.x -= 2;
				r.velocity.x = r.onFloor? -r.base_speed/2 : -2 * r.base_speed;
			}
		}
	}

	override public function update() : Void {
		super.update();
		collided = false;
		maxVelocity.y = 1000000;
		FlxG.overlap(this, wallGrip, doWallGrip, filter);
		if(!onFloor || collided)
			animation.play(velocity.y > 0? "fallin" : "jumping");
	}

	override private function deadParts() : Void {
		var n = 6;
		var size = 55;
		var height = 40;
		var img = new FlxSprite().loadGraphic("assets/images/ROGUEPARTS.png", false);
		for(i in 0...n) {
			var temp = new FlxSprite().makeGraphic(size, height, 0x00000000);
			temp.stamp(img, -i * size, 0);
			temp.velocity.set(Math.random() * 600 - 300, -Math.random() * 600);
			temp.setPosition(x + Math.random() * width, y + Math.random() * height);
			temp.acceleration.y = 420;
			temp.angularVelocity = Math.random() * 200 - 100;
			Reg.playState.add(temp);
		}
	}
}