package base;

import flixel.group.FlxTypedGroup;
import flixel.util.FlxPoint;

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
		var temp = Type.createInstance(Type.resolveClass(
			playerSpawn.properties.get("type")), [playerSpawn.x, playerSpawn.y]);
		map.objectMap.set("playerSpawn", null);
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

		Trap.traps = new FlxTypedGroup <Trap>();

		if(map.objectMap.get("bearTraps") != null) {
			for(o in map.objectMap.get("bearTraps").members)
				Trap.traps.add(new BearTrap(o.x, o.y));
			map.objectMap.set("bearTraps", null);
		}

		if(map.objectMap.get("fireTraps") != null) {
			for(o in map.objectMap.get("fireTraps").members)
				Trap.traps.add(new FireTrap(o.x, o.y, 
					Std.parseInt(o.properties.get("duration"))));
			map.objectMap.set("fireTraps", null);
		}

		if(map.objectMap.get("spikeTraps") != null) {
			for(o in map.objectMap.get("spikeTraps").members)
				Trap.traps.add(new SpikeTrap(o.x, o.y));
			map.objectMap.set("spikeTraps", null);
		}		

		Platform.platforms = new FlxTypedGroup <Platform>();
		if(map.objectMap.get("platforms") != null) {
			for(o in map.objectMap.get("platforms").members) {
				var dir : Bool = o.properties.get("direction")=="horizontal";
				Platform.platforms.add(new Platform([new FlxPoint(o.x, o.y),
					new FlxPoint(dir?o.x+o.width:o.x, dir?o.y:(o.y+o.height))], 
					Std.parseInt(o.properties.get("speed"))));
			}
			map.objectMap.set("platforms", null);
		}

		if(Platform.platforms != null) add(Platform.platforms);

		if(map.objectMap.get("end") != null) {
			var ref : base.Object = map.objectMap.get("end").members[0];
			interactibles.add(new End(ref.x, ref.y, ref.properties.get("next")));
			map.objectMap.set("end", null);
		}

		add(Trap.traps);
		add(interactibles);

		Rogue.wallGrip = map.objectMap.get("wallGrip");
		
		Reg.floor = map.objectMap.get("floor");
		Reg.player = player;
	}
}