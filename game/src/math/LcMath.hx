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

	public static function suffle(arr:Array<Dynamic>) {
		var ci = arr.length;
		var ri = 0;

		while(ci != 0){
			ri = Math.floor(Math.random() * ci);
			ci--;

			var ce = arr[ci];
			var re = arr[ri];
			arr[ci] = re;
			arr[ri] = ce;
		}
	}

	public static function cap(v:Float, mi:Float = 0, ma:Float = 1):Float{
		return v < mi ? mi : (v > ma ? ma : v);
	}
}