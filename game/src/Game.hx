package;

import planet.Planet;
import js.html.CanvasRenderingContext2D;

class Game {
	public static inline var GRAVITY:Float = 1000;
	public static var c(default, null):CanvasRenderingContext2D;
	public static var p:Player;
	public static var planets:Array<Planet>;

	public static function init(c:CanvasRenderingContext2D) {
		Game.c = c;
	}

	public static function restart(){
		p = new Player();
		planets = new Array<Planet>();
		planets.push(new Planet(c.canvas.width / 2, c.canvas.height / 2, 200, 10000));
	}

	public static function update(s:Float) {
		c.fillStyle = "#000";
		c.fillRect(0, 0, c.canvas.width, c.canvas.height);

		for(p in planets){
			p.update(s, c);
		}

		//TODO view aabb

		p.update(s, c);
	}
}
