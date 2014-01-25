package base;

import flixel.FlxSprite;

class Interactible extends FlxSprite {

	// How long it takes before you can interact with it again. Default is 2s.
	public var interactionCooldown(get, set) : Float;
	

	public function new(x : Float, y : Float, cooldown : Float = 2) {
		super(x, y);
		cooldownTimer = new Timer({timeToSet: cooldown, repeats: false, callback: function(t : Timer) { t.running = false; }, running: false });
		cooldownTimer.delete = true;
	}

	public static function doInteraction(i : Interactible, e : Enemy) : Void {
		if(i.cooldownTimer.running) return;
		Timer.register(i.cooldownTimer);
		i.interact(e);
	}

	public function interact(e : Enemy) : Void {
		//override this
	}

	private function set_interactionCooldown(f : Float) : Float return cooldownTimer.timeToSet = f;
	private function get_interactionCooldown() : Float return cooldownTimer.timeToSet;

	private var cooldownTimer : Timer;
}