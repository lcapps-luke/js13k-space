package;

import math.Line;
import math.CircleLineIntersect;
import math.LcMath;
import planet.Planet;
import js.html.CanvasRenderingContext2D;

class Player {
	private static inline var MAX_SPEED:Float = 600;
	private static inline var THRUST:Float = 400;
	private static inline var SHOT_COOL_DOWN:Float = 0.33;
	private static inline var SHOT_SPEED:Float = 600;
	private static inline var RADIUS:Float = 10;
	private static inline var ZOOM_DIST:Float = 900;

	public var x:Float = 0;
	public var y:Float = 0;
	public var xs:Float = 0;
	public var ys:Float = 0;

	public var scd:Float = 0; // shot cool down
	public var alive:Bool = true;

	private var hitCli:CircleLineIntersect = new CircleLineIntersect();

	public function new() {
		
	}

	public function update(s:Float, c:CanvasRenderingContext2D) {
		if(!alive){
			return;
		}

		var p = calculatePlanetAttraction(s);

		var dir = Math.atan2(ys, xs);
		var spd = LcMath.distD(xs, ys);
		spd = Math.min(spd, MAX_SPEED);
		xs = Math.cos(dir) * spd;
		ys = Math.sin(dir) * spd;

		if(p != null){
			var dir = LcMath.dir(p.x, p.y, x, y);
			x = p.x + Math.cos(dir) * p.r;
			y = p.y + Math.sin(dir) * p.r;
			xs = p.xs;
			ys = p.ys;
		}

		if(Ctrl.acc > 0){
			var ax = Math.cos(Ctrl.dir) * Ctrl.acc * THRUST;
			var ay = Math.sin(Ctrl.dir) * Ctrl.acc * THRUST;
			xs += ax * s;
			ys += ay * s;
		}

		x += xs * s;
		y += ys * s;
		hitCli.circle.set(x, y, RADIUS);

		scd = scd > 0 ? scd - s : 0;
		if(Ctrl.trg && scd <= 0){
			scd = SHOT_COOL_DOWN;
			shoot();
		}

		c.fillStyle = "#00F";
		c.beginPath();
		c.arc(x, y, RADIUS, 0, Math.PI * 2);
		c.fill();
	}

	private inline function calculatePlanetAttraction(s:Float):Planet{
		var ax = 0.0;
		var ay = 0.0;

		var touchPlanet:Planet = null;
		var zoom:Float = 0.4;//0.25;

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

			if(dis - p.r < ZOOM_DIST){
				zoom = 1;
			}
		}

		xs += ax * s;
		ys += ay * s;

		Game.zoomTarget = zoom;

		return touchPlanet;
	}

	private inline function shoot(){
		Game.addPlayerBullet(new Bullet(x, y, Math.cos(Ctrl.aim) * SHOT_SPEED, Math.sin(Ctrl.aim) * SHOT_SPEED));
	}

	public function checkHit(laserLine:Line) {
		hitCli.line.copy(laserLine);
		if(hitCli.update()){
			alive = false;
		}
	}
}
