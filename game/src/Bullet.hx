package;

import math.AABB;
import js.html.CanvasRenderingContext2D;

class Bullet{
	private static inline var RADIUS:Float = 5;
	private static inline var TIME_TO_LIVE = 5;

	private var aabb:AABB;
	private var x:Float;
	private var y:Float;
	private var xs:Float;
	private var ys:Float;
	private var ttl:Float;

	public function new(x:Float, y:Float, xSpeed:Float, ySpeed:Float){
		this.x = x;
		this.y = y;
		this.xs = xSpeed;
		this.ys = ySpeed;
		ttl = TIME_TO_LIVE;
	}

	public function update(c:CanvasRenderingContext2D, s:Float):Bool{
		ttl -= s;
		if(ttl < 0){
			return false;
		}

		x += xs * s;
		y += ys * s;

		c.fillStyle = "#F00";
		c.beginPath();
		c.arc(x, y, RADIUS, 0, Math.PI * 2);
		c.fill();

		return true;
	}
}