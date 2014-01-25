package base;

import flixel.group.FlxTypedGroup;

typedef EnemyGroup = FlxTypedGroup<Enemy>;

class PlayState extends State {
	public var map : TileMap;
	public var enemies : EnemyGroup;
	public var player : Player;
}