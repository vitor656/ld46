package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.addons.display.FlxStarField.FlxStarField2D;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.util.FlxColor;

class PlayState extends FlxState
{
	public var ship:Ship;

	public var cargo:Cargo;

	private var _hud:Hud;

	private var _enemiesSpawnTimeCounter:Float;
	private var _enemiesSpawnTime:Float;

	private var _gameTime:Float;
	private var _level:Int;
	private var _changedLevel:Bool;

	public var bulletsGroup:FlxTypedGroup<Bullet>;
	public var enemiesGroup:FlxTypedGroup<Enemy>;
	public var enemyBulletsGroup:FlxTypedGroup<FlxSprite>;

	public var starfield:FlxStarField2D;

	public var isGameover:Bool;
	public var isWin:Bool;

	override public function create()
	{
		super.create();

		FlxG.sound.cacheAll();
		FlxG.sound.playMusic(AssetPaths.BeepBox_Song__ogg);

		Reg.PS = this;
		Reg.score = 0;

		FlxG.camera.bgColor = FlxColor.fromString("0x1b2632");

		isGameover = false;

		_changedLevel = false;
		_level = 0;
		_gameTime = 0;
		_enemiesSpawnTime = 2;
		_enemiesSpawnTimeCounter = 0;

		ship = new Ship();
		ship.screenCenter();
		ship.x -= ship.width / 2;
		ship.y -= ship.height / 2;
		ship.y += 50;
		ship.x += 5;

		cargo = new Cargo();
		cargo.screenCenter();
		cargo.y += 20;

		bulletsGroup = new FlxTypedGroup<Bullet>(10);
		enemiesGroup = new FlxTypedGroup<Enemy>(100);
		enemyBulletsGroup = new FlxTypedGroup<FlxSprite>(100);

		starfield = new FlxStarField2D(0, 0, FlxG.width, FlxG.height, 20);
		starfield.starVelocityOffset.set(0, 5);
		starfield.setStarSpeed(5, 10);

		_hud = new Hud();

		add(starfield);
		add(ship);
		add(cargo);
		add(bulletsGroup);
		add(enemiesGroup);
		add(enemyBulletsGroup);
		add(_hud);
	}

	override public function update(elapsed:Float)
	{
		if (!isGameover && !isWin)
		{
			_gameTime += elapsed;

			if (_gameTime > 25)
			{
				_gameTime = 0;

				if (_level < 4)
					_level++;

				switch _level
				{
					case 0:
						_enemiesSpawnTime = 2.5;
					case 1:
						_enemiesSpawnTime = 2;
					case 2:
						_enemiesSpawnTime = 1.5;
					case 3:
						_enemiesSpawnTime = 1;
					case 4:
						_enemiesSpawnTime = 0.5;
				}
			}

			collisions();
			spawnEnemies(elapsed);

			if (ship.health <= 0 || cargo.health <= 0)
			{
				lose();
			}
		}
		else
		{
			if (FlxG.keys.justPressed.R)
			{
				FlxG.resetState();
			}
		}

		super.update(elapsed);
	}

	function spawnEnemies(elapsed:Float)
	{
		_enemiesSpawnTimeCounter += elapsed;

		if (_enemiesSpawnTimeCounter > _enemiesSpawnTime)
		{
			var randEnemy:Int = FlxG.random.int(0, 100);
			if (randEnemy > 0 && randEnemy < 70)
			{
				var enemy:Enemy = enemiesGroup.recycle(PacificEnemy, null);
				enemy.setPosition(FlxG.random.int(0, FlxG.width - Std.int(enemy.width)), -enemy.y);
			}
			else if (randEnemy >= 70 && randEnemy <= 100)
			{
				var enemy:Enemy = enemiesGroup.recycle(ShootingEnemy, null);
				enemy.setPosition(FlxG.random.int(0, FlxG.width - Std.int(enemy.width)), -enemy.y);
			}

			_enemiesSpawnTimeCounter = 0;
		}
	}

	function collisions()
	{
		FlxG.collide(ship, cargo, function(s:Ship, c:Cargo) {});

		FlxG.collide(bulletsGroup, cargo, function(b:Bullet, c:Cargo)
		{
			b.kill();
		});

		FlxG.collide(bulletsGroup, enemiesGroup, function(b:Bullet, e:Enemy)
		{
			b.kill();
			e.kill();

			Reg.score += 10;

			FlxG.camera.shake(0.04, 0.05);
		});

		FlxG.collide(cargo, enemiesGroup, function(c:Cargo, e:Enemy)
		{
			FlxG.camera.shake(0.04, 0.05);

			c.hurt(20);
			e.kill();
		});

		FlxG.collide(ship, enemiesGroup, function(s:Ship, e:Enemy)
		{
			FlxG.camera.shake(0.04, 0.05);

			s.hurt(2);
			e.kill();
		});

		FlxG.collide(enemyBulletsGroup, ship, function(e:FlxSprite, s:Ship)
		{
			FlxG.camera.shake(0.04, 0.05);

			s.hurt(1);
			e.kill();
		});

		FlxG.collide(enemyBulletsGroup, cargo, function(e:FlxSprite, c:Cargo)
		{
			FlxG.camera.shake(0.04, 0.05);

			c.hurt(10);
			e.kill();
		});
	}

	public function win()
	{
		isWin = true;

		enemiesGroup.forEachAlive(function(e:Enemy)
		{
			e.kill();
		});

		enemyBulletsGroup.forEachAlive(function(b:FlxSprite)
		{
			b.kill();
		});
	}

	public function lose()
	{
		isGameover = true;
	}
}
