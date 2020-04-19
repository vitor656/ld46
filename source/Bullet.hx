import flixel.FlxSprite;
import flixel.util.FlxColor;

class Bullet extends FlxSprite
{
	public static inline var BULLET_SPEED:Int = 200;

	public function new()
	{
		super();
		makeGraphic(1, 2, FlxColor.WHITE);
		velocity.y = -BULLET_SPEED;
	}

	override function update(elapsed:Float)
	{
		if (velocity.y != -BULLET_SPEED)
			velocity.y = -BULLET_SPEED;

		if (!isOnScreen())
		{
			kill();
		}

		super.update(elapsed);
	}

	override function kill()
	{
		super.kill();
	}
}
