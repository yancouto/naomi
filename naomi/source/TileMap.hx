package;

import flixel.addons.editors.tiled.*;
import flixel.group.FlxTypedGroup;
import flixel.FlxObject;
import flixel.FlxState;
import flixel.FlxSprite;
import flixel.tile.FlxTilemap;
import flixel.FlxG;
import base.Object;

typedef ObjectGroup = FlxTypedGroup<FlxObject>;
typedef PObjectGroup = FlxTypedGroup<Object>;

/*
*	My own TileMap with cool stuff.
*	TODO: Separate tiles that are supposed to be drawn after the player (with some special property probably)
*/
class TileMap {
	public var nonCollidableTiles : ObjectGroup;
	public var collidableTiles : ObjectGroup;
	public var glassTiles : ObjectGroup;
	public var objectMap : Map<String, PObjectGroup>;
	public var width : Int;
	public var height : Int;

	public function new(data : Dynamic) {
		var tiledMap = new TiledMap(data);
		nonCollidableTiles = new ObjectGroup();
		collidableTiles = new ObjectGroup();
		glassTiles = new ObjectGroup();

		FlxG.worldBounds.set(0, 0, tiledMap.width * tiledMap.tileWidth, tiledMap.height * tiledMap.tileHeight);
		width = tiledMap.width;
		height = tiledMap.height;

		/* Loading Tile Layers */
		for(layer in tiledMap.layers) {
			var tileSetName : String = layer.properties.get("tileset");
			if(tileSetName == null)
				throw "All Tile Layers need a property \"tileset\" with its tileset name";
			var tileSet : TiledTileSet = tiledMap.getTileSet(tileSetName);
			if(tileSet == null)
				throw "TileSet name probably wrong";

			var map = new FlxTilemap();
			map.widthInTiles = width;
			map.heightInTiles = height;
			map.loadMap(layer.tileArray, "assets/tilesets/" + tileSetName + ".png", tileSet.tileWidth, tileSet.tileHeight, FlxTilemap.OFF, tileSet.firstGID, 1, 1);

			if(layer.properties.contains("parallax")) {
				var v : Float = Std.parseFloat(layer.properties.get("parallax"));
				map.scrollFactor.set(v, v);
			}

			if(StringTools.startsWith(layer.name, "glass")) /* Glass tiles. Enemies collide but not the soul shot */
				glassTiles.add(map);
			else if(layer.properties.contains("nocollides")) /* Purely visual tiles */
				nonCollidableTiles.add(map);
			else
				collidableTiles.add(map);
		}

		/* Loading Object Layers */
		objectMap = new Map <String, PObjectGroup>();
		for(group in tiledMap.objectGroups) {
			var g = new PObjectGroup();
			objectMap.set(group.name, g);
			for(obj in group.objects) 
				g.add(new Object(obj.x, obj.y, obj.width, obj.height, obj.custom.keys));
		}
	}
}