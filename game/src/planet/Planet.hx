package planet;

import js.html.CanvasRenderingContext2D;

class Planet{
	public var x:Float;
	public var y:Float;
	public var r:Float;
	public var m:Float;

	public function new(x:Float, y:Float, r:Float, m:Float){
		this.x = x;
		this.y = y;
		this.r = r;
		this.m = m;
	}

	public function update(s:Float, c:CanvasRenderingContext2D) {
		c.fillStyle = "#888";
		c.beginPath();
		c.arc(x, y, r, 0, Math.PI * 2);
		c.fill();
	}
}