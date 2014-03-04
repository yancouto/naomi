package;

import flixel.tweens.FlxTween;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxObject;
import flixel.util.FlxPoint;
import flixel.group.FlxTypedGroup;

class Platform extends FlxSprite {
	private var path : FlxTween;

	public function new(points : Array<FlxPoint>, speed : Float = 100) {
		super(points[0].x, points[0].y);

		path = FlxTween.linearPath(this, points, speed, 
			false, {type: FlxTween.PINGPONG});

		loadGraphic("assets/images/movingplatform.png", false);
	}

	public function toggle() : Void
		path.active = !path.active;

	public static var platforms : FlxTypedGroup<Platform>;

	public static function pause() : Void
		for(p in platforms.iterator())
			p.toggle();
}