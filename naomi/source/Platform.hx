package;

import flixel.tween.FlxTween;
import flixel.FlxSprite;
import flixel.FlxOb
import flixel.util.FlxPoint;

class Platform extends FlxSprite {
	private var path : FlxTween;

	public function new(points : Array<FlxPoint>, speed : Float) {
		super(points[0].x, points[0].y);

		path = FlxTween.linearPath(this, points, speed, false, {type: FlxTween.PINGPONG});

		makeGraphic(64, 20, 0xffc68c3e);
		allowCollisions = FlxObject.NONE & FlxObject.UP;
	}

	private function notify(e1 : FlxObject, e2 : FlxObject) : Void {
		e1.velocity.x += e2.velocity.x;
		e1.velocity.y += e2.velocity.y;
	}

	override public function update() : Void
		FlxG.overlaps(Reg.playState.enemies, this, notify);

	public function toggle() : Void
		path.active = !path.active;
}