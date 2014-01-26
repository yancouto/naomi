package;

import flixel.FlxSprite;

// DOOR HACKING
class Door extends FlxSprite {
	private var source : base.Circuitry;
	private var speedUp : Float;
	private var speedDown : Float;

	public function new(x : Float, y : Float, obj : base.Object) {
		super(x, y);
		loadGraphic("assets/images/door.png", false);
		y -= height;
		source = Reg.circuitryComponents.get(obj.properties.get("source"));

	}

	override public function update() : Void {
		super.update();
		//NOT FINISHED
	}
}