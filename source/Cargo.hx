import flixel.FlxG;
import flixel.FlxSprite;
import flixel.effects.particles.FlxEmitter;
import flixel.util.FlxColor;
import flixel.util.FlxSpriteUtil;

class Cargo extends FlxSprite
{
	var smoke:FlxEmitter;

	public function new()
	{
		super();
		loadGraphic(AssetPaths.cargo__png, false, 16, 16);
		health = 100;
	}

	override function update(elapsed:Float)
	{
		if (x < 0 || x > FlxG.width - width)
			velocity.x *= -1;
		if (y < 0 || y > FlxG.height - height)
			velocity.y *= -1;

		if (x < 0)
		{
			x = 0;
		}
		else if (x > FlxG.width - width)
		{
			x = FlxG.width - width;
		}

		if (y < 0)
		{
			y = 0;
		}
		else if (y > FlxG.height - height)
		{
			y = FlxG.height - height;
		}

		if (smoke != null)
		{
			smoke.setPosition(x + width / 2, y + height / 2);
		}

		if (health < 40)
		{
			spawnSmoke();
		}

		// FlxSpriteUtil.screenWrap(this);

		super.update(elapsed);
	}

	override function hurt(Damage:Float)
	{
		FlxG.sound.play(AssetPaths.hurt_2__ogg, 0.5);
		super.hurt(Damage);
		if (health < 0)
			health = 0;
	}

	override function kill()
	{
		smoke.kill();

		FlxG.sound.play(AssetPaths.bigexplosion__ogg, 0.5);

		var explosion:FlxEmitter = new FlxEmitter(x + width / 2, y + height / 2);
		explosion.makeParticles(1, 1, FlxColor.WHITE, 100);
		explosion.angularVelocity.set(1, 5, 6, 10);
		explosion.scale.set(1, 1, 1, 1, 3, 3, 5, 5);
		explosion.lifespan.set(0.1, 1);
		explosion.color.set(FlxColor.RED, FlxColor.ORANGE);
		Reg.PS.add(explosion);
		explosion.start();

		FlxG.camera.shake(0.06, 0.1);
		FlxG.camera.flash(FlxColor.WHITE, 0.1);

		super.kill();
	}

	function spawnSmoke()
	{
		if (smoke == null)
		{
			smoke = new FlxEmitter(x + width / 2, y + height / 2);
			smoke.makeParticles();
			smoke.launchAngle.set(-45, -135);
			smoke.scale.set(0.5, 0.5, 0.5, 0.5, 1, 1, 2, 2);
			smoke.lifespan.set(0.1, 0.3);
			smoke.start(false);
			Reg.PS.add(smoke);
		}
	}
}
