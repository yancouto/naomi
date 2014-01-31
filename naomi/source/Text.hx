package;

import flixel.text.FlxText;
import flixel.tweens.FlxTween;

import base.Circuitry;

class Text extends FlxText {
	private var fadeInTrigger : Circuitry;
	private var fadeOutTrigger : Circuitry;

	public function new(obj : base.Object) {
		super(obj.x, obj.y, Std.int(obj.width), obj.properties.get("text"), obj.properties.exists("size")? Std.parseInt(obj.properties.get("size")) : 12);
		if(obj.properties.exists("color"))
			color = Std.parseInt(obj.properties.get("color"));
		fadeInTrigger = fadeOutTrigger = null;
		if(obj.properties.exists("fadeInTrigger")) {
			fadeInTrigger = Reg.getTrigger(obj.properties.get("fadeInTrigger"));
			alpha = 0;
		}
		if(obj.properties.exists("fadeOutTrigger"))
			fadeOutTrigger = Reg.getTrigger(obj.properties.get("fadeOutTrigger"));
	}

	override public function update() : Void {
		super.update();
		if(fadeInTrigger != null) {
			if(fadeInTrigger.state) {
				fadeInTrigger = null;
				FlxTween.color(2, color, color, 0, 1, this);
			}
		} else if(fadeOutTrigger != null && fadeOutTrigger.state) {
			fadeOutTrigger = null;
			FlxTween.color(2, color, color, 1, 0, this);
		}
	}
}