package;

import js.html.CanvasRenderingContext2D;

class Player {
	public var x:Float;
	public var y:Float;

	public function new() {
		x = 100;
		y = 200;
	}

	public function update(s:Float, c:CanvasRenderingContext2D) {
		c.fillStyle = "#00F";
		c.beginPath();
		c.arc(x, y, 10, 0, Math.PI * 2);
		c.fill();
	}
}
