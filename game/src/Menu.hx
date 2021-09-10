package;

import js.Browser;
import js.html.MouseEvent;
import js.html.CanvasElement;
import math.AABB;
import js.html.CanvasRenderingContext2D;

class Menu{
	private static var c:CanvasElement;
	private static var bg:Array<Bg>;
	private static var msk:Mask = new Mask();

	public static var startCallback:Void->Void = null;

	private static var playRegion:AABB;
	private static var fullRegion:AABB;

	private static var playOver:Bool = false;
	private static var fullOver:Bool = false;

	public static var active:Bool = false;

	@:native("i")
	public static function init(c:CanvasElement){
		Menu.c = c;
		bg = [new Bg(0.01, 10, 1, 1), new Bg(0.02, 5, 1, 2)];

		playRegion = new AABB(c.width * 0.37, c.height * 0.60, c.width * 0.26, c.height * 0.1);
		fullRegion = new AABB(c.width * 0.37, c.height * 0.77, c.width * 0.26, c.height * 0.1);

		c.onmousemove = onMouseMove;
		c.onclick = onClick;
		msk.start(0.5, true, function(){
			active = true;
		});
	}

	@:native("u")
	public static function update(s:Float, c:CanvasRenderingContext2D) {
		c.fillStyle = "#000";
		c.fillRect(0, 0, c.canvas.width, c.canvas.height);

		bg[0].update(c, 0, 0);
		bg[1].update(c, 0, 0);

		// title
		c.font = "bold 128px sans-serif";
		c.fillStyle = "#F00";
		var txt = "SPACE";
		c.fillText(txt, c.canvas.width / 2 - c.measureText(txt).width / 2, c.canvas.height * 0.25 + 128);

		// play button
		c.font = "bold 48px sans-serif";
		c.fillStyle = "#F00";
		txt = playOver ? "-PLAY-" : "PLAY";
		c.fillText(txt, c.canvas.width / 2 - c.measureText(txt).width / 2, c.canvas.height * 0.67);

		// full screen button
		c.font = "bold 48px sans-serif";
		c.fillStyle = "#F00";
		txt = fullOver ? "-FULL SCREEN-" : "FULL SCREEN";
		c.fillText(txt, c.canvas.width / 2 - c.measureText(txt).width / 2, c.canvas.height * 0.84);

		msk.update(s, c);
	}

	private static inline function onMouseMove(e:MouseEvent){
		if(!active){
			return;
		}

		var mx = (e.offsetX / c.clientWidth) * c.width;
		var my = (e.offsetY / c.clientHeight) * c.height;

		playOver = playRegion.contains(mx, my);
		fullOver = fullRegion.contains(mx, my);
	}

	private static inline function onClick(e:MouseEvent){
		if(!active){
			return;
		}

		var mx = (e.offsetX / c.clientWidth) * c.width;
		var my = (e.offsetY / c.clientHeight) * c.height;
		
		if(fullRegion.contains(mx, my)){
			Browser.window.document.body.requestFullscreen();
		}else if(playRegion.contains(mx, my)){
			active = false;
			msk.start(0.5, false, startCallback);
		}
	}
}