package ptcl;

import js.html.CanvasRenderingContext2D;
import math.Vec;

class SimplePtcl implements Ptcl{
	private var pos:Vec = new Vec();
	private var vel:Vec = new Vec();
	private var radius:Float;
	private var colour:String;
	private var time:Float;
	private var timeTotal:Float;

	public function new(radius:Float, minSpeed:Float, maxSpeed:Float, colour:String, lifeTime:Float){
		this.radius = radius;
		this.colour = colour;
		time = lifeTime;
		timeTotal = lifeTime;

		var dir = Math.random() * (Math.PI * 2);
		var spd = minSpeed + Math.random() * (maxSpeed - minSpeed);
		vel.set(Math.cos(dir) * spd, Math.sin(dir) * spd);
	}

	public function update(s:Float) {
		pos.x += vel.x * s;
		pos.y += vel.y * s;
		time -= s;
	}

	public function draw(c:CanvasRenderingContext2D) {
		c.fillStyle = colour;
		c.globalAlpha = time / timeTotal;
		c.beginPath();
		c.arc(pos.x, pos.y, radius, 0, Math.PI * 2);
		c.fill();
	}

	public inline function getPosition():Vec {
		return pos;
	}

	public inline function getRadius():Float {
		return radius;
	}

	public inline function isAlive():Bool {
		return time > 0;
	}
}