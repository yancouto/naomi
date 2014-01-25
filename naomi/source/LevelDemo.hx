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

	/**
	 * Function that is called up when to state is created to set it up. 
	 */
	override public function create() : Void {
		super.loadMap("test_map3");
		// Set a background color
		FlxG.cameras.bgColor = 0xff0088ff;
		// Show the mouse (in case it hasn't been disabled)
		#if !FLX_NO_MOUSE
		FlxG.mouse.show();
		#end

		
	}
	
	/**
	 * Function that is called when this state is destroyed - you might want to 
	 * consider setting all objects this state uses to null to help garbage collection.
	 */
	override public function destroy() : Void {
		super.destroy();
	}

	/**
	 * Function that is called once every frame.
	 */
	override public function update() : Void {
		FlxG.collide(map.collidableTiles, enemies);
		FlxG.collide(map.glassTiles, enemies);
		super.update();
	}	
}