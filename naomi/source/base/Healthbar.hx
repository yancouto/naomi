package base;

import flixel.FlxSprite;
import flixel.FlxObject;

class Healthbar extends FlxSprite {
	public var owner : FlxObject;
	public var healthSprite : FlxSprite;

	public function new() {
		super(0, GameClass.gameHeight - 100);
		healthSprite = new FlxSprite(0, GameClass.gameHeight - 90);
		healthSprite.scrollFactor.x = healthSprite.scrollFactor.y = 0;

		scrollFactor.x = scrollFactor.y = 0;
	}

	public function setOwner(_owner : FlxObject) : Void {
		owner = _owner;
		loadGraphic("assets/images/" + Type.getClassName(Type.getClass(owner)) + "_meter.png", false);
		x = GameClass.gameWidth/2 - width/2;
		healthSprite.makeGraphic(Std.int(2*owner.health), 33);
		healthSprite.x = GameClass.gameWidth/2 - 2*owner.health/2;
		if(Std.is(owner, Heavy)) healthSprite.color = 0xff881221;
		else if(Std.is(owner, Rogue)) healthSprite.color = 0xff32cd32;
		else healthSprite.color = 0xff999999;
	}

	public function refresh() : Void {
		if(Reg.player.controlled == null) return;

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