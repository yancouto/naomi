package base;

import flixel.FlxBasic;
import flixel.FlxSprite;
import flixel.FlxG;
import flixel.FlxCamera;
import flixel.util.FlxSpriteUtil;
import base.Timer;
import base.Healthbar;

using base.Utils;

class Player extends FlxBasic {
	public var controlled(default, null) : Enemy;
	
	private var soulShot : SoulShot;
	private var decay_bar : Healthbar;
	private var decay : Timer;

	public function new() {
		super();
		controlled = null;
		soulShot = null;

		decay_bar = new Healthbar(controlled);
		decay = new Timer({timeToSet: 0.25, callback: function(self : Timer) {
				if(controlled == null) return;
				
				controlled.hurt(1);
				decay_bar.refresh();
			}, repeats: true, running: false});
	}

	public function possess(enemy : Enemy) : Void {
		controlled = enemy;

		decay_bar.owner = controlled;

		decay.running = true;
		decay.reset();

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
		if(controlled != null)
			decay_bar.draw();
		if(soulShot != null)
			soulShot.draw();
	}

	override public function destroy() : Void {
		decay.delete = true;
		super.destroy();
	}
}

private class SoulShot extends FlxSprite {
	private static inline var base_speed : Float = 600;
	private var mirrorUp : TileMap.ObjectGroup;
	private var mirrorLeft : TileMap.ObjectGroup;
	private var mirrorRight : TileMap.ObjectGroup;
	private var mirrorDown : TileMap.ObjectGroup;

	public function new(x : Float, y : Float) {
		super(x, y);
		makeGraphic(16, 16, 0xff00aa55);
		velocity.set(FlxG.mouse.x - x, FlxG.mouse.y - y).normalize().mult(base_speed);
		var map = Reg.playState.map.objectMap;
		mirrorUp = map.get("mirrorUp");
		if(mirrorUp == null) mirrorUp = new TileMap.ObjectGroup();
		mirrorLeft = map.get("mirrorLeft");
		if(mirrorLeft == null) mirrorLeft = new TileMap.ObjectGroup();
		mirrorRight = map.get("mirrorRight");
		if(mirrorRight == null) mirrorRight = new TileMap.ObjectGroup();
		mirrorDown = map.get("mirrorDown");
		if(mirrorDown == null) mirrorDown = new TileMap.ObjectGroup();
	}

	override public function update() : Void {
		super.update();
		if(overlaps(Reg.playState.map.collidableTiles))
			destroy();
		FlxG.overlap(this, Reg.playState.enemies, function(a, b) { possiblePossession(b); });
		if(!exists) return;
		if(overlaps(mirrorUp))
			velocity.y = Math.abs(velocity.y);
		else if(overlaps(mirrorDown))
			velocity.y = -Math.abs(velocity.y);
		if(overlaps(mirrorLeft))
			velocity.x = Math.abs(velocity.x);
		else if(overlaps(mirrorRight))
			velocity.x = -Math.abs(velocity.x);
	}

	private function possiblePossession(enemy : Enemy) {
		if(enemy != Reg.playState.player.controlled) {
			Reg.playState.player.possess(enemy);
			destroy();
		}
	}
}