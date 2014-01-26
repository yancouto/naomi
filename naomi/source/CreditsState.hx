package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;

class CreditsState extends FlxState {
	private var back : FlxText;
	private var selector : Selector;

	override public function create() : Void {
		FlxG.cameras.bgColor = 0xff0f113a;

		#if !FLX_NO_MOUSE
			FlxG.mouse.show();
		#end

		back = new FlxText(GameClass.gameWidth/2-100, GameClass.gameHeight-100,
			100, "Back", 20);
		selector = new Selector(back.x-50, back.y);

		add(back);
		add(new FlxText(250, 200, 500, 
			"Renato Lui Geh\n\nRicardo Lira da Fonseca\n\nYan Soares Couto", 20));

		add(selector);

		super.create();
	}

	override public function update() : Void {
		if(FlxG.keyboard.justPressed("ENTER"))
			FlxG.switchState(new MenuState());
		super.update();
	}
}