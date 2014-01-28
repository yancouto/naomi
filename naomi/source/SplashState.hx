package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxObject;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.group.FlxTypedGroup;
import flixel.ui.FlxButton;
import flixel.util.FlxMath;
import flixel.tweens.FlxTween;
import base.State;
import base.Timer;
using base.UsingUtils;

/**
 * Splash Screen stuff. Just Marvellous Soft for now.
 */
class SplashState extends State {
	private var splash : FlxSprite;

	/**
	 * Called on creation. 
	 */
	override public function create() : Void {
		// Set a background color
		FlxG.cameras.bgColor = 0xffbbbbbb;

		#if !FLX_NO_MOUSE
		FlxG.mouse.hide();
		#end

		splash = new FlxSprite(20, 20);
		splash.loadGraphic("assets/images/Marvellous Soft.png", false);
		splash.offset.set(20, 0);
		add(splash);

		FlxG.camera.fade(0xff000000, 1, true);

		Timer.callIn(2, function() { FlxG.camera.fade(0xff000000, 2, false); });
		Timer.callIn(4.2, function() { FlxG.switchState(new MenuState()); });

		super.create();
	}
	
	/**
	 * Function that is called when this state is destroyed - you might want to 
	 * consider setting all objects this state uses to null to help garbage collection.
	 */
	override public function destroy() : Void {
		splash = null;
		super.destroy();
	}
}