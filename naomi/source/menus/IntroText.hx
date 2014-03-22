package menus;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxCamera;
import flixel.tweens.FlxTween;
import flixel.tweens.misc.VarTween;
import flixel.text.FlxText;

import levels.IntroLevel;

import base.Timer;
import base.State;

class IntroText extends State {
	private var fadeTimer : Timer;
	private var changingState : Bool;
	private var text : FlxText;

	public static var introText = "Once upon a time there lived a girl.\n\nShe lived a fulfilling life, " + 
		"until a fateful day, a foul witch brought a curse upon her, separating her soul from her body.\n\n" + 
		"Her soul was trapped on a vase with a lonely flower, while her body was kept on top of the witch's " + 
		"tower.\n\n\n\nMany winters passed, until the girl finally got a chance to make things right again...";

	override public function create() : Void {
		super.create();

		// Set a background color
		FlxG.cameras.bgColor = 0xff0b2b57;

		#if !FLX_NO_MOUSE
		FlxG.mouse.hide();
		#end

		Reg.playBackgroundMusic("Stars Beneath the Roof.mp3");

		text = new FlxText(15, 15, 785, introText, 30);
		add(text);

		changingState = false;

		fadeTimer = new Timer({timeToSet: 7, callback: function(self : Timer) {
			changingState = true;

			var followed = new FlxObject(FlxG.camera.x + FlxG.width/2, FlxG.camera.y + FlxG.height/2, 0, 0);
			FlxG.camera.follow(followed, FlxCamera.STYLE_NO_DEAD_ZONE);
			FlxTween.linearMotion(followed, followed.x, followed.y, followed.x, followed.y + 600, 3, true);

			FlxTween.color(2, text.color, text.color, 1, 0, text);

			Timer.callIn(3, function() { FlxG.switchState(new IntroLevel()); });

			#if !NEKO
				FlxG.sound.music.fadeOut(2.9);
			#end
			self.delete = true;
		}});
	}

	override public function update() : Void {
		super.update();
		if(FlxG.mouse.justPressed || FlxG.keyboard.anyJustPressed(['SPACE', 'ENTER', 'ESCAPE'])) {
			if(!changingState)
				fadeTimer.callback(fadeTimer);
			else {
				#if !NEKO
					FlxG.sound.music.stop();
				#end
				FlxG.switchState(new IntroLevel());
			}
		}
	}
}