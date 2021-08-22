package enemy;

import math.LcMath;
import math.AABB;
import js.html.CanvasRenderingContext2D;

class Enemy{
	private static inline var RADIUS:Float = 15;
	private static inline var AVOID_RADIUS:Float = RADIUS * 3;
	public static inline var INFECT_DISTANCE:Float = 100;
	private static inline var MAX_SPEED:Float = 400;

	public var x:Float;
	public var y:Float;
	private var health:Int;
	private var swrm:Swarm;
	private var engaged:Bool = false;
	private var xs:Float = 0;
	private var ys:Float = 0;

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

		if(engaged){
			updateEngaged(s, c);
		}else{
			updateDisengaged(s, c);
		}

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
		// TODO move toward player (avoiding planets)
		// avoid nearby bullet
		// start fire sequence when nearby (and not in cooldown) [cooldown = rand(3) + 2 seconds]
		// fire sequence: 0.5 sec charge time - 0.5 sec damage time
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
			engaged = true;
			return true;
		}
		return false;
	}
}