package;

import js.html.TouchEvent;
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

	public static var mx(default, null):Float = 0;
	public static var my(default, null):Float = 0;
	private static var mTouch:Int = -1;
	public static var justReleased(default, null):Bool = false;

	private static var leftTouch:CtrlTouch = null;
	private static var rightTouch:CtrlTouch = null;
	public static var deadZone:Float = 100;

	public static function init(w:Window, c:CanvasElement){
		keys = new Map<String, Bool>();

		w.onkeydown = onKeyDown;
		w.onkeyup = onKeyUp;
		c.onmousemove = onMouseMove;
		w.onmousedown = onMouseDown;
		w.onmouseup = onMouseUp;

		w.ontouchstart = onTouchStart;
		w.ontouchmove = onTouchMove;
		w.ontouchend = onTouchEnd;
		w.ontouchcancel = onTouchEnd;

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
		justReleased = true;
	}

	private static function onTouchStart(e:TouchEvent){
		for(t in e.changedTouches){
			var tx = ((t.clientX - c.offsetLeft) / c.clientWidth) * c.width;
			var ty = ((t.clientY - c.offsetTop) / c.clientHeight) * c.height;
			
			if(tx < c.width / 2){
				if(leftTouch == null){
					leftTouch = {
						id: t.identifier,
						sx: tx,
						sy: ty,
						cx: tx,
						cy: ty
					};
				}
			}else{
				if(rightTouch == null){
					rightTouch = {
						id: t.identifier,
						sx: tx,
						sy: ty,
						cx: tx,
						cy: ty
					};
				}
			}
		}
	}

	private static function onTouchMove(e:TouchEvent){
		for(t in e.changedTouches){
			var ct:CtrlTouch;

			if(leftTouch != null && leftTouch.id == t.identifier){
				ct = leftTouch;
			}else if(rightTouch != null && rightTouch.id == t.identifier){
				ct = rightTouch;
			}else{
				continue;
			}

			ct.cx = ((t.clientX - c.offsetLeft) / c.clientWidth) * c.width;
			ct.cy = ((t.clientY - c.offsetTop) / c.clientHeight) * c.height;

			mx = ct.cx;
			my = ct.cy;
			mTouch = t.identifier;
		}
	}

	private static function onTouchEnd(e:TouchEvent){
		for(t in e.changedTouches){
			if(leftTouch != null && leftTouch.id == t.identifier){
				leftTouch = null;
				acc = 0;
			}
			if(rightTouch != null && rightTouch.id == t.identifier){
				rightTouch = null;
				trg = false;
			}

			if(t.identifier == mTouch){
				justReleased = true;
			}
		}
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
		if(rightTouch == null){
			var spx = Game.screenX(Game.p.x);
			var spy = Game.screenY(Game.p.y);
			aim = LcMath.dir(spx, spy, mx, my);
		}else{
			//TODO touch aim
			aim = LcMath.dir(rightTouch.sx, rightTouch.sy, rightTouch.cx, rightTouch.cy);
			trg = LcMath.distP(rightTouch.sx, rightTouch.sy, rightTouch.cx, rightTouch.cy) > deadZone;
		}

		if(leftTouch != null){
			if(LcMath.distP(leftTouch.sx, leftTouch.sy, leftTouch.cx, leftTouch.cy) > deadZone){
				acc = 1;
			}else{
				acc = 0;
			}

			dir = LcMath.dir(leftTouch.sx, leftTouch.sy, leftTouch.cx, leftTouch.cy);
		}
	}

	public static function reset(){
		justReleased = false;
	}
}

typedef CtrlTouch = {
	var id:Int;
	var sx:Float;
	var sy:Float;
	var cx:Float;
	var cy:Float;
};