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
		//we only call this a few times, i think we can trust that the input is > 0

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
	
	//needs more semantic name
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

	//REGION: STRUCTURAL INTEGRITY FUNCTIONS
	private function getAdjacentBlocks(loc:FlxPoint)
	{
		var toReturn:List<Tile> = new List<Tile>();
		for (i in (loc.x - 1)...(loc.x + 1))
		{
			for (j in (loc.y - 1)...(loc.y + 1))
			{
				if (i == loc.x && j = loc.y)
					continue;
				var toAdd:Tile = tileArray[i][j];
				if (toAdd != null)
					toReturn.add(toAdd);
			}
		}
		return toReturn;
	}
	private function getBelowBlocks(loc:FlxPoint)
	{
		return getBelowBlocks(loc.x, loc.y);
	}
	private function getBelowBlocks(x:Int, y:Int)
	{
		var sourceTile:Tile = tileArray[x][y];
		if (sourceTile == null)
			throw "Cannot get exertable blocks for null tile at (" + x + "," + y +")";
		return getBelowBlocks(sourceTile, x, y);
	}
	private function getBelowBlocks(Tile tile, x:Int, y:Int)
	{
		var toReturn:List<Tile> = new List<Tile>();

		list = addIfNotNull(list, tileArray[x - 1][y + 1]);
		list = addIfNotNull(list, tileArray[x][y + 1]);
		list = addIfNotNull(list, tileArray[x + 1][y + 1]);
	}

	private function getBesideBlocks(loc:FlxPoint)
	{
		return getBesideBlocks(loc.x, loc.y);
	}
	private function getBesideBlocks(x:Int, y:Int)
	{
		var sourceTile:Tile = tileArray[x][y];
		if (sourceTile == null)
			throw "Cannot get exertable blocks for null tile at (" + x + "," + y +")";
		return getBesideBlocks(sourceTile, x, y);
	}
	private function getBesideBlocks(Tile tile, x:Int, y:Int)
	{
		var toReturn:List<Tile> = new List<Tile>();

		list = addIfNotNull(list, tileArray[x - 1][y]);
		list = addIfNotNull(list, tileArray[x + 1][y]);
		return toReturn;
	}

	private function getDistanceToNearestSupportedBlock(direction:String, x:Int, y:Int)
	{
		if (tileArray[x][y].supported)
			return 0;
		if (direction.equals("left"))
		{
			var left:Tile = tileArray[x - 1][y];
			if (left == null)
			{
				return 1024;
			}
			else
			{
				return 1 + getDistanceToNearestSupportedBlock("left", x - 1, y);
			}
		}
		if (direction.equals("right"))
		{
			var right:Tile = tileArray[x + 1][y];
			if (right == null)
			{
				return 1024;
			}
			else
			{
				return 1 + getDistanceToNearestSupportedBlock("right", x + 1, y);
			}
		}
		throw "Unrecognized search direction " + direction;
	}

	private function getBlocksToApplyForceTo(Tile tile, x:Int, y:Int)
	{
		var toApplyForceTo:List<Tile> = getBelowBlocks(tile, x, y);
		if (!tile.supported)
		{
			var besides:List<Tile> = getBesideBlocks(tile, x, y);
			var leftDist:Int = getDistanceToNearestSupportedBlock("left", x, y);
			var rightDist:Int = getDistanceToNearestSupportedBlock("right", x, y);

			if ((leftDist > 1000 && rightDist > 1000) || leftDist == rightDist)
			{
				toApplyForceTo.addAll(besides);
				return toApplyForceTo;
			}
			if (leftDist < rightDist)
			{
				toApplyForceTo.add(besides[0]);
			}
			else
			{
				toApplyForceTo.add(besides[1]);
			}
		}
	}

	private function addIfNotNull(List<Tile> list, Tile tile){
		if (tile != null)
		{
			list.add(tile);
		}
		return list;
	}

	private function updateIsSupported(){
		//bottom layer is always supported
		for (i in 0...tilesWide)
		{
			var tile:Tile = tileArray[i][0];
			if (tile != null)
				tile.supported = true;
		}
		//updates from bottom up
		for (j in (tilesHigh - 1)...0)
		{
			for (i in 0...tilesWide)
			{
				var tile:Tile = tileArray[i][j];
				if (tile != null){
					var tileBelow = tileArray[i][j + 1];
					tile.supported = isSupported(i,j);
				}
			}
		}
	}

	private bool isSupported(x:Int, y:Int){
		var belowTile:Tile = tileArray[x][y + 1];
		return belowTile != null && belowTile.supported;
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
	
	//steve: i think it should return true if it succeeds instead.
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
	
	//steve: probably should just do nothing and return false if there's a tile there.
	//separate method for destroying maybe
	//returns false if tile was destroyed.
	private function placeTile(x, y):Bool
	{
		if (tileArray[x][y] != null)
		{
			tileArray[x][y].destroy();
			tileArray[x][y] = null;
			return false;
		}
		var toAdd:Tile = new Tile("stone", 1, 10, 3, 
						x * tileSize + mapOffset.x, y * tileSize + mapOffset.y, tileSize);
		tileArray[x][y] = toAdd;

		flxGroup.add(toAdd.graphic);
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