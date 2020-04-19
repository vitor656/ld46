import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxBitmapText;
import flixel.ui.FlxBar;
import flixel.util.FlxColor;

class Hud extends FlxTypedGroup<FlxSprite>
{
	var wayToGoBar:FlxSprite;
	var wayToGoCursor:FlxSprite;

	var shipLife:FlxBar;
	var cargoLife:FlxBar;

	var cargoText:FlxBitmapText;
	var cargoResistance:FlxBitmapText;

	var gameOverText:FlxBitmapText;
	var winText:FlxBitmapText;

	var scoreText:FlxBitmapText;
	var restartText:FlxBitmapText;

	var _timeCounterToCursorMove:Float;
	var _timeToCursorMove:Float;

	public function new()
	{
		super();

		_timeCounterToCursorMove = 0;
		_timeToCursorMove = 3;

		wayToGoBar = new FlxSprite();
		wayToGoBar.loadGraphic(AssetPaths.waytogo__png, false, 42, 2);

		wayToGoCursor = new FlxSprite();
		wayToGoCursor.makeGraphic(1, 2, FlxColor.RED);

		wayToGoBar.setPosition(11, 3);

		wayToGoCursor.setPosition(wayToGoBar.x + 2, wayToGoBar.y);

		shipLife = new FlxBar(3, 3, FlxBarFillDirection.BOTTOM_TO_TOP, 4, 10, Reg.PS.ship, "health", 0, 10, true);
		shipLife.createColoredFilledBar(FlxColor.RED, true);

		cargoText = new FlxBitmapText();
		cargoText.text = "Cargo";
		cargoText.setPosition(wayToGoBar.width + 4, wayToGoBar.y - 3);
		cargoText.scale.set(0.3, 0.3);

		cargoResistance = new FlxBitmapText();
		cargoResistance.text = Reg.PS.cargo.health + "%";
		cargoResistance.setPosition(cargoText.x + 2, cargoText.y + 4);
		cargoResistance.scale.set(0.4, 0.4);
		cargoResistance.alignment = RIGHT;

		gameOverText = new FlxBitmapText();
		gameOverText.text = "Game Over";
		gameOverText.screenCenter();
		gameOverText.scale.set(1.3, 1.3);
		gameOverText.alignment = CENTER;
		gameOverText.visible = false;

		winText = new FlxBitmapText();
		winText.text = "You did it!";
		winText.screenCenter();
		winText.scale.set(1.3, 1.3);
		winText.alignment = CENTER;
		winText.visible = false;

		scoreText = new FlxBitmapText();
		scoreText.text = "Score: " + Reg.score;
		scoreText.screenCenter();
		scoreText.scale.set(0.4, 0.4);
		scoreText.alignment = CENTER;
		scoreText.y = 5;

		restartText = new FlxBitmapText();
		restartText.text = "Press R to restart";
		restartText.screenCenter();
		restartText.scale.set(0.4, 0.4);
		restartText.alignment = CENTER;
		restartText.y += 5;
		restartText.visible = false;

		add(wayToGoBar);
		add(wayToGoCursor);
		add(shipLife);
		add(cargoText);
		add(cargoResistance);
		add(gameOverText);
		add(winText);
		add(scoreText);
		add(restartText);
	}

	override function update(elapsed:Float)
	{
		if (!Reg.PS.isWin && !Reg.PS.isGameover)
		{
			_timeCounterToCursorMove += elapsed;
			if (_timeCounterToCursorMove >= _timeToCursorMove)
			{
				wayToGoCursor.x += 1;

				if (wayToGoCursor.x == wayToGoBar.x + wayToGoBar.width - 3)
				{
					Reg.PS.win();
				}

				_timeCounterToCursorMove = 0;
			}

			scoreText.text = "Score: " + Reg.score;
		}
		else
		{
			restartText.visible = true;
		}

		cargoResistance.text = Reg.PS.cargo.health + "%";

		if (Reg.PS.isGameover)
		{
			gameOverText.visible = true;
		}
		else if (Reg.PS.isWin)
		{
			winText.visible = true;
		}

		super.update(elapsed);
	}
}
