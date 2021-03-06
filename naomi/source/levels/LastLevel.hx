package levels;

import flixel.FlxG;
import flixel.text.FlxText;
import flixel.effects.particles.*;
import flixel.FlxSprite;

import base.PlayState;
import base.Timer;

import menus.CreditsState;

class LastLevel extends PlayState {
	public var naomi : Naomi;
	
	override public function create() : Void {
		super.loadMap("last");
		// Set a background color
		FlxG.cameras.bgColor = 0xff000000;

		#if !FLX_NO_MOUSE
		FlxG.mouse.visible = true;
		#end

		Reg.playBackgroundMusic("Castles in the Undergroung.mp3");
		naomi = new Naomi(map.objectMap.get("naomi").members[0]);
		enemies.add(naomi);
	}
}

class Naomi extends base.Enemy {
	public function new(obj : base.Object) {
		super(obj.x, obj.y);
		loadGraphic("assets/images/naomianimation.png", true, false, 23, 45);
		animation.add("idle", [0]);
		animation.add("transforming", [1, 2], 2, false);
		animation.play("idle");

		scale.set(3, 3);
		setSize(69, 135);

		acceleration.y = 0;
		jumps = 0;

		healthColor = 0;
	}

	private function explode() : Void {
		var em = new FlxEmitter();
		em.at(this);
		em.gravity = 300;
		em.lifespan = 2;
		em.xVelocity.min = -(em.xVelocity.max = 300);
		em.yVelocity.min = -800;
		em.yVelocity.max = -100;
		for(i in 0...150) 
			em.add(new FlxParticle().makeGraphic(5, 5, 0xffff0000));
		Reg.playState.add(em);
		em.start();

		var sizes : Array<Int> = [16, 24, 30];
		var height = 54;
		var img = new FlxSprite().loadGraphic("assets/images/naomiPARTS.png", false);
		var i = 0;
		for(size in sizes) {
			var temp = new FlxSprite().makeGraphic(size, height, 0x00000000);
			temp.stamp(img, -i, 0);
			temp.velocity.set(Math.random() * 600 - 300, -Math.random() * 600);
			temp.setPosition(x + Math.random()*width, y + Math.random()*height);
			temp.acceleration.y = 420;
			Reg.playState.add(temp);
			i += size;
			Timer.callIn(Math.random()*2 + 3, function() { temp.destroy(); });
		}
		Timer.callIn(.7, function() { FlxG.switchState(new CreditsState()); });

		destroy();
	}

	override public function update() : Void {
		super.update();
		if(Reg.player.controlled == this && animation.name != 'transforming') {
			animation.play("transforming");
			Reg.playState.add(new FlxText(x - 30, y - 60, 150, "FINALLY", 20));
			Timer.callIn(3, explode);
		}
	}
	override public function walkLeft() {}
	override public function walkRight() {}
	override public function jump() {}
}