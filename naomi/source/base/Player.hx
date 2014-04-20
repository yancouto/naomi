package base;

import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxG;
import flixel.FlxCamera;
import flixel.util.FlxSpriteUtil;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import flixel.addons.effects.FlxTrail;
import base.Timer;
import base.Healthbar;
import base.Utils;

using base.UsingUtils;

class Player extends FlxObject {
	public static var hurtTime = 0.25;

	public var controlled(default, null) : Enemy;
	
	private var soulShot : SoulShot;
	private var decay_bar : Healthbar;
	public var decay : Timer;

	public var away(default, null) : Bool;

	private var cameraOffsetX : Float;
	private var cameraOffsetY : Float;

	public function new() {
		super(0, 0, 0, 0);
		FlxG.camera.follow(this, FlxCamera.STYLE_PLATFORMER, 5);
		controlled = null;
		soulShot = null;

		decay_bar = new Healthbar();
		decay = new Timer({timeToSet: hurtTime, callback: function(self : Timer) {
				if(controlled == null || !controlled.canBeHurt || !controlled.alive) {
					self.running = false;
					self.reset();
					return;
				}

				controlled.hurt(1);
				decay_bar.refresh();
			}, repeats: true, running: false});

		cameraOffsetX = cameraOffsetY = 0;
	}

	public function possess(enemy : Enemy) : Void {
		var prevControlled = controlled;
		controlled = enemy;

		if(prevControlled != null) {
			if(prevControlled.health <= 5 / hurtTime)
				prevControlled.hurt(10000);
		}

		away = false;
		decay_bar.resetOwner();

		decay.running = true;
		decay.reset();

		if(controlled != null) {
			width = controlled.width;
			height = controlled.height;

			// Focus camera -- doesn't fucking work properly
			FlxG.camera.follow(this, FlxCamera.STYLE_LOCKON, 5);
			cameraOffsetX = cameraOffsetY = 0;
			Timer.callIn(1, function() {
					if(!away)
						FlxG.camera.follow(this, FlxCamera.STYLE_PLATFORMER, 5);
				});
		}
	}

	override public function update() : Void {
		super.update();

		decay_bar.update();

		if(soulShot != null)  {
			soulShot.update();
			if(FlxG.mouse.justPressed)
				soulShot.destroy();
			if(!soulShot.exists) {
				soulShot = null;
				FlxG.camera.follow(this, FlxCamera.STYLE_PLATFORMER, 5);
				
				away = false;
				decay.running = true;
			}
			return;
		}

		if(controlled == null || !controlled.alive) return;
		
		if(FlxG.keys.pressed.A)
			controlled.walkLeft();
		else if(FlxG.keys.pressed.D)
			controlled.walkRight();
		
		if(FlxG.keys.anyJustPressed(['W', 'SPACE']))
			controlled.jump();

		if(FlxG.keys.justPressed.E)
			FlxG.overlap(Reg.playState.interactibles, controlled, Interactible.doInteraction);

		manageCameraScroll();
		x = controlled.x + cameraOffsetX;
		y = controlled.y + cameraOffsetY;

		if(FlxG.mouse.justPressed) {
			soulShot = new SoulShot(controlled.x, controlled.y);
			FlxG.camera.follow(soulShot, FlxCamera.STYLE_LOCKON, 5);
			
			decay.running = false;
			away = true;
		}
	}

	private static inline var speed : Float = 200;
	private static inline var maxTranslate : Float = 100;
	private static inline var minimumOffset : Float = 75;
	private function manageCameraScroll() : Void {
		var prevX = cameraOffsetX;
		var prevY = cameraOffsetY;
		var dt = FlxG.elapsed;
		var mouseX = FlxG.mouse.screenX, mouseY = FlxG.mouse.screenY;

		if(mouseY <= minimumOffset) cameraOffsetY -= speed * dt;
		if(mouseY >= FlxG.height - minimumOffset) cameraOffsetY += speed * dt;
		if(mouseX <= minimumOffset) cameraOffsetX -= speed * dt;
		if(mouseX >= FlxG.width - minimumOffset) cameraOffsetX += speed * dt;

		var diff = speed * dt/2;
		if(diff >= Math.abs(cameraOffsetX)) cameraOffsetX = 0;
		else cameraOffsetX -= Utils.sign(cameraOffsetX) * diff;
		if(diff >= Math.abs(cameraOffsetY)) cameraOffsetY = 0;
		else cameraOffsetY -= Utils.sign(cameraOffsetY) * diff;

		if(Math.abs(cameraOffsetX) > maxTranslate) cameraOffsetX = Utils.sign(cameraOffsetX) * maxTranslate;
		if(Math.abs(cameraOffsetY) > maxTranslate) cameraOffsetY = Utils.sign(cameraOffsetY) * maxTranslate;

		if(FlxG.camera.target != this) return;
		if(cameraOffsetX == 0 && cameraOffsetY == 0 && (cameraOffsetX != prevX || cameraOffsetY != prevY))
			FlxG.camera.follow(this, FlxCamera.STYLE_PLATFORMER, 5);
		else if((cameraOffsetX != 0 || cameraOffsetY != 0) && prevX == 0 && prevY == 0)
			FlxG.camera.follow(this, FlxCamera.STYLE_LOCKON, 5);
	}

	override public function draw() : Void {
		decay_bar.draw();
		super.draw();
		if(soulShot != null)
			soulShot.draw();
	}

	override public function destroy() : Void {
		decay.delete = true;
		decay = null;
		soulShot = null;
		decay_bar = null;
		controlled = null;
		super.destroy();
	}
}

private class SoulShot extends FlxSprite {
	private static inline var base_speed : Float = 600;
	private var mirrorUp : TileMap.PObjectGroup;
	private var mirrorLeft : TileMap.PObjectGroup;
	private var mirrorRight : TileMap.PObjectGroup;
	private var mirrorDown : TileMap.PObjectGroup;
	private var trail : FlxTrail;

	public function new(x : Float, y : Float) {
		super(x, y);

		loadGraphic("assets/images/soul_animation.png", true, false, 32, 32);
		animation.add("moving", [for(i in 1...5) i], 8);
		animation.play("moving");
		angularVelocity = 200;

		offset.set(6, 6);
		setSize(20, 20);

		velocity.set(FlxG.mouse.x - x, FlxG.mouse.y - y).normalize().mult(base_speed);
		setPosition(x + .05 * velocity.x, y + .05 * velocity.y);

		trail = new FlxTrail(this, null, 5, 0, .5, .1);

		var map = Reg.playState.map.objectMap;
		mirrorUp = map.get("mirrorUp");
		if(mirrorUp == null) mirrorUp = new TileMap.PObjectGroup();
		mirrorLeft = map.get("mirrorLeft");
		if(mirrorLeft == null) mirrorLeft = new TileMap.PObjectGroup();
		mirrorRight = map.get("mirrorRight");
		if(mirrorRight == null) mirrorRight = new TileMap.PObjectGroup();
		mirrorDown = map.get("mirrorDown");
		if(mirrorDown == null) mirrorDown = new TileMap.PObjectGroup();
	}

	override public function draw() : Void {
		trail.draw();
		super.draw();
	}

	override public function update() : Void {
		super.update();
		trail.update();
		if(overlaps(Reg.playState.map.collidableTiles) || overlaps(Platform.platforms) || overlaps(Trap.traps))
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