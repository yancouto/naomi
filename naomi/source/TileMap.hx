package;

import flixel.addons.editors.tiled.*;
import flixel.group.FlxTypedGroup;
import flixel.FlxObject;
import flixel.FlxState;
import flixel.FlxSprite;
import flixel.tile.FlxTilemap;
import flixel.FlxG;

typedef ObjectGroup = FlxTypedGroup<FlxObject>;

/*
*	My own TileMap with cool stuff.
*	TODO: Separate tiles that are supposed to be drawn after the player (with some special property probably)
*/
class TileMap {
	public var nonCollidableTiles : ObjectGroup;
	public var collidableTiles : ObjectGroup;
	public var glassTiles : ObjectGroup;
	public var objectMap : Map<String, ObjectGroup>;

	public function new(data : Dynamic) {
		var tiledMap = new TiledMap(data);
		nonCollidableTiles = new ObjectGroup();
		collidableTiles = new ObjectGroup();
		glassTiles = new ObjectGroup();
		FlxG.worldBounds.set(0, 0, tiledMap.width * tiledMap.tileWidth, tiledMap.height * tiledMap.tileHeight);
		for(layer in tiledMap.layers) {
			var tileSetName : String = layer.properties.get("tileset");
			var tileSet : TiledTileSet = tiledMap.getTileSet(tileSetName);
			var map = new FlxTilemap();
			map.widthInTiles = tiledMap.width;
			map.heightInTiles = tiledMap.height;
			map.loadMap(layer.tileArray, "assets/tilesets/" + tileSetName + ".png", tileSet.tileWidth, tileSet.tileHeight, FlxTilemap.OFF, tileSet.firstGID, 1, 1);
			if(layer.properties.contains("parallax")) {
				var v : Float = Std.parseFloat(layer.properties.get("parallax"));
				map.scrollFactor.set(v, v);
			}
			if(StringTools.startsWith(layer.name, "glass"))
				glassTiles.add(map);
			else if(layer.properties.contains("nocollides"))
				nonCollidableTiles.add(map);
			else
				collidableTiles.add(map);
		}
		objectMap = new Map <String, ObjectGroup>();
		for(group in tiledMap.objectGroups) {
			var g = new ObjectGroup();
			objectMap.set(group.name, g);
			for(obj in group.objects) 
				g.add(new FlxObject(obj.x, obj.y, obj.width, obj.height));
		}
	}
}