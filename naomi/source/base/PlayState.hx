package base;

import flixel.group.FlxTypedGroup;
import flixel.util.FlxPoint;
import flixel.text.FlxText;
import flixel.FlxG;
import flixel.group.FlxGroup;
import flixel.FlxSprite;

typedef EnemyGroup = FlxTypedGroup<Enemy>;

class PlayState extends State {
	public var map : TileMap;
	public var enemies : EnemyGroup;
	public var player : Player;
	public var interactibles : FlxTypedGroup<Interactible>;
	public var paused : Bool;
	public var pauseMenu : FlxGroup;

	public function loadMap(tileMapName : String) : Void {
		super.create();
		Reg.playState = this;
		paused = false;

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

		if(map.objectMap.exists("levelInfo")) {
			var ps = map.objectMap.get("levelInfo").members[0].properties;
			var back = new FlxSprite(500, 0).loadGraphic("assets/images/" + ps.get("background"), false);
			back.scrollFactor.y = 1;
			back.scrollFactor.x = .8;
			add(back);
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
		if(map.objectMap.exists("playerSpawn")) {
			add(new Beginning(map.objectMap.get("playerSpawn").members[0]));
			map.objectMap.remove("playerSpawn");
		}
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
				Trap.traps.add(new FireTrap(o));
			map.objectMap.remove("fireTraps");
		}

		if(map.objectMap.get("spikeTraps") != null) {
			for(o in map.objectMap.get("spikeTraps").members)
				Trap.traps.add(new SpikeTrap(o));
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
				map.collidableTiles.add(new Door(obj));
			map.objectMap.remove("doors");
		}

		BreakablePlatform.platforms = new FlxTypedGroup <BreakablePlatform>();
		if(map.objectMap.exists("breakables")) {
			for(obj in map.objectMap.get("breakables").members)
				BreakablePlatform.platforms.add(new BreakablePlatform(obj));
			map.objectMap.remove("breakables");
		}
		add(BreakablePlatform.platforms);

		if(map.objectMap.exists("torchs")) {
			for(obj in map.objectMap.get("torchs").members)
				add(new Torch(obj));
			map.objectMap.remove("torchs");
		}

		add(Trap.traps);
		add(interactibles);
		add(enemies);
		add(player.decay_bar);

		if(map.objectMap.exists("text")) {
			for(obj in map.objectMap.get("text").members) {
				var t = new FlxText(obj.x, obj.y, Std.int(obj.width), obj.properties.get("text"), obj.properties.exists("size")? Std.parseInt(obj.properties.get("size")) : 12);
				if(obj.properties.exists("color"))
					t.color = Std.parseInt(obj.properties.get("color"));
				add(t);
			}
			map.objectMap.remove("text");
		}

		Rogue.wallGrip = map.objectMap.get("wallGrip");
		
		Reg.floor = map.objectMap.get("floor");
		Reg.player = player;

		pauseMenu = new FlxGroup();
		pauseMenu.add(new FlxText(100, 100, 100, "PAUSED", 20));
	}

	override public function update() : Void {
		if(FlxG.keyboard.anyJustPressed(['P', 'ESCAPE']))
			FlxG.paused = !FlxG.paused;
		if(FlxG.paused) {
			pauseMenu.update();
			return;
		}

		FlxG.collide(map.collidableTiles, enemies);
		FlxG.collide(map.glassTiles, enemies);
		FlxG.collide(Platform.platforms, enemies);
		FlxG.overlap(BreakablePlatform.platforms, enemies, BreakablePlatform.manageCollision);

		super.update();
	}

	override public function draw() : Void {
		super.draw();
		if(FlxG.paused)
			pauseMenu.draw();
	}
}