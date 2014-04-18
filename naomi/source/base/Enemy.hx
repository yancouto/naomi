package base;

import flixel.FlxSprite;
import flixel.FlxObject;
import flixel.FlxG;
import flixel.effects.particles.FlxEmitter;
import flixel.effects.particles.FlxParticle;

class Enemy extends FlxSprite {
	private var base_speed : Float;
	private var idle : Bool;
	private var jumps : Int;
	private var jumpCount : Int;
	private var jumpSpeed : Float;
	public var onFloor : Bool;

	/* Color of healthbar...
	* If it is set to 0x00000000 then the enemy will have no healthbar and won't be hurt by player
	*/
	public var healthColor : Int;

	public var canBeHurt(get, never) : Bool;

	public function new(x : Float, y : Float) {
		super(x, y);

		health = 100;
		base_speed = 100;
		acceleration.y = 500;
		drag.x = 1200;
		idle = true;
		jumps = 1;
		jumpCount = 0;
		jumpSpeed = 200;
	}

	public inline function get_canBeHurt() : Bool
		return healthColor != 0;

	/* Override the following: */
	public function walkRight() : Void {
		acceleration.x += onFloor? drag.x : drag.x/2;
		animation.play("walking");
		idle = false;
		facing = FlxObject.RIGHT;
	}

	public function walkLeft() : Void {
		acceleration.x -= onFloor? drag.x : drag.x/2;
		animation.play("walking");
		idle = false;
		facing = FlxObject.LEFT;
	}
	
	public function jump() : Void {
		if(jumpCount < jumps) {
			jumpCount++;
			y -= 1;
			velocity.y = -jumpSpeed;
		}
	}

	override public function update() : Void {
		super.update();
		onFloor = overlaps(Reg.floor) || overlaps(Platform.platforms) || overlaps(BreakableObject.platforms);
		maxVelocity.x = base_speed;

		acceleration.x = 0;
		if(!idle && velocity.x == 0) {
			idle = true;
			animation.play("idle");
		}
		if(jumps > 0 && jumpCount == 0 && velocity.y != 8)
			jumpCount = 1;
		if(jumps > 0 && jumpCount > 0 && velocity.y == 8 /* MAGIC NUMBER */ 
			&& onFloor) 

			jumpCount = 0;
	}

	override public function hurt(damage : Float) : Void {
		super.hurt(damage);
		if(health <= 5 / Player.hurtTime) {
			var i = Math.min(Std.int(damage * 5), 20);
			while(i-- != 0)
				BloodParticle.particles.add(new BloodParticle(this));
		}
	}

	private function deadParts() : Void {}

	override public function kill() : Void {
		super.kill();

		if(this == Reg.player.controlled) {
			var controlled = this;
			Timer.callIn(3, function() {
				if(controlled == Reg.player.controlled) // The player might have changed bodies in the meantime 
					FlxG.resetState(); 
			});
		}

		var i = 100;
		while(i-- != 0) {
			var blood = new BloodParticle(this);
			blood.velocity.set(Math.random() * 600 - 300, -Math.random() * 600 - 200);
			BloodParticle.particles.add(blood);
		}

		deadParts();
	}
}