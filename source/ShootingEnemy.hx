import flixel.FlxG;
import flixel.FlxSprite;
import flixel.math.FlxMath;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;

class ShootingEnemy extends Enemy
{
	var timeCounterToShoot:Float = 0;
	var timeToShoot:Float = 2;

	var movingFactor:Float = 0;

	public function new()
	{
		super();

		loadGraphic(AssetPaths.shootingenemy_Sheet__png, true, 11, 11);
		animation.add('idle', [0, 1], 12);
		animation.play('idle');
		velocity.y = 5;
	}

	override function update(elapsed:Float)
	{
		timeCounterToShoot += elapsed;
		if (timeCounterToShoot >= timeToShoot)
		{
			FlxG.sound.play(AssetPaths.shoot_1__ogg, 0.5);

			var enemyShoot:FlxSprite = Reg.PS.enemyBulletsGroup.recycle(FlxSprite, null);
			enemyShoot.makeGraphic(2, 2, FlxColor.RED);
			enemyShoot.setPosition(x + (width / 2), y + 13);
			enemyShoot.velocity.y = 40;

			timeCounterToShoot = 0;
		}

		movingFactor += elapsed;

		x += FlxMath.fastCos(movingFactor) * 0.2;

		Reg.PS.enemyBulletsGroup.forEachAlive(function(b:FlxSprite)
		{
			if (!b.isOnScreen())
			{
				b.kill();
			}
		});

		super.update(elapsed);
	}
}
