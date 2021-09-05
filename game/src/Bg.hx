package;

import js.html.CanvasRenderingContext2D;
import js.html.CanvasElement;
import js.Browser;

class Bg{
	private static inline var SIZE:Int = 512;

	private var p:Float;
	private var ce:CanvasElement;

	public function new(p:Float, g:Int, i:Float, a:Float){
		this.p = p;
		ce = Browser.window.document.createCanvasElement();
		ce.width = SIZE;
		ce.height = SIZE;
		var c = ce.getContext2d();

		var rs = Math.floor(SIZE / g); // region size

		c.fillStyle = "#FFF";
		for(ry in 0...g){
			var yf = rs * ry;  // y from
			for(rx in 0...g){
				var xf = rs * rx; // x from
				var sr = i + Math.random() * a;

				var sx = sr + Math.random() * (rs - sr * 2);
				var sy = sr + Math.random() * (rs - sr * 2);

				c.beginPath();
				c.arc(sx + xf, sy + yf, sr, 0, Math.PI * 2);
				c.fill();
			}
		}
	}

	public function update(c:CanvasRenderingContext2D, vx:Float, vy:Float){
		var rx = Math.ceil(c.canvas.width / SIZE) + 1;
		var ry = Math.ceil(c.canvas.height / SIZE) + 1;

		var sx = -vx * p;
		var ovr = Math.ceil(sx / SIZE);
		sx -= ovr * SIZE;
		var sy = -vy * p;
		ovr = Math.ceil(sy / SIZE);
		sy -= ovr * SIZE;

		for(dy in 0...ry){
			var oy = SIZE * dy;
			for(dx in 0...rx){
				var ox = SIZE * dx;

				c.drawImage(ce, sx + ox, sy + oy);
			}
		}
	}
}