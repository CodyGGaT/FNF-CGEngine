package;

import flixel.math.FlxPoint;
import flixel.FlxSprite;
import flixel.math.FlxMath;

using StringTools;

class HealthIcon extends FlxSprite
{
	public var sprTracker:FlxSprite;
	private var isOldIcon:Bool = false;
	public var isPlayer:Bool = false;
	public var offsets:FlxPoint = new FlxPoint();
	private var char:String = '';

	public function new(char:String = 'bf', isPlayer:Bool = false, ?hasVictory:Bool = false)
	{
		super();
		isOldIcon = (char == 'bf-old');
		this.isPlayer = isPlayer;
		changeIcon(char, hasVictory);
		scrollFactor.set();
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (sprTracker != null)
			setPosition(sprTracker.x + sprTracker.width + 12, sprTracker.y - 30);
	}

	public function swapOldIcon() {
		if(isOldIcon = !isOldIcon) changeIcon('bf-old');
		else changeIcon('bf');
	}

	private var iconOffsets:Array<Float> = [0, 0];
	public function changeIcon(char:String, ?hasVictory:Bool = false) {
		if(this.char != char) {
			var name:String = 'icons/' + char;
			if(!Paths.fileExists('images/' + name + '.png', IMAGE)) name = 'icons/icon-' + char; //Older versions of psych engine's support
			if(!Paths.fileExists('images/' + name + '.png', IMAGE)) name = 'icons/icon-face'; //Prevents crash from missing icon
			var file:Dynamic = Paths.image(name);

			loadGraphic(file); //Load stupidly first for getting the file size
			loadGraphic(file, true, Math.floor(hasVictory ? width / 3 : width / 2), Math.floor(height)); //Then load it fr

			iconOffsets[0] = (width - 150) / 2;
			iconOffsets[1] = (width - 150) / 2;

			updateHitbox();

			animation.add(char, (hasVictory ? [0, 1, 2] : [0, 1]), 0, false, isPlayer);
			animation.play(char);
			this.char = char;

			antialiasing = ClientPrefs.globalAntialiasing;
			if(char.endsWith('-pixel')) {
				antialiasing = false;
			}
		}
	}

	override function updateHitbox()
	{
		super.updateHitbox();
		offset.x = iconOffsets[0] + offsets.x;
		offset.y = iconOffsets[1] + offsets.y;
	}



	public function getCharacter():String {
		return char;
	}
}