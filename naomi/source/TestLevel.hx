package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxMath;
import flixel.group.FlxTypedGroup;
import base.Enemy;
import base.Player;
import base.PlayState;
import base.Interactible;

class TestLevel extends PlayState {

	override public function create() : Void {
		super.loadMap("test_map4");
		FlxG.cameras.bgColor = 0xff0088ff;

		#if !FLX_NO_MOUSE
			FlxG.mouse.show();
		#end

	}
	
	override public function destroy() : Void {
		super.destroy();
	}

	override public function update() : Void {
		FlxG.collide(map.collidableTiles, enemies);
		FlxG.collide(map.glassTiles, enemies);
		FlxG.collide(Platform.platforms, enemies);
		FlxG.overlap(BreakablePlatform.platforms, enemies, BreakablePlatform.manageCollision);
		super.update();
	}	
}