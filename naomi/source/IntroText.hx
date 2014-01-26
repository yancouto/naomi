package;

import base.State;
import flixel.FlxG;
import flixel.text.FlxText;
import base.Timer;

class IntroText extends State {
	override public function create() : Void {
		super.create();
		// Set a background color
		FlxG.cameras.bgColor = 0xff000000;

		#if !FLX_NO_MOUSE
		FlxG.mouse.hide();
		#end
		FlxG.sound.playMusic("assets/music/castles in the underground.mp3", .5);


		FlxG.camera.fade(0xff000000, 1, true);
		add(new FlxText(15, 15, 785, "Once upon a time there lived a girl.\n\nShe lived a fulfilling life, until a fateful day, a foul witch brought a curse upon her, separating her soul from her body.\n\nHer soul was trapped on a vase with a lonely flower, while her body was kept on top of the witch's tower.\n\n\n\nMany winters passed, until the girl finally got a chance to make things right again...", 30));
		Timer.callIn(7, function() {
			FlxG.camera.fade(0xff000000, 3, false, function() { FlxG.switchState(new IntroLevel()); });
		});
	}
}