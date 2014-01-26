package;

import flixel.tweens.FlxTween;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxObject;
import flixel.util.FlxPoint;
import flixel.group.FlxTypedGroup;

class Platform extends FlxSprite {
	private var path : FlxTween;

	public function new(points : Array<FlxPoint>, ?speed : Float) {
		super(points[0].x, points[0].y);

		path = FlxTween.linearPath(this, points, speed==null?100:speed, 
			false, {type: FlxTween.PINGPONG});

		makeGraphic(128, 20, 0xffc68c3e);
	}

	public function toggle() : Void
		path.active = !path.active;

	public static var platforms : FlxTypedGroup<Platform>;
}