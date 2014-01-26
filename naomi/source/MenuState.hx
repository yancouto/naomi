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
class MenuState extends FlxState {
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
		
		//FlxG.sound.playMusic("assets/music/stars beneath the roof.mp3", .2);


		background = new FlxSprite(0, 0);

		background.loadGraphic("assets/images/mainmenu.png", false);
		background.x = (GameClass.gameWidth-background.width)/2;
		background.y = (GameClass.gameHeight-background.height)/2;
		
		selector = new Selector(background.x + 45, background.y + 520);

		selected = false;

		add(background);
		add(selector);
		
		super.create();
	}
	
	/**
	 * Function that is called when this state is destroyed - you might want to 
	 * consider setting all objects this state uses to null to help garbage collection.
	 */
	override public function destroy() : Void {
		super.destroy();
		//FlxG.sound.music.fadeOut(1);
	}

	/**
	 * Function that is called once every frame.
	 */
	override public function update() : Void {
		if(FlxG.keyboard.justPressed("LEFT") && selected) {
			selector.x = 45 + background.x;
			selector.refresh();
			selected = false;
		} else if(FlxG.keyboard.justPressed("RIGHT") && !selected) {
			selector.x = 440 + background.x;
			selector.refresh();
			selected = true;
		} else if(FlxG.keyboard.justPressed("ENTER")) {
			if(!selected)
				FlxG.switchState(new LevelDemo());
			else
				FlxG.switchState(new CreditsState());
		}

		super.update();
	}	
}