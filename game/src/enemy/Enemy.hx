package enemy;

import math.Line;
import math.LcMath;
import math.AABB;
import js.html.CanvasRenderingContext2D;

class Enemy{
	private static inline var RADIUS:Float = 15;
	private static inline var AVOID_RADIUS:Float = RADIUS * 3;
	public static inline var INFECT_DISTANCE:Float = 100;
	private static inline var MAX_SPEED:Float = 400;
	private static inline var ACC:Float = 2000;
	private static inline var ENGAGE_DISTANCE:Float = 400;
	private static inline var FIRE_DISTANCE:Float = 600;
	private static inline var LASER_DIST:Float = 1000;

	public var x:Float;
	public var y:Float;
	private var xs:Float = 0;
	private var ys:Float = 0;
	private var xa:Float = 0;
	private var ya:Float = 0;

	private var health:Int;
	private var swrm:Swarm;
	public var engaged:Bool = false;
	
	private var fcd:Float = 3;
	private var fire:Float = 0;
	private var fireDir:Float = 0;
	private var laserLine:Line = new Line();

	public var aabb(default, null):AABB;

	public function new(x:Float, y:Float, h:Int, s:Swarm){
		this.x = x;
		this.y = y;
		this.health = h;
		this.swrm = s;

		aabb = new AABB(x, y, RADIUS * 2, RADIUS * 2);
	}

	public function update(s:Float, c:CanvasRenderingContext2D):Bool{
		if(health <= 0){
			return false;
		}

		xs = xs * 0.9;
		ys = ys * 0.9;

		if(engaged){
			updateEngaged(s, c);
		}else{
			updateDisengaged(s, c);
		}


		xs += xa * s;
		ys += ya * s;
		x += xs * s;
		y += ys * s;

		aabb.x = x - RADIUS;
		aabb.y = y - RADIUS;

		if(Game.inView(aabb)){
			c.fillStyle = "#E0F";
			c.beginPath();
			c.arc(x, y, RADIUS, 0, Math.PI * 2);
			c.fill();
		}

		return true;
	}

	public inline function updateEngaged(s:Float, c:CanvasRenderingContext2D){
		if(fire > 0){
			fire -= s;
			laserLine.a.set(x, y);
			laserLine.b.set(x + Math.cos(fireDir) * LASER_DIST, y + Math.sin(fireDir) * LASER_DIST);

			if(fire > 0.5){
				// laser
				c.strokeStyle = "#F00";
				c.lineWidth = 1;
			}else{
				// hit
				c.strokeStyle = "#F00";
				c.lineWidth = 3;

				Game.p.checkHit(laserLine);
			}

			c.beginPath();
			c.moveTo(x, y);
			c.lineTo(laserLine.b.x, laserLine.b.y);
			c.stroke();

			return;
		}
		// move toward player
		var dist = LcMath.distP(x, y, Game.p.x, Game.p.y);
		var dir = LcMath.dir(x, y, Game.p.x, Game.p.y);

		if(dist > ENGAGE_DISTANCE){
			xa = Math.cos(dir) * ACC;
			ya = Math.sin(dir) * ACC;
		}else{
			xa = 0;
			ya = 0;
		}

		if(dist < FIRE_DISTANCE){
			fcd -= s;

			if(fcd < 0){
				fire = 1;
				fireDir = LcMath.dir(x, y, Game.p.x + Game.p.xs * 0.75, Game.p.y + Game.p.ys * 0.75);
				fcd = Math.random() * 3 + 2;
			}
		}

		// avoid planets
		var pln = null;
		for(p in Game.planets){
			if(LcMath.distP(x, y, p.x, p.y) < INFECT_DISTANCE + p.r){
				pln = p;
			}
		}
		if(pln != null){
			var dir = LcMath.dir(pln.x, pln.y, x, y);
			xa = Math.cos(dir) * ACC;
			ya = Math.sin(dir) * ACC;
		}

		// avoid members
		var mi = swrm.member.indexOf(this) + 1;
		for(i in mi...swrm.member.length){
			var m = swrm.member[i];
			if(LcMath.distP(m.x, m.y, x, y) < AVOID_RADIUS * 2){
				var dir = LcMath.dir(m.x, m.y, x, y);
				xa += Math.cos(dir) * ACC;
				ya += Math.sin(dir) * ACC;
			}
		}

		// avoid nearby bullet
	}

	public inline function updateDisengaged(s:Float, c:CanvasRenderingContext2D){
		if(swrm.inf != null){
			xs = swrm.inf.xs;
			ys = swrm.inf.ys;

			//var dist = LcMath.distP(x, y, swrm.inf.x, swrm.inf.y) - swrm.inf.r;
			//var infDist = dist - INFECT_DISTANCE;
			//var infDir = LcMath.dir(x, y, swrm.inf.x, swrm.inf.y);
			

			// move to next target (or stay)
			
			

			// avoid swarm members (raise or lower - give way to counter clockwise) 
		}else{
			// return to swarm
		}
	}

	public function check(b:Bullet) {
		if(health > 0 && aabb.check(b.aabb) && LcMath.distP(x, y, b.x, b.y) < RADIUS + Bullet.RADIUS){
			health--;
			
			if(!engaged){
				swrm.engage();
			}

			return true;
		}
		return false;
	}
}