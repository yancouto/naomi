package base;

import flixel.group.FlxTypedGroup;

typedef EnemyGroup = FlxTypedGroup<Enemy>;

class PlayState extends State {
	public var map : TileMap;
	public var enemies : EnemyGroup;
	public var player : Player;
	public var interactibles : FlxTypedGroup<Interactible>;

	public function loadMap(tileMapName : String) : Void {
		super.create();
		Reg.playState = this;

		enemies = new EnemyGroup();

		map = new TileMap("assets/data/" + tileMapName + ".tmx");
		if(map.objectMap.get("otherCollidables") != null) {
			for(collidable in map.objectMap.get("otherCollidables").members) {
				collidable.immovable = true;
				map.collidableTiles.add(collidable);
			}
			map.objectMap.set("otherCollidables", null);
		}
		add(map.nonCollidableTiles);
		add(map.collidableTiles);
		add(map.glassTiles);


		player = new Player();
		var playerSpawn = map.objectMap.get("playerSpawn").members[0];
		map.objectMap.set("playerSpawn", null);
		var temp = new Rogue(playerSpawn.x, playerSpawn.y);
		enemies.add(temp);
		player.possess(temp);
		add(player);

		if(map.objectMap.get("ratSpawns") != null) {
			for(rat in map.objectMap.get("ratSpawns").members)
				enemies.add(new Rat(rat.x, rat.y));
			map.objectMap.set("ratSpawns", null);
		}

		if(map.objectMap.get("rogueSpawns") != null) {
			for(rogue in map.objectMap.get("rogueSpawns").members)
				enemies.add(new Rogue(rogue.x, rogue.y));
			map.objectMap.set("rogueSpawns", null);
		}

		if(map.objectMap.get("heavySpawns") != null) {
			for(heavy in map.objectMap.get("heavySpawns").members)
				enemies.add(new Heavy(heavy.x, heavy.y));
			map.objectMap.set("heavySpawns", null);
		}

		add(enemies);

		interactibles = new FlxTypedGroup <Interactible>();

		if(map.objectMap.get("levers") != null) {
			for(o in map.objectMap.get("levers").members)
				interactibles.add(new Lever(o.x, o.y));
			map.objectMap.set("levers", null);
		}

		if(map.objectMap.get("buttons") != null) {
			Button.buttons = new FlxTypedGroup <Button>();
			for(o in map.objectMap.get("buttons").members)
				Button.buttons.add(new Button(o.x, o.y));
			map.objectMap.set("buttons", null);
			add(Button.buttons);
		}
		
		add(interactibles);
		
		Reg.floor = map.objectMap.get("floor");
		Reg.player = player;
	}
}