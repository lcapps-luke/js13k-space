package;

import resource.ResourceBuilder;
import js.html.svg.ImageElement;
import resource.ImageLoader;
import js.html.FocusEvent;
import js.Browser;
import js.html.CanvasRenderingContext2D;
import js.html.CanvasElement;

class Main {
	private static var r(default, null) = ResourceBuilder.build();

	@:native("e")
	private static var canvas:CanvasElement;
	public static var c:CanvasRenderingContext2D;

	@:native("l")
	public static var lastFrame:Float = 0;

	@:native("f")
	public static var focusReset:Bool = false;

	private static var playing:Bool = false;

	public static function main() {
		canvas = cast Browser.window.document.getElementById("c");
		c = canvas.getContext2d();

		Browser.window.document.body.onresize = onResize;
		onResize();

		restart();

		Browser.window.onfocus = function(e:FocusEvent){
			focusReset = true;
		};

		new ImageLoader(r.img, init);

		Browser.window.requestAnimationFrame(update);
	}

	private static inline function init(img:Map<String, ImageElement>){
		Game.init(c, img);
		Menu.loaded = true;
	}

	public static function onResize() {
		var l = Math.floor((Browser.window.document.body.clientWidth - canvas.clientWidth) / 2);
		var t = Math.floor((Browser.window.document.body.clientHeight - canvas.clientHeight) / 2);
		canvas.style.left = '${l}px';
		canvas.style.top = '${t}px';
	}

	public static function update(s:Float) {
		if(focusReset){
			lastFrame = s - 1;
			focusReset = false;
		}

		if(playing){
			Ctrl.update();
			Game.update((s - lastFrame) / 1000);
			Ctrl.reset();
		}else{
			Menu.update((s - lastFrame) / 1000, c);
		}

		lastFrame = s;
		Browser.window.requestAnimationFrame(update);
	}

	public static function restart(){
		playing = false;
		Menu.init(canvas);
		Menu.startCallback = function(){
			Menu.startCallback = null;
			Ctrl.init(Browser.window, canvas);
			playing = true;
			Game.restart();
		};
	}
}
