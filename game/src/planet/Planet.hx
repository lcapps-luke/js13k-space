package planet;

import math.LcMath;
import js.html.CanvasRenderingContext2D;

class Planet{
	public var x:Float;
	public var y:Float;
	public var r:Float;
	public var m:Float;

	private var ot:Planet;
	private var ov:Float;
	private var od:Float;
	private var oa:Float;

	public function new(x:Float, y:Float, r:Float, m:Float){
		this.x = x;
		this.y = y;
		this.r = r;
		this.m = m;
	}

	public function update(s:Float, c:CanvasRenderingContext2D) {
		if(ot != null){
			oa += ov * s;
			x = ot.x + Math.cos(oa) * od;
			y = ot.y + Math.sin(oa) * od;
		}

		c.fillStyle = "#888";
		c.beginPath();
		c.arc(x, y, r, 0, Math.PI * 2);
		c.fill();
	}

	public function orbit(ot:Planet, ov:Float){
		this.ot = ot;
		this.ov = ov;
		oa = LcMath.dir(ot.x, ot.y, x, y);
		od = LcMath.distP(ot.x, ot.y, x, y);
	}
}