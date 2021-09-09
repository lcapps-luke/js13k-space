package;

import js.lib.Math;
import js.html.CanvasRenderingContext2D;
import math.AABB;

class TutText{
	private static inline var FADE_TIME:Float = 0.5;

	private var time:Float = 0;

	private var text:Array<String>;
	private var d:AABB;

	private var tw:Float = -1;
	private var th:Float = -1;

	public function new(text:Array<String>, x:Float, y:Float, w:Float, h:Float) {
		this.text = text;
		this.d = new AABB(x, y, w, h);
	}

	public function update(s:Float, c:CanvasRenderingContext2D){
		time += s;

		c.globalAlpha = Math.min(1, time / FADE_TIME);

		c.font = "42px sans-serif";
		c.fillStyle = "#FFF";

		if(tw == -1){
			for(t in text){
				tw = Math.max(tw, c.measureText(t).width);
			}
			th = text.length * 48;
		}

		var ya = d.y + d.h / 2 - th / 2;
		for(t in text){
			c.fillText(t, d.x + d.w / 2 - tw / 2, ya);
			ya += 48;
		}

		c.globalAlpha = 1;
	}
}