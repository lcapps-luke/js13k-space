package;

import ptcl.PtclSys;
import js.html.svg.ImageElement;
import enemy.Enemy;
import enemy.Swarm;
import math.LcMath;
import math.AABB;
import planet.Planet;
import js.html.CanvasRenderingContext2D;

class Game {
	public static inline var GRAVITY:Float = 1000;
	private static inline var VIEW_MARGIN:Float = 100;
	private static inline var ZOOM_SPEED:Float = 0.25;
	private static inline var SPAWN_SIZE_INCR:Float = 0.2;
	private static inline var SPAWN_SIZE_CAP:Int = 10;
	private static inline var SYSTEM_RADIUS:Float = 13000;
	private static inline var SPAWN_TIME_MIN:Float = 20;
	private static inline var SPAWN_TIME_VAR:Float = 10;

	public static var c(default, null):CanvasRenderingContext2D;
	public static var p(default, null):Player;
	@:native("pl")
	public static var planets(default, null):Array<Planet>;
	public static var pBlt(default, null):Array<Bullet>;
	public static var eSwm(default, null):Array<Swarm>;

	public static var v(default, null):AABB;
	public static var zoom(default, null):Float = 2;
	@:native("zt")
	public static var zoomTarget:Float = zoom;

	private static var minimap:Minimap;

	private static var spawnTimer:Float = 5;
	private static var spawnSize:Float = 3;

	private static var bg:Array<Bg>;

	public static var img(default, null):Map<String,ImageElement>;
	private static var msk:Mask = new Mask();
	private static var gameOver:Bool = false;
	private static var statsText:Array<String> = null;

	private static var ptcl = new Array<PtclSys>();
	private static var tut = new Array<TutText>();
	private static var tutStage:Int = 0;
	private static var tutProg:Float = 0;
	private static var restartTimer:Float = 0;
	private static var restartRegion:AABB;

	@:native("i")
	public static function init(c:CanvasRenderingContext2D, img:Map<String, ImageElement>) {
		Game.c = c;
		Game.img = img;

		restartRegion = new AABB(c.canvas.width * 0.33, c.canvas.height * 0.69, c.canvas.width * 0.34, c.canvas.height * 0.12);
	}

	@:native("r")
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

		bg = [new Bg(0.01, 10, 1, 1), new Bg(0.02, 5, 1, 2)];

		tut = [
			new TutText(["Move:", "W,A,S,D / ←,→,↑,↓", "or", "👆 (left side)"], 0, 0, c.canvas.width / 2, c.canvas.height),
			new TutText(["Shoot:", "🖰", "or", "👆 (right side)"], c.canvas.width / 2, 0, c.canvas.width / 2, c.canvas.height)
		];

		Stats.reset();
		statsText = null;
		gameOver = false;

		msk.start(0.5, true);
		restartTimer = 0;
	}

	@:native("u")
	public static function update(s:Float) {
		updateSpawns(s);

		Stats.update(s);

		/**
		 *  background
		 */
		c.fillStyle = "#000";
		c.fillRect(0, 0, c.canvas.width, c.canvas.height);

		bg[0].update(c, v.cX(), v.cY());
		bg[1].update(c, v.cX(), v.cY());

		
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
			Stats.swarmKilled();
			eSwm.remove(lastDead);
		}

		var lastDead = null;
		for(p in ptcl){
			if(!p.update(s, c)){
				lastDead = p;
			}
		}
		if(lastDead != null){
			ptcl.remove(lastDead);
		}

		c.restore();

		minimap.update(c);
		msk.update(s, c);

		if(gameOver){
			c.font = "48px sans-serif";
			c.fillStyle = "#FFF";
			var txt = "Game Over";
			c.fillText(txt, c.canvas.width / 2 - c.measureText(txt).width / 2, 94);

			c.font = "32px sans-serif";
			var maxWidth:Float = -1;
			var height = statsText.length * 48;
			for(s in statsText){
				maxWidth = Math.max(maxWidth, c.measureText(s).width);
			}

			var ya = c.canvas.height / 2 - height / 2;
			for(s in statsText){
				c.fillText(s, c.canvas.width / 2 - maxWidth / 2, ya);
				ya += 48;
			}

			if(restartTimer > 1){
				var over = restartRegion.contains(Ctrl.mx, Ctrl.my);

				c.font = "48px sans-serif";
				c.fillStyle = "#FFF";
				txt = over ? "-RESTART-" : "RESTART";
				c.fillText(txt, c.canvas.width / 2 - c.measureText(txt).width / 2, c.canvas.height * 0.75);

				if(Ctrl.justReleased && over){
					Main.restart();
				}
			}else{
				restartTimer += s;
			}
		}


		if(tutStage < 2){
			if((tutStage == 0 && Ctrl.acc > 0) || (tutStage == 1 && Ctrl.trg)){
				tutProg += s;
			}

			tut[tutStage].update(s, c);

			if(tutProg > 1){
				tutProg = 0;
				tutStage++;
			}
		}
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

		LcMath.shuffle(candidates);

		for(c in candidates){
			var s = spawnForCandidate(c);
			if(s != null){
				s.target(c);
				eSwm.push(s);
				break;
			}
		}
	}

	@:native("ist")
	private static function isTargeted(p:Planet, full:Bool = true):Bool {
		for(s in eSwm){
			if(s.inf == p || (full && s.infTarget == p)){
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


	public static function respawn() {
		msk.start(0.5, false, function(){
			var candidates = new Array<Planet>();
			for(p in planets){
				if(p.hasAlive() && !isTargeted(p, true)){
					candidates.push(p);
				}
			}

			if(candidates.length > 0){
				p = new Player();
				LcMath.shuffle(candidates);
				var spawnPlanet = candidates[0];

				var dir = Math.random() * (Math.PI * 2);
				p.x = spawnPlanet.x + Math.cos(dir) * spawnPlanet.r;
				p.y = spawnPlanet.y + Math.cos(dir) * spawnPlanet.r;

				msk.start(0.5, true);
			}else{
				//GAME OVER
				gameOver = true;
				if(statsText == null){
					statsText = Stats.makeText();
				}
			}
		});
	}

	public static inline function emitParticles(sys:PtclSys){
		ptcl.push(sys);
	}
}
