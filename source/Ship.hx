import flixel.FlxG;
import flixel.FlxSprite;
import flixel.effects.particles.FlxEmitter;
import flixel.math.FlxVelocity;
import flixel.util.FlxColor;
import flixel.util.FlxSpriteUtil;

class Ship extends FlxSprite
{
	public static inline var MOVE_SPEED:Int = 60;
	public static inline var ACC:Int = 80;

	public function new()
	{
		super();
		// makeGraphic(8, 8, FlxColor.CYAN);
		loadGraphic(AssetPaths.ship_Sheet__png, true, 11, 11);

		animation.add('idle', [0, 1], 12);
		animation.play('idle');

		maxVelocity.set(MOVE_SPEED, MOVE_SPEED);

		health = 10;
	}

	override function update(elapsed:Float)
	{
		movement();
		shooting();

		super.update(elapsed);
	}

	override function kill()
	{
		FlxG.sound.play(AssetPaths.bigexplosion__ogg, 0.5);

		var explosion:FlxEmitter = new FlxEmitter(x + width / 2, y + height / 2);
		explosion.makeParticles(1, 1, FlxColor.WHITE, 100);
		explosion.angularVelocity.set(1, 5, 6, 10);
		explosion.scale.set(0.5, 0.5, 0.5, 0.5, 2, 2, 3, 3);
		explosion.lifespan.set(0.1, 1);
		explosion.color.set(FlxColor.RED, FlxColor.ORANGE);
		Reg.PS.add(explosion);
		explosion.start();

		FlxG.camera.shake(0.06, 0.1);

		super.kill();
	}

	override function hurt(Damage:Float)
	{
		FlxG.sound.play(AssetPaths.hurt_1__ogg, 0.5);
		super.hurt(Damage);
	}

	function movement()
	{
		var left:Bool = FlxG.keys.pressed.A || FlxG.keys.pressed.LEFT;
		var right:Bool = FlxG.keys.pressed.D || FlxG.keys.pressed.RIGHT;
		var up:Bool = FlxG.keys.pressed.W || FlxG.keys.pressed.UP;
		var down:Bool = FlxG.keys.pressed.S || FlxG.keys.pressed.DOWN;

		if (left)
		{
			// velocity.x = -MOVE_SPEED;
			acceleration.x = -ACC;
		}
		else if (right)
		{
			// velocity.x = MOVE_SPEED;
			acceleration.x = ACC;
		}
		else
		{
			// velocity.x = 0;
			acceleration.x = 0;
		}

		if (up)
		{
			// velocity.y = -MOVE_SPEED;
			acceleration.y = -ACC;
		}
		else if (down)
		{
			// velocity.y = MOVE_SPEED;
			acceleration.y = ACC;
		}
		else
		{
			// velocity.y = 0;
			acceleration.y = 0;
		}

		wrap();
	}

	function shooting()
	{
		if (FlxG.keys.justPressed.SPACE || FlxG.keys.justPressed.Z)
		{
			FlxG.sound.play(AssetPaths.shoot_1__ogg, 0.5);
			var bullet:Bullet = Reg.PS.bulletsGroup.recycle(Bullet, null);
			bullet.setPosition(x + 5, y - 2);
		}
	}

	function wrap()
	{
		if (x > FlxG.width)
			x = -width;

		if (x < -width)
			x = FlxG.width;

		if (y > FlxG.height)
			y = -height;

		if (y < -height)
			y = FlxG.height;
	}
}
