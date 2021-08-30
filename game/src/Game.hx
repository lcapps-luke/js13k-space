package;

import enemy.Enemy;
import enemy.Swarm;
import math.LcMath;
import math.AABB;
import planet.Planet;
import js.html.CanvasRenderingContext2D;

class Game {
	public static inline var GRAVITY:Float = 1000;
	private static inline var VIEW_MARGIN:Float = 200;
	private static inline var ZOOM_SPEED:Float = 0.25;
	private static inline var SPAWN_SIZE_INCR:Float = 0.2;
	private static inline var SPAWN_SIZE_CAP:Int = 10;
	private static inline var SYSTEM_RADIUS:Float = 13000;
	private static inline var SPAWN_TIME_MIN:Float = 30;
	private static inline var SPAWN_TIME_VAR:Float = 30;

	public static var c(default, null):CanvasRenderingContext2D;
	public static var p(default, null):Player;
	public static var planets(default, null):Array<Planet>;
	public static var pBlt(default, null):Array<Bullet>;
	public static var eSwm(default, null):Array<Swarm>;

	public static var v(default, null):AABB;
	public static var zoom(default, null):Float = 2;
	public static var zoomTarget:Float = zoom;

	private static var minimap:Minimap;

	private static var spawnTimer:Float = 5;
	private static var spawnSize:Float = 3;

	public static function init(c:CanvasRenderingContext2D) {
		Game.c = c;
	}

	public static function restart(){
		p = new Player();
		p.x = 1500;
		p.y = -1500 - 300;

		pBlt = new Array<Bullet>();
		eSwm = new Array<Swarm>();
		
		planets = new Array<Planet>();
		
		var sun = new Planet(0, 0, 1000, 100000, "#FEE", 0);
		planets.push(sun);

		var g = new Planet(1500, -1500, 300, 5000, "#888", 3);
		g.orbit(sun, 3.14 / 300);
		planets.push(g);

		var gr = new Planet(3000, 3000, 600, 20000, "#0F8", 5);
		gr.orbit(sun, -3.14 / 600);
		planets.push(gr);

		var r = new Planet(-4500, 4500, 900, 30000, "#F88", 8);
		r.orbit(sun, 3.14 / 1000);
		planets.push(r);

		var o = new Planet(-4500, -4500, 500, 30000, "#FF8", 4);
		o.orbit(sun, 3.14 / 1000);
		planets.push(o);

		var b = new Planet(7000, -7000, 900, 30000, "#08F", 10);
		b.orbit(sun, 3.14 / 3600);
		planets.push(b);

		var s = new Planet(6000, -6000, 200, 1000, "#808", 2);
		s.orbit(b, 3.14 / 180);
		planets.push(s);

		v = new AABB(0, 0, c.canvas.width, c.canvas.height);

		var s = new Swarm(1, gr.x - gr.r, gr.y - gr.r, gr.r * 2, gr.r * 2);
		s.bind(gr);
		eSwm.push(s);

		var mmr = c.canvas.height / 8;
		minimap = new Minimap(c.canvas.width  - mmr, mmr, mmr, SYSTEM_RADIUS);
		//new Minimap(c.canvas.width / 2, c.canvas.height - c.canvas.height / 8, c.canvas.height / 8, 8000);
	}

	public static function update(s:Float) {
		updateSpawns(s);

		/**
		 *  background
		 */
		c.fillStyle = "#000";
		c.fillRect(0, 0, c.canvas.width, c.canvas.height);

		
		/**
		 * View
		 */
		v.w = c.canvas.width / zoom;
		v.h = c.canvas.height / zoom;
		var vcx = v.x + v.w / 2;
		var vcy = v.y + v.h / 2;
		var vpd = LcMath.distP(vcx, vcy, p.x, p.y);
		var ms = VIEW_MARGIN / zoom;
		if(vpd > ms){
			var vpa = LcMath.dir(vcx, vcy, p.x, p.y);
			var md = vpd - ms;
			v.x += Math.cos(vpa) * md;
			v.y += Math.sin(vpa) * md;
		}

		if(zoom != zoomTarget){
			var za = ZOOM_SPEED * s;
			if(Math.abs(zoom - zoomTarget) < za){
				zoom = zoomTarget;
			}else{
				zoom += zoom > zoomTarget ? -za : za;
			}
		}

		c.save();
		c.scale(zoom, zoom);
		c.translate(-v.x, -v.y);

		/**
		 * Entities
		 */

		for(p in planets){
			p.update(s, c);
		}

		var lastDead = null;
		for(p in pBlt){
			var alv = p.update(c, s);
			if(!alv){
				lastDead = p;
			}
		}
		pBlt.remove(lastDead);

		p.update(s, c);

		var lastDead = null;
		for(sw in eSwm){
			if(!sw.update(s, c)){
				lastDead = sw;
			}
		}
		if(lastDead != null){
			eSwm.remove(lastDead);
		}

		//View debug
		//c.strokeStyle = "#F00";
		//c.strokeRect(v.x, v.y, v.w, v.h);

		c.restore();
		//TODO HUD / on-screen controls
		minimap.update(c);
	}

	public static inline function inView(o:AABB):Bool{
		return v.check(o);
	}

	public static inline function screenX(x:Float):Float{
		return (x - v.x) * zoom ;
	}

	public static inline function screenY(y:Float):Float{
		return (y - v.y) * zoom  ;
	}

	public static inline function addPlayerBullet(b:Bullet) {
		pBlt.push(b);
	}

	private static inline function updateSpawns(s:Float) {
		spawnTimer -= s;
		if(spawnTimer < 0){
			spawnSwarm();
			
			spawnTimer = SPAWN_TIME_MIN + Math.random() * SPAWN_TIME_VAR;
			spawnSize = Math.min(spawnSize + SPAWN_SIZE_INCR, SPAWN_SIZE_CAP);
		}
	}

	private static inline function spawnSwarm() {
		// find unengaged planet
		var candidates = new Array<Planet>();
		for(p in planets){
			if(p.hasAlive() && !isTargeted(p)){
				candidates.push(p);
			}
		}

		LcMath.suffle(candidates);

		for(c in candidates){
			var s = spawnForCandidate(c);
			if(s != null){
				s.target(c);
				eSwm.push(s);
				break;
			}
		}
	}

	private static function isTargeted(p:Planet):Bool {
		for(s in eSwm){
			if(s.inf == p || s.infTarget == p){
				return true;
			}
		}
		return false;
	}

	private static inline function spawnForCandidate(c:Planet):Swarm {
		// calculate angle of attack
		// create swarm

		var initialAngle = LcMath.dir(0, 0, c.x, c.y);
		var sx:Float = Math.cos(initialAngle) * SYSTEM_RADIUS;
		var sy:Float = Math.sin(initialAngle) * SYSTEM_RADIUS;

		var swarmDiameter = Math.sqrt(spawnSize) * Enemy.AVOID_RADIUS;
		return new Swarm(Math.floor(spawnSize), sx, sy, swarmDiameter, swarmDiameter);
	}

}
