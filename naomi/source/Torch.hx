package;

import flixel.FlxSprite;

class Torch extends FlxSprite {
	private var source : base.Circuitry;

	public function new(obj : base.Object) {
		super(obj.x, obj.y);
		loadGraphic("assets/images/torchanimation.png", true, false, 35, 70);
		animation.add("false", [0]);
		animation.add("true", [1, 2, 3], 15);
		animation.play("true");

		scale.set(.75, .75);

		source = obj.properties.exists("source")? Reg.circuitryComponents.get(obj.properties.get("source")) : null;
	}

	override public function update() : Void {
		super.update();
		if(source != null)
			animation.play(Std.string(source.state));
	}
}