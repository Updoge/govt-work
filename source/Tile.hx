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
	public var totalWeight:Float;
	
	private var compressiveStrength:Float;
	private var compressiveStress:Float;
	
	private var shearStrength:Float; 
	private var imbalanceTolerance:Float;
	private var shearStressLeft:Float;
	private var shearStressRight:Float;
	
	public var graphic:TileSprite;
	
	public function new(tileType:String, tileWeight:Float, cmpStrength:Float, shrStrength:Float, x:Float, y:Float, width:Int) 
	{
		baseConstruction = tileType;
		constructionTypes = new List<String>();
		weight = tileWeight;
		totalWeight = tileWeight;
		compressiveStrength = cmpStrength;
		shearStrength = shrStrength;
		compressiveStress = 0;
		shearStressLeft = 0;
		shearStressRight = 0;
		imbalanceTolerance = 1;
		
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
	
	public function applyCompressiveForce(force:Float)
	{
		compressiveStress += force;
		totalWeight += force;
	}
	
	public function applyShearForceLeft(force:Float)
	{
		shearStressLeft += force;
		totalWeight += force;
	}
	
	public function applyShearForceRight(force:Float)
	{
		shearStressRight += force;
		totalWeight += force;
	}
	
	public function isStructurallySound():Bool 
	{
		if (compressiveStress > compressiveStrength)
			return false;
		if (shearStressLeft > shearStrength)
			return false;
		if (shearStressRight > shearStrength)
			return false;
		return true;
	}
	
	public function resetForces()
	{
		totalWeight = weight;
		compressiveStress = 0;
		shearStressLeft = 0;
		shearStressRight = 0;
	}
	
}