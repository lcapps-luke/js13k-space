package math;

class Line {
	public var a:Vec;
	public var b:Vec;

	public function new(x1:Float = 0, y1:Float = 0 , x2:Float = 0, y2:Float = 0) {
		this.a = new Vec(x1, y1);
		this.b = new Vec(x2, y2);
	}
	
	public function getLength():Float {
		return Math.sqrt(Math.pow(a.x - b.x, 2) + Math.pow(a.y - b.y, 2));
	}
	
	public function getDirection():Float {
		return Math.atan2(b.x - a.x, b.y - a.y);
	}

	public function copy(o:Line){
		a.copy(o.a);
		b.copy(o.b);
	}
}