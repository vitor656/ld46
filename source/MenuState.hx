import flixel.FlxG;
import flixel.FlxState;
import flixel.addons.display.FlxStarField.FlxStarField2D;
import flixel.text.FlxBitmapText;

class MenuState extends FlxState
{
	var title:FlxBitmapText;
	var start:FlxBitmapText;
	var starfield:FlxStarField2D;
	var cargo:Cargo;

	override function create()
	{
		super.create();

		title = new FlxBitmapText();
		title.text = "Delivery Space Attack";
		title.screenCenter();
		title.scale.set(0.6, 0.6);
		title.y -= 10;

		start = new FlxBitmapText();
		start.text = "Press SPACE to start";
		start.screenCenter();
		start.scale.set(0.5, 0.5);

		starfield = new FlxStarField2D(0, 0, FlxG.width, FlxG.height, 20);
		starfield.starVelocityOffset.set(0, 5);
		starfield.setStarSpeed(5, 10);

		cargo = new Cargo();
		cargo.screenCenter();
		cargo.y += 20;

		add(starfield);
		add(cargo);
		add(start);
		add(title);
	}

	override function update(elapsed:Float)
	{
		if (FlxG.keys.justPressed.SPACE)
		{
			FlxG.switchState(new PlayState());
		}

		super.update(elapsed);
	}
}
