package math;

class Circle {
	public var c:Vec;
	public var r:Float; 
	
	public function new(x:Float = 0, y:Float = 0 , r:Float = 0) {
		this.c = new Vec(x, y);
		this.r = r;
	}

	public function set(x:Float = 0, y:Float = 0 , r:Float = 0){
		c.set(x, y);
		this.r = r;
	}
}