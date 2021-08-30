package planet;

import enemy.Enemy;
import js.html.CanvasRenderingContext2D;
import math.AABB;

class Dome{
	public static inline var RADIUS:Float = 50;

	private var p:Planet;
	private var d:Float;

	public var aabb(default, null):AABB;
	private var h:Float = 5;

	public var ex(default, null):Float = 0;
	public var ey(default, null):Float = 0;

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

		ex = p.x + Math.cos(d) * (p.r + Enemy.INFECT_DISTANCE);
		ey = p.y + Math.sin(d) * (p.r + Enemy.INFECT_DISTANCE);

		if(Game.inView(aabb) && isAlive()){
			c.fillStyle = "#333";
			c.beginPath();
			c.arc(x, y, RADIUS, 0, Math.PI * 2);
			c.fill();
		}
	}

	public inline function isAlive():Bool{
		return h > 0;
	}

	public inline function hit(d:Float){
		h -= d;
	}
}