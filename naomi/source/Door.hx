package;

import flixel.FlxSprite;
import flixel.FlxG;

// DOOR HACKING
class Door extends FlxSprite {
	private var source : base.Circuitry;
	private var speedUp : Float;
	private var speedDown : Float;
	private var maxY : Float;
	private var minY : Float;
	private var spike : FlxSprite;

	public function new(obj : base.Object) {
		super(0, 0);
		loadGraphic("assets/images/door.png", false);
		spike = new FlxSprite().loadGraphic("assets/images/doorSpike.png", false);
		setPosition(obj.x, obj.y + obj.height - height);
		maxY = y;
		minY = obj.y;
		source = Reg.getTrigger(obj.properties.get("source"));
		speedUp = obj.properties.exists("speedUp")? Std.parseFloat(obj.properties.get("speedUp")) : 100;
		speedDown = obj.properties.exists("speedDown")? Std.parseFloat(obj.properties.get("speedDown")) : 50;
		immovable = true;
	}

	override public function update() : Void {
		velocity.y = source.state? -speedUp : speedDown;
		spike.update();
		super.update();
		if(y < minY)
			y = minY;
		else if(y > maxY)
			y = maxY;
		spike.setPosition(x, y + height);
		FlxG.overlap(spike, Reg.playState.enemies, function(a, b) { b.hurt(10000000); });
	}

	override public function draw() : Void {
		super.draw();
		spike.draw();
	}
}