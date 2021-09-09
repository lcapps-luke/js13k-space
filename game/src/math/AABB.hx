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
		addR(o.x, o.y, o.w, o.h);
	}

	public function addC(x:Float, y:Float, r:Float){
		addR(x - r, y - r, r * 2, r * 2);
	}

	public function addR(ox:Float, oy:Float, ow:Float, oh:Float){
		var nx = Math.min(x, ox);
		var ny = Math.min(y, oy);

		w = Math.max(x + w, ox + ow) - nx;
		h = Math.max(y + h, oy + oh) - ny;

		x = nx;
		y = ny;
	}

	public function cX():Float{
		return x + w / 2;
	}

	public function cY():Float{
		return y + h / 2;
	}
}