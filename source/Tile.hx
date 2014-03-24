package ;

/**
 * ...
 * @author BluShine
 */
class Tile
{
	//basic construction in the tile (steel, bricks, concrete, etc.)
	public var baseConstruction:String;
	//list of all the constructions on this tile (facade, drywall, windows, floors, carpet, etc.)
	public var constructionTypes:List<String>;
	
	private var weight:Float;

	public var supported:Bool;
	
	private var compressiveStrength:Float;
	private var shearStrength:Float;
	
	//one force per tile, track the forces
	private var forcesFromTiles:Map<Tile, Float>;

	public var graphic:TileSprite;
	
	public function new(tileType:String, tileWeight:Float, cmpStrength:Float, shrStrength:Float, x:Float, y:Float, width:Int) 
	{
		baseConstruction = tileType;
		constructionTypes = new List<String>();
		weight = tileWeight;
		compressiveStrength = cmpStrength;
		shearStrength = shrStrength;
		supported = false;
		
		graphic = new TileSprite(x, y, width);
	}
	
	public function update()
	{
		graphic.updateText(Std.string(totalWeight), 0x00FF00);
		graphic.update();
	}
	
	public function destroy()
	{
		graphic.destroy();
	}
}