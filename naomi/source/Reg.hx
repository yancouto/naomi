package;

import flixel.util.FlxSave;
import flixel.FlxG;

import base.PlayState;
import base.Player;
import base.Timer;
import base.Circuitry;

/**
 * Handy, pre-built Registry class that can be used to store 
 * references to objects and other things for quick-access. Feel
 * free to simply ignore it or change it in any way you like.
 */
class Reg {

	static public var playState : PlayState;
	static public var floor : TileMap.PObjectGroup;
	static public var player : Player;
	static public var circuitryComponents : Map<String, Circuitry>;
	static public var paused : Bool;

	static public function getTrigger(name : String) : Circuitry {
		if(name == null) throw "Invalid trigger name [[null]]";
		if(!circuitryComponents.exists(name)) throw ("Invalid trigger name '" + name + "'.");
		return circuitryComponents.get(name);
	}
	
	static private var backgroungMusicName : String = "";
	static public function playBackgroundMusic(fileName : String, fadeTime : Float = 2) : Void {
		#if !NEKO
			if(fileName == backgroungMusicName) return;
			backgroungMusicName = fileName;
			var doFadeOut = fadeTime > 0 && FlxG.sound.music != null && FlxG.sound.music.active;
			if(doFadeOut)
				FlxG.sound.music.fadeOut(fadeTime);
			Timer.callIn(doFadeOut? fadeTime : 0, function() {
				FlxG.sound.playMusic("assets/music/" + fileName);
				if(fadeTime > 0) {
					FlxG.sound.music.pause();
					FlxG.sound.music.fadeIn(fadeTime);
				}
			});
		#end
	}
}