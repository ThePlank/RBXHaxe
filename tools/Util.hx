package tools;

import sys.io.Process;

using haxe.io.Path;
using StringTools;

class Util {
	static var gayPath:String = '';
	public static var loadThingyStuff:Array<String> = ['-', '\\', '|', '/', '-', '\\', '|', '/'];

	public static function getGayPath(path:String):String {
		return '$gayPath..\\$path';
	}

	private static function __init__() {
		var process = new Process('haxelib', ['path', 'rbxhaxe']);

		try {
			while (true) {
				var line = process.stdout.readLine().trim();
				if (!line.startsWith('-D')) gayPath = line.addTrailingSlash();
			}	
		} catch(_) {}


		process.close();
	}

	public static function round(number:Float, precision:Int = 2):Float {
    	number *= Math.pow(10, precision);
    	return Math.round(number) / Math.pow(10, precision);
	}
}