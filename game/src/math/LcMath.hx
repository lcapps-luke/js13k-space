package math;

class LcMath{
	public static inline function distP(ax:Float, ay:Float, bx:Float, by:Float):Float{
		return distD(bx - ax, by - ay);
	}

	public static inline function distD(dx:Float, dy:Float):Float{
		return Math.sqrt(Math.pow(dx, 2) + Math.pow(dy, 2));
	}

	public static inline function dir(ax:Float, ay:Float, bx:Float, by:Float):Float{
		return Math.atan2(by - ay, bx - ax);
	}
}