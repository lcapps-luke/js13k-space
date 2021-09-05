package enemy;

import math.Line;
import math.LcMath;
import math.AABB;
import js.html.CanvasRenderingContext2D;

class Enemy{
	public static inline var RADIUS:Float = 15;
	public static inline var AVOID_RADIUS:Float = RADIUS * 3;
	public static inline var INFECT_DISTANCE:Float = 200;
	private static inline var AVOID_DISTANCE:Float = INFECT_DISTANCE / 2;
	public static inline var MAX_SPEED:Float = 400;
	private static inline var ACC:Float = 2000;
	private static inline var ENGAGE_DISTANCE:Float = 400;
	private static inline var FIRE_DISTANCE:Float = 600;
	private static inline var LASER_DIST:Float = 1000;
	private static inline var DPS:Float = 2;

	public var x:Float;
	public var y:Float;
	private var xs:Float = 0;
	private var ys:Float = 0;
	private var xa:Float = 0;
	private var ya:Float = 0;

	private var health:Int;
	private var swrm:Swarm;
	public var engaged:Bool = false;
	
	private var fcd:Float = 2;
	private var fire:Float = 0;
	private var fireDir:Float = 0;
	private var laserLine:Line = new Line();
	private var fireSnd:Bool = true;

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

		updateFiring(s, c);

		if(engaged){
			updateEngaged(s, c);
		}else{
			updateDisengaged(s, c);
		}

		// avoid planets
		var pln = null;
		for(p in Game.planets){
			if(LcMath.distP(x, y, p.x, p.y) < AVOID_DISTANCE + p.r){
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
			shoot(Game.p.x + Game.p.xs * 0.75, Game.p.y + Game.p.ys * 0.75, s);
		}

		if(!Game.p.alive){
			engaged = false;
		}
	}

	private function shoot(tx:Float, ty:Float, s:Float){
		fcd -= s;

		if(fcd < 0){
			fire = 1;
			fireDir = LcMath.dir(x, y, tx, ty);
			fcd = Math.random() * 2 + 2;
		}
	}

	private inline function updateFiring(s:Float, c:CanvasRenderingContext2D){
		if(fire > 0){
			fire -= s;
			laserLine.a.set(x, y);
			laserLine.b.set(x + Math.cos(fireDir) * LASER_DIST, y + Math.sin(fireDir) * LASER_DIST);

			if(fire > 0.5){
				// laser
				c.strokeStyle = "#F00";
				c.lineWidth = 1;
				fireSnd = true;
			}else{
				// hit
				c.strokeStyle = "#F00";
				c.lineWidth = 3;

				Game.p.checkHit(laserLine);
				if(fireSnd){
					Sound.laser(calculateShotVolume());
					fireSnd = false;
				}
			}

			c.beginPath();
			c.moveTo(x, y);
			c.lineTo(laserLine.b.x, laserLine.b.y);
			c.stroke();
		}
	}

	public inline function updateDisengaged(s:Float, c:CanvasRenderingContext2D){
		if(swrm.inf != null){
			var dist = LcMath.distP(x, y, swrm.inf.x, swrm.inf.y) - swrm.inf.r;
			var infDist = dist - (INFECT_DISTANCE + swrm.inf.r);

			var tgt = swrm.inf.getClosestDome(this.x, this.y);

			if(infDist > MAX_SPEED || tgt == null){
				// move to surface
				var infDir = LcMath.dir(x, y, swrm.inf.x, swrm.inf.y);
				xa = Math.cos(infDir) * ACC;
				ya = Math.sin(infDir) * ACC;
			}else{
				var dist = LcMath.distP(x, y, tgt.ex, tgt.ey);
				var dir = LcMath.dir(x, y, tgt.ex, tgt.ey);

				if(dist > RADIUS){
					xa = Math.cos(dir) * ACC;
					ya = Math.sin(dir) * ACC;
				}else{
					xa = 0;
					ya = 0;
					xs = swrm.inf.xs;
					ys = swrm.inf.ys;
					shoot(tgt.aabb.cX(), tgt.aabb.cY(), s);

					if(fire > 0 && fire < 0.5){
						tgt.hit(DPS * s);
					}
				}
			}
		}else{
			// return to swarm
			xa = 0;
			ya = 0;
		}
	}

	public function check(b:Bullet) {
		if(health > 0 && aabb.check(b.aabb) && LcMath.distP(x, y, b.x, b.y) < RADIUS + Bullet.RADIUS){
			health--;
			if(health <= 0){
				Sound.explode();
			}else{
				Sound.hit();
			}

			if(!engaged){
				swrm.engage();
			}

			

			return true;
		}
		return false;
	}

	private function debugLine(c:CanvasRenderingContext2D, vx:Float, vy:Float, s:String){
		c.strokeStyle = s;
		c.lineWidth = 1;
		c.beginPath();
		c.moveTo(x, y);
		c.lineTo(x + vx * 10, y + vy * 10);
		c.stroke();
	}

	private function debugLineR(c:CanvasRenderingContext2D, dir:Float, s:String){
		var vx = Math.cos(dir) * 10;
		var vy = Math.sin(dir) * 10;
		debugLine(c, vx, vy, s);
	}

	private inline function calculateShotVolume():Float{
		var pd = LcMath.distP(x, y, Game.p.x, Game.p.y);
		return LcMath.cap(ENGAGE_DISTANCE / pd);
	}
}