package planet;

import js.html.CanvasRenderingContext2D;
import math.AABB;

class Dome{
	public static inline var RADIUS:Float = 50;

	private var p:Planet;
	private var d:Float;

	private var aabb:AABB;

	public function new(p:Planet, d:Float){
		this.p = p;
		this.d = d;
		aabb = new AABB(0, 0, RADIUS * 2, RADIUS * 2);
	}

	public function update(s:Float, c:CanvasRenderingContext2D){
		var x = p.x + Math.cos(d) * p.r;
		var y = p.y + Math.sin(d) * p.r;
		aabb.x = x - RADIUS;
		aabb.y = y - RADIUS;

		if(Game.inView(aabb)){
			c.fillStyle = "#333";
			c.beginPath();
			c.arc(x, y, RADIUS, 0, Math.PI * 2);
			c.fill();
		}
	}
}