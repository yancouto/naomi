package menus;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;

class CreditsState extends base.State {
	private var back : MenuButton;
	private var selector : Selector;

	override public function create() : Void {
		FlxG.cameras.bgColor = 0xff0b2b57;

		#if !FLX_NO_MOUSE
			FlxG.mouse.visible = true;
		#end

		var backText = new FlxText(0, 0, 300, "Back", 40);
		back = new MenuButton(GameClass.gameWidth / 2 - 100, GameClass.gameHeight - 100);
		back.makeGraphic(Std.int(backText.width), Std.int(backText.height), 0x00000000);
		back.stamp(backText, 0, 0);
		back.onClick = function(self) { FlxG.switchState(new MenuState()); };
		
		backText.destroy();
		backText = null;

		add(back);
		
		selector = new Selector(back.x - 50, back.y);

		add(new FlxText(250, 200, 500, 
			"Renato Lui Geh\n\nRicardo Lira da Fonseca\n\nYan Soares Couto", 20));

		add(selector);

		super.create();
	}

	override public function update() : Void {
		if(FlxG.keys.anyJustPressed(['ENTER', 'SPACE']))
			back.onClick(back);
		super.update();
	}
}