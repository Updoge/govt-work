package ;
import flixel.group.FlxTypedGroup.FlxTypedGroup;
import flixel.util.FlxPoint;

/**
 * ...
 * @author BluShine
 */
class TileHandler
{
	public var flxGroup:FlxTypedGroup<TileSprite>;
	private var tileArray:Array<Array<Tile>>;
	
	//these can be read publicly, but only set within this class
	public var tilesWide(default, null):Int;
	public var tilesHigh(default, null):Int;
	public var tileSize(default, null):Int;
	
	public var mapOffset:FlxPoint;
	
	public function new(tilesAcross:Int, tilesUp:Int, tileWidth:Int, offset:FlxPoint) 
	{
		//TODO: make sure these are > 0
		tilesWide = tilesAcross;
		tilesHigh = tilesUp;
		tileSize = tileWidth;
		
		mapOffset = offset;
		flxGroup = new FlxTypedGroup<TileSprite>();
		
		//initialize the array with null values
		tileArray = new Array<Array<Tile>>();
		var i:Int = 0;
		var j:Int = 0;
		while (i < tilesWide)
		{
			tileArray[i] = new Array<Tile>();
			while (j < tilesHigh)
			{
				tileArray[i][j] = null;
				j++;
			}
			i++;
		}
	}
	
	public function update() {
		for (i in 0...tilesWide)
		{
			for (j in 0...tilesHigh)
			{
				var t:Tile = tileArray[i][j];
				if( t != null)
					t.update();
			}
		}
	}
	
	private function updateStructures()
	{
		for (i in 0...tilesWide)
		{
			for (j in 0...tilesHigh)
			{
				var t:Tile = tileArray[i][j];
				if (t != null)
					t.resetForces();
			}
		}
		for (i in 0...tilesWide)
		{
			for (j in 0...tilesHigh)
			{
				var t:Tile = tileArray[i][j];
				var tUnder:Tile = tileArray[i][j + 1];
				if (t != null)
					if (tUnder != null)
						tUnder.applyCompressiveForce(t.totalWeight);
			}
		}
	}
	
	//true if there was a tile there.
	public function putTileAtCoords(coords:FlxPoint):Bool
	{
		var tileCoordX:Int = Math.floor((coords.x - mapOffset.x) / tileSize);
		var tileCoordY:Int = Math.floor((coords.y - mapOffset.y) / tileSize);
		
		if (tileCoordX >= 0 && tileCoordX < tilesWide && 
			tileCoordY >= 0 && tileCoordY < tilesHigh)
		{
			placeTile(tileCoordX, tileCoordY);
		}
		updateStructures();
		return false;
	}
	
	//returns false if tile was destroyed.
	private function placeTile(x, y):Bool
	{
		if (tileArray[x][y] != null)
		{
			tileArray[x][y].destroy();
			tileArray[x][y] = null;
			return false;
		}
		tileArray[x][y] = new Tile("stone", 1, 10, 3, 
						x * tileSize + mapOffset.x, y * tileSize + mapOffset.y, tileSize);
		flxGroup.add(tileArray[x][y].graphic);
		return true;
	}
	
	private function set_tileSize(v:Int):Int
	{
		tileSize = v;
		//TODO:
		//move all the tiles to adjust for new size
		return v;
	}
}