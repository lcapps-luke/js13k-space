package;

import js.html.CanvasRenderingContext2D;

class Minimap{
	private var x:Float;
	private var y:Float;
	private var r:Float;
	private var ratio:Float;

	public function new(x:Float, y:Float, r:Float, wr:Float){
		this.x = x;
		this.y = y;
		this.r = r;
		this.ratio = r / wr;
	}

	public function update(c:CanvasRenderingContext2D){
		c.fillStyle = "#AAA";
		c.beginPath();
		c.arc(x, y, r + 16, 0, Math.PI * 2);
		c.fill();
		
		c.fillStyle = "#000";
		c.beginPath();
		c.arc(x, y, r, 0, Math.PI * 2);
		c.fill();

		for(p in Game.planets){
			var pr = Math.max(p.r * ratio, 5);

			c.fillStyle = p.c;
			c.beginPath();
			c.arc(x + p.x * ratio, y + p.y * ratio, pr, 0, Math.PI * 2);
			c.fill();
		}

		drawTriangle(c, x + Game.p.x * ratio, y + Game.p.y * ratio, 5, "#0F0");

		for(e in Game.eSwm){
			drawTriangle(c, x + e.aabb.cX() * ratio, y + e.aabb.cY() * ratio, 8, "#F00");
		}
	}

	private function drawTriangle(c:CanvasRenderingContext2D, x:Float, y:Float, r:Float, s:String){
		c.strokeStyle = s;
		c.lineWidth = 1;
		c.beginPath();
		c.moveTo(x, y - r);
		c.lineTo(x + r, y + r);
		c.lineTo(x - r, y + r);
		c.lineTo(x, y - r);
		c.stroke();
	}
}