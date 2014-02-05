package menus;

import flixel.FlxSprite;
import flixel.FlxG;

class MenuButton extends FlxSprite {
	public var onClick : MenuButton -> Void;

	public function new(x : Float, y : Float, fileName : String) {
		super(x, y);
		loadGraphic("assets/images/" + fileName, false, false);
		onClick = null;
	}

	override public function update() : Void {
		super.update();
		if(onClick != null && FlxG.mouse.justPressed && this.overlapsPoint(FlxG.mouse))
			onClick(this);
	}
}