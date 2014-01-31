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

		player = new Player();
		Reg.player = player;
		enemies = new EnemyGroup();
		interactibles = new FlxTypedGroup <Interactible>();

		map = new TileMap("assets/data/" + tileMapName + ".tmx");

		/* Object Layer of rectangles that collide with the player.objectMap
		*  Useful for half-tiles
		*/
		if(map.objectMap.exists("otherCollidables")) {
			for(collidable in map.objectMap.get("otherCollidables").members) {
				collidable.immovable = true;
				map.collidableTiles.add(collidable);
			}
			map.objectMap.remove("otherCollidables");
		}

		/*
		* Useless for now. Should be used for important level stuff.
		*/
		if(map.objectMap.exists("levelInfo")) {
			//something something
			map.objectMap.remove("levelInfo");
		}

		/*
		* Adding default tiles to be drawn and updated.
		*/
		add(map.nonCollidableTiles);
		add(map.collidableTiles);
		add(map.glassTiles);

		/*
		* End of the level stuff.
		* Not strictly necessary but should be used in most levels.
		*/
		if(map.objectMap.exists("end")) {
			interactibles.add(new End(map.objectMap.get("end").members[0]));
			map.objectMap.remove("end");
		}

		/*
		* Beginning of the level stuff.
		* Not strictly necessary but should be used in most levels. 
		*/
		if(map.objectMap.exists("playerSpawn")) {
			add(new Beginning(map.objectMap.get("playerSpawn").members[0]));
			map.objectMap.remove("playerSpawn");
		}

		/* Adding player over spawns and end. */
		add(player);

		/* [Enemy Spawns] */

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

		/* [/EnemySpawns] */

		/* [Circuitry] */

		Reg.circuitryComponents = new Map <String, Circuitry>();

		if(map.objectMap.exists("levers")) {
			for(obj in map.objectMap.get("levers").members)
				interactibles.add(new Lever(obj));
			map.objectMap.remove("levers");
		}

		if(map.objectMap.exists("buttons")) {
			Button.buttons = new FlxTypedGroup <Button>();
			for(obj in map.objectMap.get("buttons").members)
				Button.buttons.add(new Button(obj));
			map.objectMap.remove("buttons");
			add(Button.buttons);
		}

		/* [/Circuitry] */

		/* [Traps] */

		Trap.traps = new FlxTypedGroup <Trap>();

		if(map.objectMap.exists("bearTraps")) {
			for(obj in map.objectMap.get("bearTraps").members)
				Trap.traps.add(new BearTrap(obj));
			map.objectMap.remove("bearTraps");
		}

		if(map.objectMap.exists("fireTraps")) {
			for(obj in map.objectMap.get("fireTraps").members)
				Trap.traps.add(new FireTrap(obj));
			map.objectMap.remove("fireTraps");
		}

		if(map.objectMap.exists("spikeTraps")) {
			for(obj in map.objectMap.get("spikeTraps").members)
				Trap.traps.add(new SpikeTrap(obj));
			map.objectMap.remove("spikeTraps");
		}

		add(Trap.traps);
		/* [/Traps] */

		/* [Platforms] */

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

		BreakablePlatform.platforms = new FlxTypedGroup <BreakablePlatform>();
		if(map.objectMap.exists("breakables")) {
			for(obj in map.objectMap.get("breakables").members)
				BreakablePlatform.platforms.add(new BreakablePlatform(obj));
			map.objectMap.remove("breakables");
		}
		add(BreakablePlatform.platforms);

		/* [/Platforms] */

		/* Doors */
		if(map.objectMap.exists("doors")) {
			for(obj in map.objectMap.get("doors").members)
				map.collidableTiles.add(new Door(obj));
			map.objectMap.remove("doors");
		}

		/* Torchs */
		if(map.objectMap.exists("torchs")) {
			for(obj in map.objectMap.get("torchs").members)
				add(new Torch(obj));
			map.objectMap.remove("torchs");
		}

		add(interactibles);

		/* Text */
		if(map.objectMap.exists("text")) {
			for(obj in map.objectMap.get("text").members)
				add(new Text(obj));
			map.objectMap.remove("text");
		}

		add(enemies);

		/* Rogue wallgrip stuff */
		Rogue.wallGrip = map.objectMap.get("wallGrip");
		if(Rogue.wallGrip == null) throw "You must create Object Layer \"wallGrip\".";
		map.objectMap.remove("wallGrip");
		
		/* Floor identifier for jumping stuff. Is it maybe unnecessary? */
		Reg.floor = map.objectMap.get("floor");
		if(Reg.floor == null) throw "You must create Object Layer \"floor\".";
		map.objectMap.remove("floor");

		/* Loading Pause Menu */
		pauseMenu = new FlxGroup();
		var menuObj : flixel.FlxObject = new FlxSprite(0, 0).makeGraphic(1200, 600, 0x77000000);
		menuObj.scrollFactor.set(0, 0);
		pauseMenu.add(menuObj);
		menuObj = new FlxText(100, 100, 100, "PAUSED", 20);
		menuObj.scrollFactor.set(0, 0);
		pauseMenu.add(menuObj);
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