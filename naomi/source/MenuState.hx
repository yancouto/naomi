package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxMath;

/**
 * A FlxState which can be used for the game's menu.
 */
class MenuState extends FlxState {
	/**
	 * Function that is called up when to state is created to set it up. 
	 */
	override public function create() : Void {
		// Set a background color
		FlxG.cameras.bgColor = 0xff131c1b;
		// Show the mouse (in case it hasn't been disabled)
		#if !FLX_NO_MOUSE
		FlxG.mouse.show();
		#end

		add(new FlxText(100, 100, 300, "Click Anywhere To Play", 20));

		//FlxG.sound.playMusic("assets/music/stars beneath the roof.mp3", .2);
		
		super.create();
	}
	
	/**
	 * Function that is called when this state is destroyed - you might want to 
	 * consider setting all objects this state uses to null to help garbage collection.
	 */
	override public function destroy() : Void {
		super.destroy();
		//FlxG.sound.music.fadeOut(1);
	}

	/**
	 * Function that is called once every frame.
	 */
	override public function update() : Void {
		super.update();
		if(FlxG.mouse.justReleased)
			FlxG.switchState(new LevelDemo());
	}	
}