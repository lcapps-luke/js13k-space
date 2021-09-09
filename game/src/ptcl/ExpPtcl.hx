package ptcl;

import js.html.CanvasRenderingContext2D;

class ExpPtcl implements PtclSys{
	private var smoke:PtclGroup;
	private var fire:PtclGroup;
	
	public function new(x:Float, y:Float){
		smoke = new PtclGroup(x, y, smokeFactory, 15, 10);
		fire = new PtclGroup(x, y, fireFactory, 20, 10);
	}

	public function update(s:Float, c:CanvasRenderingContext2D):Bool {
		var alive = smoke.update(s, c) ? 1 : 0;
		alive += fire.update(s, c) ? 1 : 0;
		return alive > 0;
	}

	private function smokeFactory():Ptcl{
		var v = Math.floor(100 + Math.random() * 100);
		return new SimplePtcl(5, 50, 100, 'rgb(255, $v, 0)', 1);
	}

	private function fireFactory():Ptcl{
		var v = Math.floor(100 + Math.random() * 50);
		return new SimplePtcl(5, 100, 250, 'rgb($v, $v, $v)', 2);
	}
}