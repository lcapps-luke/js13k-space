package;

import js.html.CanvasRenderingContext2D;

class Mask{
	private var d:Float = 1;
	private var t:Float = 1;
	private var i:Bool = true;
	private var cb:Void->Void = null;
	private var done:Bool = true;

	public function new(){}
	
	public function update(s:Float, c:CanvasRenderingContext2D){
		t += s;
		if(t > d && !done){
			done = true;
			if(cb != null){
				cb();
			}
		}

		if(t > d){
			t = d;
		}

		var a = t / d;
		if(i){
			a = 1 - a;
		}

		if(a > 0){
			c.fillStyle = "#000";
			c.globalAlpha = a;
			c.fillRect(0, 0, c.canvas.width, c.canvas.height);
			c.globalAlpha = 1;
		}
	}

	public function start(d:Float, i:Bool, cb:Void->Void = null){
		this.d = d;
		this.i = i;
		this.cb = cb;
		t = 0;
		done = false;
	}
}