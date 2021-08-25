package enemy;

import js.html.CanvasRenderingContext2D;
import planet.Planet;
import math.AABB;

class Swarm{
	private static inline var INITIAL_SIZE:Float = 100;
	private static inline var OUT_OF_VIEW_TIME:Float = 5;
	public var aabb(default, null):AABB;
	public var member(default, null):Array<Enemy>;
	public var inf(default, null):Planet = null;

	private var alive = 0;
	private var oov:Float = 0;
	private var inView:Bool = false;

	public function new(qty:Int, x:Float, y:Float, w:Float, h:Float){
		member = new Array<Enemy>();
		aabb = new AABB(0, 0, INITIAL_SIZE, INITIAL_SIZE);
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
		
		//oov = Game.inView(aabb) ? 0 : oov + s;

		return alive > 0;
	}

	private inline function updateInView(s:Float, c:CanvasRenderingContext2D){
		if(!inView){  // transition to in view
			// relocate members
			if(inf == null){
				// uniform
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

		inView = true;
	}

	private inline function updateOutOfView(s:Float, c:CanvasRenderingContext2D){
		//TODO swarm movement
		if(inView && inf == null){ // transition to out-of-view
			// shrink aabb
		}

		if(inf != null){
			aabb.x = inf.x - (inf.r + Enemy.INFECT_DISTANCE);
			aabb.y = inf.y - (inf.r + Enemy.INFECT_DISTANCE);
			aabb.w = inf.r * 2 + Enemy.INFECT_DISTANCE * 2;
			aabb.h = aabb.w;
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
}