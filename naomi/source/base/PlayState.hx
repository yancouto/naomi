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
		interactibles = new FlxTypedGroup <Interactible>();

		map = new TileMap("assets/data/" + tileMapName + ".tmx");
		if(map.objectMap.exists("otherCollidables")) {
			for(collidable in map.objectMap.get("otherCollidables").members) {
				collidable.immovable = true;
				map.collidableTiles.add(collidable);
			}
			map.objectMap.remove("otherCollidables");
		}
		add(map.nonCollidableTiles);
		add(map.collidableTiles);
		add(map.glassTiles);

		if(map.objectMap.exists("end")) {
			var ref : base.Object = map.objectMap.get("end").members[0];
			interactibles.add(new End(ref.x, ref.y, ref.properties.get("next")));
			map.objectMap.remove("end");
		}

		player = new Player();
		add(new Beginning(map.objectMap.get("playerSpawn").members[0]));
		map.objectMap.remove("playerSpawn");
		add(player);

		if(map.objectMap.exists("ratSpawns")) {
			for(rat in map.objectMap.get("ratSpawns").members)
				enemies.add(new Rat(rat.x, rat.y));
			map.objectMap.remove("ratSpawns");
		}

		if(map.objectMap.exists("rogueSpawns")) {
			for(rogue in map.objectMap.get("rogueSpawns").members)
				enemies.add(new Rogue(rogue.x, rogue.y));
			map.objectMap.remove("rogueSpawns");
		}

		if(map.objectMap.exists("heavySpawns")) {
			for(heavy in map.objectMap.get("heavySpawns").members)
				enemies.add(new Heavy(heavy.x, heavy.y));
			map.objectMap.remove("heavySpawns");
		}

		Reg.circuitryComponents = new Map <String, Circuitry>();

		if(map.objectMap.exists("levers")) {
			for(o in map.objectMap.get("levers").members)
				interactibles.add(new Lever(o.x, o.y, o.properties.get("id")));
			map.objectMap.remove("levers");
		}

		if(map.objectMap.exists("buttons")) {
			Button.buttons = new FlxTypedGroup <Button>();
			for(o in map.objectMap.get("buttons").members)
				Button.buttons.add(new Button(o.x, o.y, o.properties.get("id")));
			map.objectMap.remove("buttons");
			add(Button.buttons);
		}

		Trap.traps = new FlxTypedGroup <Trap>();

		if(map.objectMap.exists("bearTraps")) {
			for(o in map.objectMap.get("bearTraps").members)
				Trap.traps.add(new BearTrap(o.x, o.y));
			map.objectMap.remove("bearTraps");
		}

		if(map.objectMap.exists("fireTraps")) {
			for(o in map.objectMap.get("fireTraps").members)
				Trap.traps.add(new FireTrap(o.x, o.y, 
					Std.parseInt(o.properties.get("duration"))));
			map.objectMap.remove("fireTraps");
		}

		if(map.objectMap.get("spikeTraps") != null) {
			for(o in map.objectMap.get("spikeTraps").members)
				Trap.traps.add(new SpikeTrap(o.x, o.y));
			map.objectMap.remove("spikeTraps");
		}		

		Platform.platforms = new FlxTypedGroup <Platform>();
		if(map.objectMap.exists("platforms")) {
			for(o in map.objectMap.get("platforms").members) {
				var horizontal : Bool = o.properties.get("direction")=="horizontal";
				Platform.platforms.add(new Platform([new FlxPoint(o.x, o.y),
					new FlxPoint(horizontal? o.x + o.width - 128 : o.x,
						horizontal? o.y : (o.y + o.height - 36))], 
					Std.parseInt(o.properties.get("speed"))));
			}
			map.objectMap.remove("platforms");
		}

		add(Platform.platforms);

		if(map.objectMap.exists("doors")) {
			for(obj in map.objectMap.get("doors").members)
				map.collidableTiles.add(new Door(obj.x, obj.y + obj.height, obj));
			map.objectMap.remove("doors");
		}


		add(Trap.traps);
		add(interactibles);
		add(enemies);
		add(player.decay_bar);

		Rogue.wallGrip = map.objectMap.get("wallGrip");
		
		Reg.floor = map.objectMap.get("floor");
		Reg.player = player;
	}
}