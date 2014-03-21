package ;
import flixel.group.FlxGroup;
import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.util.FlxColor;

/**
 * ...
 * @author BluShine
 */
class TileSprite extends FlxGroup
{
	public var tile:FlxSprite;
	public var text:FlxText;
	public var width:Int;
	public var x:Float;
	public var y:Float;
	
	public function new(xPos:Float, yPos:Float, size:Int) 
	{
		x = xPos;
		y = yPos;
		width = size;
		super();
		
		tile = new FlxSprite(x, y);
		tile.makeGraphic(width, width, FlxColor.GRAY);
		add(tile);
		
		text = new FlxText(x, y, width, "0");
		add(text);
	}
	
	public function updateText(str:String, color:Int) {
		text.text = str;
		text.color = color;
	}
	
}