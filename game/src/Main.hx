package;

import js.html.FocusEvent;
import js.Browser;
import js.html.CanvasRenderingContext2D;
import js.html.CanvasElement;

class Main {
	private static var canvas:CanvasElement;
	public static var c:CanvasRenderingContext2D;

	public static var lastFrame:Float = 0;
	public static var focusReset:Bool = false;

	public static function main() {
		canvas = cast Browser.window.document.getElementById("c");

		Browser.window.document.body.onresize = onResize;
		onResize();

		Ctrl.init(Browser.window, canvas);

		Game.init(canvas.getContext2d());
		Game.restart();

		Browser.window.requestAnimationFrame(update);

		Browser.window.onfocus = function(e:FocusEvent){
			focusReset = true;
		};
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

		Ctrl.update();
		Game.update((s - lastFrame) / 1000);
		lastFrame = s;
		Browser.window.requestAnimationFrame(update);
	}
}
