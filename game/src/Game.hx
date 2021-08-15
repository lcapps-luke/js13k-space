package;

import math.LcMath;
import math.AABB;
import planet.Planet;
import js.html.CanvasRenderingContext2D;

class Game {
	private static inline var VIEW_MARGIN:Float = 200;

	public static inline var GRAVITY:Float = 1000;
	public static var c(default, null):CanvasRenderingContext2D;
	public static var p:Player;
	public static var planets:Array<Planet>;

	public static var v:AABB;
	public static var zoom:Float = 2;

	public static function init(c:CanvasRenderingContext2D) {
		Game.c = c;
	}

	public static function restart(){
		p = new Player();
		planets = new Array<Planet>();
		planets.push(new Planet(c.canvas.width / 2, c.canvas.height / 2, 200, 10000));
		planets.push(new Planet(c.canvas.width * 0.75, c.canvas.height * 0.25, 50, 1000));

		v = new AABB(0, 0, c.canvas.width, c.canvas.height);
	}

	public static function update(s:Float) {
		/**
		 *  background
		 */
		c.fillStyle = "#000";
		c.fillRect(0, 0, c.canvas.width, c.canvas.height);

		
		/**
		 * View
		 */
		var vcx = v.x + (v.w / zoom) / 2;
		var vcy = v.y + (v.h / zoom) / 2;
		var vpd = LcMath.distP(vcx, vcy, p.x, p.y);
		var ms = VIEW_MARGIN / zoom;
		if(vpd > ms){
			var vpa = LcMath.dir(vcx, vcy, p.x, p.y);
			var md = vpd - ms;
			v.x += Math.cos(vpa) * md;
			v.y += Math.sin(vpa) * md;
		}

		c.save();
		c.scale(zoom, zoom);
		c.translate(-v.x, -v.y);


		/**
		 * Entities
		 */

		for(p in planets){
			p.update(s, c);
		}

		p.update(s, c);

		//View debug
		//c.strokeStyle = "#F00";
		//c.strokeRect(v.x, v.y, v.w / zoom, v.h / zoom);

		c.restore();
		//TODO HUD / on-screen controls
	}
}
