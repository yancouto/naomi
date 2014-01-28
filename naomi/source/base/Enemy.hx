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
		drag.x = 400;
		idle = true;
		jumps = 1;
		jumpCount = 0;
		jumpSpeed = 200;
	}

	public inline function get_canBeHurt() : Bool
		return healthColor != 0;

	/* Override the following: */
	public function walkRight() : Void {
		acceleration.x += drag.x;
		animation.play("walking");
		idle = false;
		facing = FlxObject.RIGHT;
	}
	public function walkLeft() : Void {
		acceleration.x -= drag.x;
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
		onFloor = overlaps(Reg.floor) || overlaps(Platform.platforms) || overlaps(BreakablePlatform.platforms);
		maxVelocity.x = onFloor? base_speed : 2*base_speed;

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

	private function deadParts() : Void {}

	override public function kill() : Void {
		super.kill();

		if(this == Reg.player.controlled) {
			Reg.player.possess(null);
			Timer.callIn(3, function() { FlxG.resetState(); });
		}

		var em = new FlxEmitter();
		em.at(this);
		em.gravity = 300;
		em.lifespan = 2;
		em.xVelocity.min = -(em.xVelocity.max = 300);
		em.yVelocity.min = -800;
		em.yVelocity.max = -100;
		for(i in 0...100) 
			em.add(new FlxParticle().makeGraphic(5, 5, 0xffff0000));
		Reg.playState.add(em);
		em.start();

		deadParts();
	}
}