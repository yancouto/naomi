package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxMath;
import flixel.util.FlxPoint;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import flixel.effects.FlxTrail;

/**
 * A FlxState which can be used for the game's menu.
 */
class MenuState extends base.State {
	private var selector : Selector;
	private var selected : Bool;
	private var background : FlxSprite;

	/**
	 * Function that is called up when to state is created to set it up. 
	 */
	override public function create() : Void {
		FlxG.cameras.bgColor = 0xff0f113a;

		#if !FLX_NO_MOUSE
			FlxG.mouse.show();
		#end
		
		Reg.playBackgroundMusic("Stars Beneath the Roof.mp3", 0);

		background = new FlxSprite(0, 0);

		background.loadGraphic("assets/images/mainmenu.png", false);
		background.x = (GameClass.gameWidth - background.width) / 2;
		background.y = (GameClass.gameHeight - background.height) / 2;
		
		selector = new Selector(background.x + 45, background.y + 520);

		selected = false;

		add(background);
		add(selector);
		
		super.create();
	}

	/**
	 * Function that is called once every frame.
	 */
	override public function update() : Void {
		if(FlxG.keyboard.anyJustPressed(['LEFT', 'A']) && selected) {
			selector.x = 45 + background.x;
			selector.refresh();
			selected = false;
		} else if(FlxG.keyboard.anyJustPressed(['RIGHT', 'D']) && !selected) {
			selector.x = 440 + background.x;
			selector.refresh();
			selected = true;
		} else if(FlxG.keyboard.anyJustPressed(['ENTER', 'SPACE'])) {
			if(!selected)
				FlxG.switchState(new IntroText());
			else
				FlxG.switchState(new CreditsState());
		}

		super.update();
	}	
}