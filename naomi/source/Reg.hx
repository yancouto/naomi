package;

import flixel.util.FlxSave;
import base.PlayState;
import base.Player;
import flixel.FlxG;
import base.Timer;

/**
 * Handy, pre-built Registry class that can be used to store 
 * references to objects and other things for quick-access. Feel
 * free to simply ignore it or change it in any way you like.
 */
class Reg {

	static public var playState : PlayState;
	static public var floor : TileMap.PObjectGroup; //ugly?
	static public var player : Player;
	static public var circuitryComponents : Map<String, base.Circuitry>;
	
	static private var backgroungMusicName : String = "";
	static public function playBackgroundMusic(fileName : String, fadeTime : Float = 2) : Void {
		if(fileName == backgroungMusicName) return;
		backgroungMusicName = fileName;
		var doFadeOut = FlxG.sound.music != null && FlxG.sound.music.active;
		if(doFadeOut)
			FlxG.sound.music.fadeOut(fadeTime);
		Timer.callIn(doFadeOut? fadeTime : 0, function() {
			FlxG.sound.playMusic("assets/music/" + fileName);
			FlxG.sound.music.pause();
			FlxG.sound.music.fadeIn(fadeTime);
		});
	}
}