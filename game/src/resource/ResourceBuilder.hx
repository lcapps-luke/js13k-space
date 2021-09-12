package resource;

#if macro
	import haxe.io.Path;
	import sys.io.File;
	import sys.FileSystem;
	import haxe.macro.Context;
#end

class ResourceBuilder{
	private static inline var IMG_PATH = "res/img/";
	private static inline var IMG_MIN_PATH = "build/res/img/";

	public static macro function build(){
		trace("Building resources...");

		FileSystem.createDirectory(IMG_MIN_PATH);
		cleanDir(IMG_MIN_PATH);

		var images:Array<Img> = new Array<Img>();

		trace("minifying images");
		Sys.command("svgo", [
			"-f", IMG_PATH,
			"-o", IMG_MIN_PATH,
			"-p", "1",
			"--enable", "removeTitle",
			"--enable", "removeDesc",
			"--enable", "removeUselessDefs",
			"--enable", "removeEditorsNSData",
			"--enable", "removeViewBox",
			"--enable", "transformsWithOnePath"]);

		for (f in FileSystem.readDirectory(IMG_MIN_PATH)) {
			var path:Path = new Path(IMG_MIN_PATH + f);
			if (path.ext == "svg") {
				images.push(buildImage(path));
			}
		}

		// Construct resource type
		var c = macro class R {
			public var img:Array<resource.Img> = $v { images };
			public function new() {}
		}

		Context.defineType(c);

		return macro new R();
	}

	#if macro
	private static function cleanDir(dir) {
		for (f in FileSystem.readDirectory(dir)) {
			if (!FileSystem.isDirectory(dir + f)) {
				FileSystem.deleteFile(dir + f);
			}
		}
	}

	private static function buildImage(path:Path):Img {
		trace('building image ${path.file}');
		var content:String = File.getContent(path.toString());

		return {
			n: path.file,
			d: content
		};
	}
	#end
}