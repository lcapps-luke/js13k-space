package;

import ptcl.ExpPtcl;
import js.html.svg.ImageElement;
import math.Line;
import math.CircleLineIntersect;
import math.LcMath;
import planet.Planet;
import js.html.CanvasRenderingContext2D;

class Player {
	private static inline var MAX_SPEED:Float = 600;
	private static inline var THRUST:Float = 800;
	private static inline var SHOT_COOL_DOWN:Float = 0.15;
	private static inline var SHOT_SPEED:Float = 600;
	private static inline var RADIUS:Float = 12;
	private static inline var SPR_RADIUS:Float = 20;
	private static inline var ZOOM_DIST:Float = 900;
	private static inline var ACCURACY:Float = 3.14 / 16;

	public var x:Float = 0;
	public var y:Float = 0;
	public var xs:Float = 0;
	public var ys:Float = 0;

	public var scd:Float = 0; // shot cool down
	public var alive:Bool = true;

	private var hitCli:CircleLineIntersect = new CircleLineIntersect();
	private var spr:ImageElement;
	private var gunSpr:ImageElement;

	private var pNear:Planet;
	private var pNearDist:Float;

	private var deadTime:Float = 0;

	public function new() {
		spr = Game.img["player"];
		gunSpr = Game.img["gun"];
	}

	public function update(s:Float, c:CanvasRenderingContext2D) {
		if(!alive){
			deadTime += s;
			if(deadTime > 3 && deadTime < 100){
				Game.respawn();
				deadTime = 100;
			}
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

			if(p.m > 699999){
				die();
			}
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


		if(pNearDist < 50){
			dir = LcMath.dir(pNear.x, pNear.y, x, y);
		}

		c.save();
		c.translate(x, y);
		c.rotate(dir + Math.PI / 2);
		c.drawImage(spr, -SPR_RADIUS, -SPR_RADIUS, SPR_RADIUS * 2, SPR_RADIUS * 2);
		
		c.rotate((Ctrl.aim + Math.PI / 2) - (dir + Math.PI / 2));
		c.drawImage(gunSpr, -SPR_RADIUS, -SPR_RADIUS, SPR_RADIUS * 2, SPR_RADIUS * 2);
		c.restore();
	}

	private inline function calculatePlanetAttraction(s:Float):Planet{
		var ax = 0.0;
		var ay = 0.0;

		var touchPlanet:Planet = null;
		var zoom:Float = 0.7;//0.25;

		pNear = null;

		for(p in Game.planets){
			var dx = p.x - x;
			var dy = p.y - y;

			var dir = Math.atan2(dy, dx);
			var dis = LcMath.distD(dx, dy);
			var acc = (Game.GRAVITY * p.m) / Math.pow(dis, 2);

			ax += Math.cos(dir) * acc;
			ay += Math.sin(dir) * acc;

			var sDis = dis - p.r;

			if(sDis <= 0){
				touchPlanet = p;
			}

			if(dis - p.r < ZOOM_DIST){
				zoom = 1;
			}

			if(pNear == null || sDis < pNearDist){
				pNearDist = sDis;
				pNear = p;
			}			
		}

		xs += ax * s;
		ys += ay * s;

		Game.zoomTarget = zoom;

		return touchPlanet;
	}

	private inline function shoot(){
		Sound.shoot();
		var sdir = Ctrl.aim - ACCURACY / 2 + Math.random() * ACCURACY;
		Game.addPlayerBullet(new Bullet(x, y, Math.cos(sdir) * SHOT_SPEED, Math.sin(sdir) * SHOT_SPEED));
		Stats.shotFired();
	}

	public function checkHit(laserLine:Line) {
		if(alive){
			hitCli.line.copy(laserLine);
			if(hitCli.update()){
				die();
			}
		}
	}

	private function die(){
		alive = false;
		Sound.playerExplode();
		Game.emitParticles(new ExpPtcl(x, y));
		Stats.playerKilled();
	}
}
