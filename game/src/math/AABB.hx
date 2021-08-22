package math;

class AABB{
	public var x:Float;
	public var y:Float;
	public var w:Float;
	public var h:Float;

	public function new(x:Float = 0, y:Float = 0, w:Float = 0, h:Float = 0){
		this.x = x;
		this.y = y;
		this.w = w;
		this.h = h;
	}

	public inline function contains(ox:Float, oy:Float):Bool{
		return !(ox < x || ox > x + w || oy < y || oy > y + h);
	}

	public function check(o:AABB):Bool{
		return !(x > o.x + o.w || o.x > x + w || y > o.y + o.h || o.y > y + h);
	}

	public function copy(o:AABB){
		x = o.x;
		y = o.y;
		w = o.w;
		h = o.h;
	}

	public function add(o:AABB){
		var nx = Math.min(x, o.x);
		var ny = Math.min(y, o.y);

		w = Math.max(x + w, o.x + o.w) - nx;
		h = Math.max(y + h, o.y + o.h) - ny;

		x = nx;
		y = ny;
	}
}