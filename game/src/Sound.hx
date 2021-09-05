package;

class Sound{
	public static inline function shoot(){
		ZzFX.zzfx(1.02,.05,399,.01,0,.02,1,1.98,0,.3,0,0,0,0,7,0,0,.71,.02,0);
	}

	public static inline function burst(){
		ZzFX.zzfx(1,.05,11,0,.01,.19,4,1.63,-53,-44,-632,.29,0,0,-0.6,0,0,1,.09,.01);
	}

	public static inline function hit(){
		ZzFX.zzfx(1.15,.05,628,0,.01,.17,4,1.57,0,-47,402,.02,0,0,72,.5,0,.04,.01,0);
	}
	
	public static inline function laser(v:Float = 1){
		ZzFX.zzfx(1.99 * v,.05,152,0,.19,.05,3,.62,52,0,0,0,0,0,215,0,.23,1,0,.05);
	}
	
	public static inline function explode(){
		ZzFX.zzfx(1,.05,188,0,.12,.21,4,2.23,0,.3,0,0,0,1,0,.7,0,.9,.08,.03);
	}

	public static inline function playerExplode(v:Float = 1){
		ZzFX.zzfx(1.28 * v,.05,606,0,.39,.96,3,2.6,0,0,0,0,0,.7,0,.8,.18,.89,0,.06);
	}
}