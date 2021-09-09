package;

class Stats {
	private static var time:Float = 0;
	private static var swarmsKilled:Int = 0;
	private static var enemiesKilled:Int = 0;
	private static var timesKilled:Int = 0;
	private static var shotsFired:Int = 0;

	public static function reset(){
		time = 0;
		swarmsKilled = 0;
		enemiesKilled = 0;
		timesKilled = 0;
		shotsFired = 0;
	}

	public static inline function update(s:Float){
		time += s;
	}

	public static inline function swarmKilled(){
		swarmsKilled++;
	}

	public static inline function enemyKilled(){
		enemiesKilled++;
	}

	public static inline function playerKilled(){
		timesKilled++;
	}

	public static inline function shotFired(){
		shotsFired++;
	}

	public static function makeText():Array<String>{
		var mins = Math.floor(time / 60);
		var secs = Math.floor(time - (mins * 60));
		

		return [
			'Time Survived: $mins:$secs',
			'Swarms Defeated: $swarmsKilled',
			'Total Enemies Killed: $enemiesKilled',
			'Times Killed: $timesKilled',
			'Shots Fired: $shotsFired'
		];
	}
}
