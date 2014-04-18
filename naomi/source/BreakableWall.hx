package;

import flixel.FlxG;

class BreakableWall extends BreakableObject {
	override public function new(obj : base.Object) {
		super(obj);

		loadGraphic("assets/images/weakwall.png", true, false, 64, 64);
		
		animation.add("still", [0]);
		animation.add("breaking", [1, 2], 4, false);
		animation.play("still");

		setSize(64, 64);
		health = resistance;
	}

	override public function update() : Void {
		if(health <= 0) triggerBreaking();
		super.update();
	}

	override public function triggerBreaking(?e : base.Enemy) : Void {
		animation.play("breaking");
		setSize(0, 0);
		Timer.callIn(.5, function() {destroy();});
	}
}