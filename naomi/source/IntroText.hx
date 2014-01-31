package;

import base.State;
import flixel.FlxG;
import flixel.text.FlxText;
import base.Timer;
import levels.IntroLevel;

class IntroText extends State {
	private var fadeTimer : Timer;
	private var fading : Bool;

	override public function create() : Void {
		super.create();
		// Set a background color
		FlxG.cameras.bgColor = 0xff000000;

		#if !FLX_NO_MOUSE
		FlxG.mouse.hide();
		#end

		Reg.playBackgroundMusic("Stars Beneath the Roof.mp3");


		FlxG.camera.fade(0xff000000, 1, true, true);
		add(new FlxText(15, 15, 785, "Once upon a time there lived a girl.\n\nShe lived a fulfilling life, until a fateful day, a foul witch brought a curse upon her, separating her soul from her body.\n\nHer soul was trapped on a vase with a lonely flower, while her body was kept on top of the witch's tower.\n\n\n\nMany winters passed, until the girl finally got a chance to make things right again...", 30));
		fadeTimer = new Timer({timeToSet: 7, callback: function(self : Timer) {
			fading = true;
			FlxG.sound.music.fadeOut(2.9);
			self.delete = true;
			FlxG.camera.fade(0xff000000, 3, false, function() { FlxG.switchState(new IntroLevel()); }, true);
		}});
	}

	override public function update() : Void {
		super.update();
		if(FlxG.mouse.justPressed || FlxG.keyboard.anyJustPressed(['SPACE', 'ENTER', 'ESCAPE'])) {
			if(!fading)
				fadeTimer.callback(fadeTimer);
			else {
				FlxG.sound.music.stop();
				FlxG.switchState(new IntroLevel());
			}
		}
	}
}