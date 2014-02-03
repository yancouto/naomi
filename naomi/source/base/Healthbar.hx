package base;

import flixel.FlxSprite;
import flixel.FlxObject;

class Healthbar extends FlxSprite {
	private var healthSprite : FlxSprite;

	public function new() {
		super(0, GameClass.gameHeight - 100);
		healthSprite = new FlxSprite(0, GameClass.gameHeight - 90);
		healthSprite.scrollFactor.x = healthSprite.scrollFactor.y = 0;

		scrollFactor.x = scrollFactor.y = 0;
	}

	public function resetOwner() : Void {
		var owner = Reg.player.controlled;
		if(owner == null || !owner.canBeHurt) {
			/* Invisible Sprites */
			makeGraphic(1, 1, 0x00000000);
			healthSprite.makeGraphic(1, 1, 0x00000000);
			return;
		}
		healthSprite.color = owner.healthColor;
		loadGraphic("assets/images/" + Type.getClassName(Type.getClass(owner)) + "_meter.png", false);
		x = GameClass.gameWidth/2 - width/2;
		healthSprite.makeGraphic(Std.int(2*owner.health), 33);
		healthSprite.x = GameClass.gameWidth/2 - 2*owner.health/2;
	}

	public function refresh() : Void {
		var owner = Reg.player.controlled;
		if(owner == null) return;

		var _width = 2 * owner.health;

		healthSprite.makeGraphic(Std.int(_width), 33);
		healthSprite.x = GameClass.gameWidth/2 - _width/2;
	}

	override public function draw() : Void {
		if(Reg.player.controlled == null) return;
		super.draw();
		healthSprite.draw();
	}
}