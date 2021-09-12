package;

import js.html.CanvasRenderingContext2D;

class Minimap{
	private var x:Float;
	private var y:Float;
	private var r:Float;
	private var ratio:Float;
	private var iconSize:Int;

	public function new(x:Float, y:Float, r:Float, wr:Float){
		this.x = x;
		this.y = y;
		this.r = r;
		this.ratio = r / wr;
		iconSize = Math.round(r * 0.15);
	}

	public function update(c:CanvasRenderingContext2D){
		c.fillStyle = "#AAA";
		c.beginPath();
		c.arc(x, y, r + 16, 0, Math.PI * 2);
		c.fill();
		
		c.fillStyle = "#000";
		c.beginPath();
		c.arc(x, y, r, 0, Math.PI * 2);
		c.fill();

		for(p in Game.planets){
			var pr = Math.max(p.r * ratio, 5);

			c.fillStyle = p.c;
			c.beginPath();
			c.arc(x + p.x * ratio, y + p.y * ratio, pr, 0, Math.PI * 2);
			c.fill();

			if(!p.hasAlive() && p.hasDomes()){
				c.fillStyle = "#FFF";
				c.font = 'bold ${iconSize}px sans-serif';
				var iWh = c.measureText("☠").width / 2;
				c.fillText("☠", x + p.x * ratio - iWh, y + p.y * ratio + iWh);
			}
		}

		drawTriangle(c, x + Game.p.x * ratio, y + Game.p.y * ratio, 8, "#0F0");

		c.fillStyle = "#F00";
		c.font = 'bold ${iconSize}px sans-serif';
		var iWh = c.measureText("⚔").width / 2;
		for(e in Game.eSwm){
			if(e.inf != null){
				c.fillText("⚔", x + e.aabb.cX() * ratio - iWh, y + e.aabb.cY() * ratio + iWh);
			}else{
				drawTriangle(c, x + e.aabb.cX() * ratio, y + e.aabb.cY() * ratio, 8, "#F00");
			}

		}
	}

	private function drawTriangle(c:CanvasRenderingContext2D, x:Float, y:Float, r:Float, s:String){
		c.fillStyle = s;
		c.beginPath();
		c.moveTo(x, y - r);
		c.lineTo(x + r, y + r);
		c.lineTo(x - r, y + r);
		c.lineTo(x, y - r);
		c.fill();
	}
}