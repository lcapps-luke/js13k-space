package ptcl;

import js.html.CanvasRenderingContext2D;
import math.AABB;

class PtclGroup implements PtclSys{
	public var aabb(default, null):AABB = new AABB();
	private var ptcl:Array<Ptcl> = new Array<Ptcl>();

	public function new(x:Float, y:Float, factory:Void->Ptcl, qty:Int, radius:Float){
		for(i in 0...qty){
			var p = factory();
			p.getPosition().set(x - radius + Math.random() * (radius * 2), y - radius + Math.random() * (radius * 2));
			ptcl.push(p);
		}
	}

	public function update(s:Float, c:CanvasRenderingContext2D):Bool {
		var hasAlive = false;
		for(p in ptcl){
			if(!p.isAlive()){
				continue;
			}

			p.update(s);

			if(!hasAlive){
				aabb.x = p.getPosition().x - p.getRadius();
				aabb.y = p.getPosition().y - p.getRadius();
				aabb.w = p.getRadius() * 2;
				aabb.h = p.getRadius() * 2;
			}else{
				aabb.addC(p.getPosition().x, p.getPosition().y, p.getRadius());
			}

			hasAlive = true;
		}

		if(hasAlive && Game.inView(aabb)){
			for(p in ptcl){
				if(!p.isAlive()){
					continue;
				}

				p.draw(c);
			}
			c.globalAlpha = 1;
		}

		return hasAlive;
	}
}