package;

import flixel.util.FlxSave;
import flixel.FlxG;
import flixel.FlxState;

import base.PlayState;
import base.Player;
import base.Timer;
import base.Circuitry;

import levels.*;

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

	static public var save : FlxSave;

	static function __init__() {
		save = new FlxSave();
		save.bind("config");

		if(save.data.muted != null)
			FlxG.sound.muted = save.data.muted;
		else
			save.data.muted = FlxG.sound.muted;
	}

	static public function toggleMuted() {
		FlxG.sound.muted = !FlxG.sound.muted;
		save.data.muted = FlxG.sound.muted;
		save.flush(); //probably move this somewhere else
	}

	/* 
	* Stack of levels. This is used for easier level handling.
	* This is for debug only, since if you end up switching to
	* a level which is not adjacent to the previous one, it will
	* cause the stack not to recognize the current one in the 
	* stack. Forwarding a level in this situation will cause
	* the list to search for the previous' next state, and not
	* the current's.
	* 
	* We also suppose that all levels are 'simple'.
	*/
	static public var levels : List<String>;

	static private function resolveSwitch(state : String) {
		if(state == null) return;
		SimpleLevel.levelName = state;
		FlxG.switchState(new SimpleLevel());
	}

	static public function nextLevel() {
		for(e in playState.interactibles.iterator()) {
			if(Type.getClassName(Type.getClass(e)) == "End") {
				var end = cast(e, End);
				levels.push(playState.mapName);
				end.activate();
				return;
			}
		}
	}

	static public function prevLevel() {
		resolveSwitch(levels.pop());
	}

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