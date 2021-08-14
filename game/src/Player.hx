package;

import math.LcMath;
import planet.Planet;
import js.html.CanvasRenderingContext2D;

class Player {
	private static inline var MAX_SPEED:Float = 200;
	private static inline var THRUST:Float = 300;

	public var x:Float;
	public var y:Float;
	public var xs:Float;
	public var ys:Float;

	public function new() {
		x = 100;
		y = 200;
		xs = 0;
		ys = 0;
	}

	public function update(s:Float, c:CanvasRenderingContext2D) {
		var p = calculatePlanetAttraction(s);

		if(Ctrl.acc > 0){
			var ax = Math.cos(Ctrl.dir) * Ctrl.acc * THRUST;
			var ay = Math.sin(Ctrl.dir) * Ctrl.acc * THRUST;
			xs += ax * s;
			ys += ay * s;
		}

		var dir = Math.atan2(ys, xs);
		var spd = LcMath.distD(xs, ys);
		spd = Math.min(spd, MAX_SPEED);
		xs = Math.cos(dir) * spd;
		ys = Math.sin(dir) * spd;

		x += xs * s;
		y += ys * s;

		if(p != null){
			var dir = Math.atan2(y - p.y, x - p.x);
			x = p.x + Math.cos(dir) * p.r;
			y = p.y + Math.sin(dir) * p.r;
			xs = 0;
			ys = 0;
		}

		c.fillStyle = "#00F";
		c.beginPath();
		c.arc(x, y, 10, 0, Math.PI * 2);
		c.fill();
	}

	private inline function calculatePlanetAttraction(s:Float):Planet{
		var ax = 0.0;
		var ay = 0.0;

		var touchPlanet:Planet = null;

		for(p in Game.planets){
			var dx = p.x - x;
			var dy = p.y - y;

			var dir = Math.atan2(dy, dx);
			var dis = LcMath.distD(dx, dy);
			var acc = (Game.GRAVITY * p.m) / Math.pow(dis, 2);

			ax += Math.cos(dir) * acc;
			ay += Math.sin(dir) * acc;

			if(dis <= p.r){
				touchPlanet = p;
			}
		}

		xs += ax * s;
		ys += ay * s;

		return touchPlanet;
	}
}
