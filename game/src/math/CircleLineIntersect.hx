package math;

class CircleLineIntersect {
	public var circle(default, null):Circle;
	public var line(default, null):Line;
	
	private var firstIntersect:Bool;
	private var first:Vec;
	private var secondIntersect:Bool;
	private var second:Vec;

	public function new() {
		this.circle = new Circle();
		this.line = new Line();
		
		first = new Vec();
		second = new Vec();
	}
	
	/*----------------------------------------*
	 * https://github.com/alecmce/as3geometry *
	 *----------------------------------------*/
	public function update():Bool {
		firstIntersect = false;
		secondIntersect = false;
		
		var fx : Float = 0;
		var fy : Float = 0;
		var sx : Float = 0;
		var sy : Float = 0;
		
		var cx : Float = circle.c.x;
		var cy : Float = circle.c.y;
		var r : Float = circle.r;
		var x : Float = line.a.x - cx;
		var y : Float = line.a.y - cy;
		var i : Float = line.b.x - line.a.x;
		var j : Float = line.b.y - line.a.y;
		
		// you can derive a quadratic of the form An^2 + Bn + C = 0
		var A : Float = i * i + j * j;
		var B : Float = 2 * (x * i + y * j);
		var C : Float = x * x + y * y - r * r;

		var n : Float;
		
		// checking the discriminant for number of solutions
		var discriminant : Float = B * B - 4 * A * C;
		if (discriminant == 0){
			n = -B / (2 * A);

			if(n >= 0 && n <= 1){
				fx = cx + x + i * n;
				fy = cy + y + j * n;
				
				firstIntersect = true;
			}
		}else if (discriminant > 0){
			discriminant = Math.sqrt(discriminant);

			cx += x;
			cy += y;

			n = (-B + discriminant) / (2 * A);
			var isFirstValueValid : Bool = (n >= 0 && n <= 1);
			if (isFirstValueValid){
				fx = cx + i * n;
				fy = cy + j * n;
				
				firstIntersect = true;
			}

			n = (-B - discriminant) / (2 * A);
			if (n >= 0 && n <= 1){
				if (isFirstValueValid){
					sx = cx + i * n;
					sy = cy + j * n;
					
					secondIntersect = true;
				}else{
					fx = cx + i * n;
					fy = cy + j * n;
					
					firstIntersect = true;
				}
			}
		}
		
		first.x = fx;
		first.y = fy;
		
		second.x = sx;
		second.y = sy;
		
		return hasIntersect();
	}
	
	public function hasIntersect():Bool {
		return firstIntersect || secondIntersect;
	}
	
	public inline function getFirst():Vec {
		return first;
	}
	
	public inline function getSecond():Vec {
		return second;
	}
}