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

/**
 * A FlxState which can be used for the actual gameplay.
 */
class PlayState extends FlxState {
	public var map : TileMap;
	public var enemies : FlxTypedGroup<Enemy>;
	public var player : Player;

	/**
	 * Function that is called up when to state is created to set it up. 
	 */
	override public function create() : Void {
		// Set a background color
		FlxG.cameras.bgColor = 0xff131c1b;
		// Show the mouse (in case it hasn't been disabled)
		#if !FLX_NO_MOUSE
		FlxG.mouse.show();
		#end

		enemies = new FlxTypedGroup <Enemy>();

		map = new TileMap("assets/data/test_map.tmx");
		add(map.nonCollidableTiles);
		add(map.collidableTiles);

		var temp :Enemy = new Rat(400, 230);
		enemies.add(temp);

		player = new Player();
		player.possess(temp);
		add(player);

		add(enemies);
		
		super.create();
	}
	
	/**
	 * Function that is called when this state is destroyed - you might want to 
	 * consider setting all objects this state uses to null to help garbage collection.
	 */
	override public function destroy() : Void {
		super.destroy();
	}

	/**
	 * Function that is called once every frame.
	 */
	override public function update() : Void {
		FlxG.collide(enemies, map.collidableTiles);
		super.update();
	}	
}