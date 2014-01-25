package base;

import flixel.FlxSprite;
import flixel.FlxObject;

class Healthbar extends FlxSprite {
	public var owner : FlxObject;

	public function new(_owner : FlxObject) {
		super(0, GameClass.gameHeight-100);

		makeGraphic(GameClass.gameWidth, 50, 0x0032cd32);

		owner = _owner;
		scrollFactor.x = scrollFactor.y = 0;
	}

	public function refresh() {
		if(Reg.player.controlled == null) return;

		var _width = 2.5*owner.health;

		makeGraphic(Std.int(_width), 50, 0xff32cd32); //CRASHING WHY
		x = GameClass.gameWidth/2 - _width/2;
	}

	override public function draw() if(Reg.player.controlled!=null) super.draw();
}