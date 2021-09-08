package resource;

import js.Browser;
import js.html.svg.ImageElement;

@:native("Ildr")
class ImageLoader{
	private var img:Map<String, ImageElement>;

	@:native("lc")
	private var loadCount:Int;

	@:native("lcb")
	private var callback:Map<String, ImageElement>->Void;

	public function new(def:Array<Img>, callback:Map<String, ImageElement>->Void) {
		img = new Map<String, ImageElement>();
		loadCount = def.length;
		this.callback = callback;

		for (d in def) {
			var data = "data:image/svg+xml;base64," + Browser.window.btoa(d.d);
			var name = d.n;

			var i:ImageElement = cast Browser.window.document.createElement("img");
			i.onload = loadCallback;
			i.onerror = function() {
				Browser.console.error("Failed to load image resource: " + name);
			}
			i.setAttribute("src", data);

			img.set(name, i);
		}
	}

	@:native("cb")
	private function loadCallback() {
		loadCount--;

		if (loadCount == 0) {
			callback(img);
		}
	}
}