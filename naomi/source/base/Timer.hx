package base;

class Timer {
	public var timeToSet : Float;
	public var callback : Timer -> Void;
	public var repeats : Bool;
	public var running : Bool;
	public var delete : Bool;
	private var currentTime : Float;

	public static function callIn(timeToSet : Float, callback : Void -> Void) {
		new Timer({ timeToSet : timeToSet, repeats: false, callback : function(_) { callback(); } });
	}

	public function new( args : { timeToSet : Float, callback : Timer -> Void, ?repeats : Bool, ?running : Bool} ) {
		timeToSet = args.timeToSet;
		callback = args.callback;
		delete = false;
		repeats = (args.repeats == null? false : args.repeats);
		running = (args.running == null? true : args.running);
		currentTime = 0;
		timers.add(this);
	}

	public function reset() : Void currentTime = 0;

	public static function register(t : Timer) : Void {
		if(!t.delete) return;
		t.delete = false;
		t.currentTime = 0;
		t.running = true;
		timers.add(t);
	}

	private static function isAlive(timer : Timer) return !timer.delete;

	public static function updateTimers(dt : Float) : Void {
		for(timer in timers) {
			if(timer.running)
				timer.currentTime += dt;
			if(timer.currentTime >= timer.timeToSet) {
				timer.currentTime -= timer.timeToSet;
				if(!timer.repeats) timer.delete = true;
				timer.callback(timer);
			}
		}
		timers = timers.filter(isAlive);
	}

	static function __init__()
		timers = new List <Timer>();

	private static var timers : List<Timer>;
}