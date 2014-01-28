package base;

class Utils {
	public static function sign(x : Float) : Int
		return x == 0? 0 : x > 0? 1 : -1;
}