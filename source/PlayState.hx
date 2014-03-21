package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;
import flixel.util.FlxPoint;
import flixel.util.FlxSave;

class PlayState extends FlxState
{
	//tilemap properties
	private static inline var tilesAcross:Int = 20;
	private static inline var tilesUp:Int = 20;
	private static inline var tileSize:Int = 32;
	private static inline var tileMapOffsetX:Float = 100;
	private static inline var tileMapOffsetY:Float = 10;
	
	//tilemap vars
	private var tileHandler:TileHandler;
	
	override public function create():Void
	{
		var mapOutline:FlxSprite = new FlxSprite(50, 20);
		mapOutline.makeGraphic(10 * 32, 10 * 32, FlxColor.BLUE);
		add(mapOutline);
		tileHandler = new TileHandler(10, 10, 32, new FlxPoint(50, 20));
		add(tileHandler.flxGroup);
	}
	
	override public function update():Void
	{
		
		// If you've clicked, lets see if you clicked on a button
		// Note something like this needs to be after super.update() that way the button's state has updated to reflect the mouse event
		if (FlxG.mouse.justPressed) 
		{
			tileHandler.putTileAtCoords(new FlxPoint(FlxG.mouse.x, FlxG.mouse.y));
		}
		
		tileHandler.update();
	}
}