import flixel.FlxG;
import flixel.FlxSprite;
import flixel.effects.particles.FlxEmitter;
import flixel.util.FlxColor;

class Enemy extends FlxSprite
{
	public function new()
	{
		super();
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
	}

	override function kill()
	{
		FlxG.sound.play(AssetPaths.explosion_1__ogg, 0.5);

		var explosion:FlxEmitter = new FlxEmitter(x + width / 2, y + height / 2);
		explosion.makeParticles(1, 1, FlxColor.WHITE, 100);
		explosion.angularVelocity.set(1, 5, 6, 10);
		explosion.scale.set(0.5, 0.5, 0.5, 0.5, 2, 2, 3, 3);
		explosion.lifespan.set(0.1, 0.5);
		explosion.color.set(FlxColor.RED, FlxColor.ORANGE);
		Reg.PS.add(explosion);
		explosion.start();
		super.kill();
	}
}
