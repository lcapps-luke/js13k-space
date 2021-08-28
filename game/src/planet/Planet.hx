package planet;

import math.AABB;
import math.LcMath;
import js.html.CanvasRenderingContext2D;

class Planet{
	public var x:Float;
	public var y:Float;
	public var r:Float;
	public var m:Float;
	public var c(default, null):String;
	public var aabb(default, null):AABB;

	private var ot:Planet;
	private var ov:Float;
	private var od:Float;
	private var oa:Float;
	public var xs(default, null):Float;
	public var ys(default, null):Float;

	private var domes = new Array<Dome>();

	public function new(x:Float, y:Float, r:Float, m:Float, c:String, domeQty:Int = 3){
		this.x = x;
		this.y = y;
		this.r = r;
		this.m = m;
		this.c = c;
		aabb = new AABB(x - r - Dome.RADIUS, y - r - Dome.RADIUS, r * 2 + Dome.RADIUS * 2, r * 2 + Dome.RADIUS * 2);
		xs = 0;
		ys = 0;

		var dd = (Math.PI * 2) / domeQty;
		var dr = dd * 0.5;
		for(i in 0...domeQty){
			var dp = dd * i + Math.random() * dr;
			domes.push(new Dome(this, dp));
		}
	}

	public function update(s:Float, c:CanvasRenderingContext2D) {
		if(ot != null){
			oa += ov * s;
			xs = x;
			ys = y;
			x = ot.x + Math.cos(oa) * od;
			y = ot.y + Math.sin(oa) * od;
			xs = (x - xs) / s;
			ys = (y - ys) / s;

			aabb.x = x - r - Dome.RADIUS;
			aabb.y = y - r - Dome.RADIUS;
		}

		if(Game.inView(aabb)){
			for(d in domes){
				d.update(s, c);
			}

			c.fillStyle = this.c;
			c.beginPath();
			c.arc(x, y, r, 0, Math.PI * 2);
			c.fill();
		}
	}

	public function orbit(ot:Planet, ov:Float){
		this.ot = ot;
		this.ov = ov;
		oa = LcMath.dir(ot.x, ot.y, x, y);
		od = LcMath.distP(ot.x, ot.y, x, y);
	}
}