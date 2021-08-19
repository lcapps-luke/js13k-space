package;

import math.LcMath;
import js.html.CanvasElement;
import js.html.MouseEvent;
import js.html.KeyboardEvent;
import js.html.Window;

class Ctrl{
	public static var dir(default, null):Float;
	public static var acc(default, null):Float;
	public static var aim(default, null):Float;
	public static var trg(default, null):Bool;

	private static var keys:Map<String, Bool>;
	private static var c:CanvasElement;

	private static var mx:Float = 0;
	private static var my:Float = 0;

	public static function init(w:Window, c:CanvasElement){
		keys = new Map<String, Bool>();

		w.onkeydown = onKeyDown;
		w.onkeyup = onKeyUp;
		c.onmousemove = onMouseMove;
		w.onmousedown = onMouseDown;
		w.onmouseup = onMouseUp;

		Ctrl.c = c;
	}

	private static function onKeyDown(e:KeyboardEvent){
		keys.set(e.code, true);
		updateKeys();
	}

	private static function onKeyUp(e:KeyboardEvent){
		keys.set(e.code, false);
		updateKeys();
	}

	private static function onMouseMove(e:MouseEvent){
		mx = (e.offsetX / c.clientWidth) * c.width;
		my = (e.offsetY / c.clientHeight) * c.height;
	}

	private static function onMouseDown(e:MouseEvent){
		trg = true;
	}

	private static function onMouseUp(e:MouseEvent){
		trg = false;
	}

	private static function updateKeys(){
		var dx = 0;
		var dy = 0;

		if(keys.get("KeyW")){
			dy -= 1;
		}
		if(keys.get("KeyS")){
			dy += 1;
		}
		if(keys.get("KeyA")){
			dx -= 1;
		}
		if(keys.get("KeyD")){
			dx += 1;
		}

		acc = (dx != 0 || dy != 0) ? 1 : 0;
		dir = Math.atan2(dy, dx);
	}

	public static function update()
	{
		var spx = Game.screenX(Game.p.x);
		var spy = Game.screenY(Game.p.y);
		aim = LcMath.dir(spx, spy, mx, my);
	}
}