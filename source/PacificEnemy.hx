class PacificEnemy extends Enemy
{
	public static inline var ENEMY_SPEED:Int = 20;

	public function new()
	{
		super();
		// makeGraphic(8, 8, FlxColor.RED);
		loadGraphic(AssetPaths.enemy_Sheet__png, true, 11, 11);

		animation.add('idle', [0, 1, 2, 3], 20);
		animation.play('idle');

		velocity.y = ENEMY_SPEED;
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
	}
}
