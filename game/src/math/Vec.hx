package math;

class Vec {
	public var x:Float;
	public var y:Float;

	public function new(x:Float = 0, y:Float = 0 ) {
		this.x = x;
		this.y = y;
	}
	
	public function set(x:Float, y:Float) {
		this.x = x;
		this.y = y;
	}

	public function copy(o:Vec) {
		x = o.x;
		y = o.y;
	}
}