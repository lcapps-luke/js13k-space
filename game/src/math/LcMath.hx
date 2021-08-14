package math;

class LcMath{
	public static function distP(ax:Float, ay:Float, bx:Float, by:Float):Float{
		return distD(bx - ax, by - ay);
	}

	public static function distD(dx:Float, dy:Float):Float{
		return Math.sqrt(Math.pow(dx, 2) + Math.pow(dy, 2));
	}
}