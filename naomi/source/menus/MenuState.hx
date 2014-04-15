package menus;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxCamera;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxMath;
import flixel.util.FlxPoint;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import flixel.tweens.misc.VarTween;
import flixel.addons.effects.FlxTrail;

import base.Timer;

/**
 * A FlxState which can be used for the game's menu.
 */
class MenuState extends base.State {
	private var selector : Selector;
	private var selected : Bool;
	private var background : FlxSprite;
	private var playButton : MenuButton;
	private var creditsButton : MenuButton;
	private var changingState : Bool;
	private var changeStateTimer : Timer;

	/**
	 * Function that is called up when to state is created to set it up. 
	 */
	override public function create() : Void {
		FlxG.cameras.bgColor = 0xff0b2b57;

		#if !FLX_NO_MOUSE
			FlxG.mouse.visible = true;
		#end
		
		Reg.playBackgroundMusic("Stars Beneath the Roof.mp3", 0);

		background = new FlxSprite(0, 0);

		background.loadGraphic("assets/images/mainmenu_1.png", false);
		background.x = (GameClass.gameWidth - background.width) / 2;
		background.y = (GameClass.gameHeight - background.height) / 2;
		
		selector = new Selector(background.x + 45, background.y + 505);

		selected = false;

		playButton = new MenuButton(background.x + 87, background.y + 510, "start.png");
		playButton.onClick = function(self) { startGame(); };

		creditsButton = new MenuButton(background.x + 482, background.y + 510, "credits.png");
		creditsButton.onClick = function(self) { FlxG.switchState(new CreditsState()); };

		add(background);
		add(selector);

		add(playButton);
		add(creditsButton);

		changingState = false;

		super.create();
	}

	private function startGame() : Void {
		changingState = true;

		playButton.onClick = creditsButton.onClick = null;
		
		FlxTween.color(playButton, 2, playButton.color, playButton.color, 1, 0);
		FlxTween.color(creditsButton, 2, creditsButton.color, creditsButton.color, 1, 0);
		FlxTween.color(selector, 2, selector.color, selector.color, 1, 0);

		var text = new FlxText(15, 600 + 15, 785, IntroText.introText, 30);
		FlxTween.color(text, 3, text.color, text.color, 0, 1);
		add(text);

		var followed = new FlxObject(FlxG.camera.x + FlxG.width/2, FlxG.camera.y + FlxG.height/2, 0, 0);
		FlxG.camera.follow(followed, FlxCamera.STYLE_NO_DEAD_ZONE);
		FlxTween.linearMotion(followed, followed.x, followed.y, followed.x, followed.y + 600, 3, true);

		changeStateTimer = new Timer({timeToSet: 3, callback: function(self: Timer) {
			self.delete = true;
			FlxG.switchState(new IntroText());
		}, running: true});
	}

	override public function update() : Void {
		if(changingState) {
			if(FlxG.mouse.justPressed || FlxG.keys.anyJustPressed(['SPACE', 'ENTER', 'ESCAPE']))
				changeStateTimer.callback(changeStateTimer);
			super.update();
			return;
		}

		super.update();
		
		if(FlxG.keys.anyJustPressed(['LEFT', 'A']) && selected) {
			selector.setPosition(45 + background.x, background.y + 505);
			selector.refresh();
			selected = false;
		} else if(FlxG.keys.anyJustPressed(['RIGHT', 'D']) && !selected) {
			selector.setPosition(440 + background.x, background.y + 505);
			selector.refresh();
			selected = true;
		} else if(FlxG.keys.anyJustPressed(['ENTER', 'SPACE'])) {
			if(!selected)
				startGame();
			else
				FlxG.switchState(new CreditsState());
		}
	}	
}