package;

import js.html.CanvasRenderingContext2D;

class Game {
	public static var c(default, null):CanvasRenderingContext2D;
	public static var p:Player;

	public static function init(c:CanvasRenderingContext2D) {
		Game.c = c;
	}

	public static function restart(){
		p = new Player();
	}

	public static function update(s:Float) {
		p.update(s, c);
	}
}
