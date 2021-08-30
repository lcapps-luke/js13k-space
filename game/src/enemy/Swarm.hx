package enemy;

import math.LcMath;
import js.html.CanvasRenderingContext2D;
import planet.Planet;
import math.AABB;

class Swarm{
	private static inline var INITIAL_SIZE:Float = 100;
	private static inline var OUT_OF_VIEW_TIME:Float = 5;
	public var aabb(default, null):AABB;
	public var member(default, null):Array<Enemy>;
	public var inf(default, null):Planet = null;
	public var infTarget:Planet = null;

	private var alive = 0;
	private var oov:Float = OUT_OF_VIEW_TIME + 1;
	private var inView:Bool = false;

	public function new(qty:Int, x:Float, y:Float, w:Float, h:Float){
		member = new Array<Enemy>();
		aabb = new AABB(x, y, INITIAL_SIZE, INITIAL_SIZE);
		for(i in 0...qty){
			var m = new Enemy(x + Math.random() * w, y + Math.random() * h, 3, this);
			member.push(m);
		}

		alive = qty;
	}

	public function update(s:Float, c:CanvasRenderingContext2D):Bool{
		if(alive == 0){
			return false;
		}

		if(oov > OUT_OF_VIEW_TIME){
			updateOutOfView(s, c);
		}else{
			updateInView(s, c);
		}
		
		oov = Game.inView(aabb) ? 0 : oov + s;

		return alive > 0;
	}

	private inline function updateInView(s:Float, c:CanvasRenderingContext2D){
		if(!inView){  // transition to in view
			// relocate members
			if(inf == null){
				// formation
				var lineSize = Math.floor(Math.sqrt(member.length));
				var xacc = 0;
				var yacc = 0;
				for(m in member){
					m.x = aabb.x + Enemy.AVOID_RADIUS * xacc;
					m.y = aabb.y + Enemy.AVOID_RADIUS * yacc;

					xacc++;
					if(xacc > lineSize){
						yacc++;
						xacc = 0;
					}
				}


			}else{
				// around planet
				var sect:Float = (Math.PI * 2) / alive;
				var sectAcc:Float = 0;
				for(m in member){
					m.x = inf.x + Math.cos(sectAcc) * (inf.r + Enemy.INFECT_DISTANCE);
					m.y = inf.y + Math.sin(sectAcc) * (inf.r + Enemy.INFECT_DISTANCE);
					sectAcc += sect;
				}
			}
			inView = true;
		}

		alive = 0;
		for(m in member){
			if(m.update(s, c)){
				alive++;

				if(alive == 1){
					aabb.copy(m.aabb);
				}else{
					aabb.add(m.aabb);
				}
			}
		}
	}

	private inline function updateOutOfView(s:Float, c:CanvasRenderingContext2D){
		//TODO swarm movement
		if(inView && inf == null){ // transition to out-of-view
			// shrink aabb
			aabb.w = Math.sqrt(member.length) * Enemy.AVOID_RADIUS;
			aabb.h = aabb.w;
		}

		if(inf != null){
			aabb.x = inf.x - (inf.r + Enemy.INFECT_DISTANCE);
			aabb.y = inf.y - (inf.r + Enemy.INFECT_DISTANCE);
			aabb.w = inf.r * 2 + Enemy.INFECT_DISTANCE * 2;
			aabb.h = aabb.w;
		}

		if(infTarget != null){
			var dir = LcMath.dir(aabb.cX(), aabb.cY(), infTarget.x, infTarget.y);
			aabb.x += Math.cos(dir) * Enemy.MAX_SPEED * s;
			aabb.y += Math.sin(dir) * Enemy.MAX_SPEED * s;
			//TODO avoid other planets / swarms

			if(aabb.check(infTarget.aabb)){
				bind(infTarget);
				infTarget = null;
			}
		}

		inView = false;
	}

	public function checkHit(b:Bullet):Bool{
		if(aabb.check(b.aabb)){
			for(m in member){
				if(m.check(b)){
					return true;
				}
			}
		}
		return false;
	}

	public inline function bind(p:Planet){
		inf = p;
	}

	public function engage(){
		for(m in member){
			m.engaged = true;
		}
	}

	public inline function target(p:Planet){
		infTarget = p;
	}
}