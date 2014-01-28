package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxMath;
import flixel.group.FlxTypedGroup;
import base.Enemy;
import base.Player;
import base.PlayState;
import base.Interactible;

class LevelDemo extends PlayState {
	public static var levelName : String;


	static function __init__() {
		levelName = "level0";
	}
	/**
	 * Function that is called up when to state is created to set it up. 
	 */
	override public function create() : Void {
		super.loadMap(levelName);
		// Set a background color
		FlxG.cameras.bgColor = 0xff0088ff;

		// Show the mouse (in case it hasn't been disabled)
		#if !FLX_NO_MOUSE
		FlxG.mouse.show();
		#end

		Reg.playBackgroundMusic("Castles in the Underground.mp3");
	}
}