package;

import js.lib.KeyValue;
import js.html.KeyboardEvent;
import js.html.Window;

class Ctrl{
	public static var dir(default, null):Float;
	public static var acc(default, null):Float;
	public static var aim(default, null):Float;
	public static var trg(default, null):Bool;

	private static var keys:Map<String, Bool>;

	public static function init(w:Window){
		keys = new Map<String, Bool>();

		w.onkeydown = onKeyDown;
		w.onkeyup = onKeyUp;
	}

	private static function onKeyDown(e:KeyboardEvent){
		keys.set(e.code, true);
		update();
	}

	private static function onKeyUp(e:KeyboardEvent){
		keys.set(e.code, false);
		update();
	}


	private static function update(){
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
}