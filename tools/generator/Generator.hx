package tools.generator;

import haxe.Http;
import haxe.Json;
import haxe.io.Output;

using StringTools;

class Generator {
	private static final hashEndpoint:String = 'http://setup.roblox.com/versionQTStudio';
	private static final jsonEndpoint:String = 'http://setup.roblox.com/%s-API-Dump.json';

	private static function getJson(cb:Dynamic->Void) {
		var request:Http = new Http(hashEndpoint);

		request.onData = (data) -> {
			request.url = jsonEndpoint;
			request.url = request.url.replace('%s', data);
			request.onData = (jsonData) -> {
				cb(Json.parse(jsonData));
			}
			request.request(false);
		}

		request.onError = (msg) -> {
			Sys.println('error! $msg');
			Sys.exit(1);
		}

		request.request(false);
	}

	public static function generate() {
		try sys.FileSystem.deleteDirectory(Util.getGayPath('rbxhaxe')) catch(_) {}
		sys.FileSystem.createDirectory(Util.getGayPath('rbxhaxe'));
		sys.FileSystem.createDirectory(Util.getGayPath('rbxhaxe/enums'));
		Sys.println('requesting api json ');
		var out = Sys.stdout();

		sys.thread.Thread.create(() -> {
			var gayIndex:Int = 0;

			try {
				while (out != null) {
					out.writeString('\r');
					Sys.sleep(0.5);
					gayIndex++;
					gayIndex %= Util.loadThingyStuff.length;
					out.writeString(Util.loadThingyStuff[gayIndex]);
					out.flush();
				}
			} catch(_) return;
		});

		getJson((data) -> {
			Sys.println('found !!');
			out = null;
			Sys.sleep(0.5);
			var classes = cast(data.Classes, Array<Dynamic>);
			var enums = cast(data.Enums, Array<Dynamic>);
			for (thingy in classes) if (thingy.Name == 'Instance') classes.remove(thingy); 

			Sys.println('creating classes...');
			var outt = Sys.stdout();
			for (thingy in 0...classes.length) {
				sys.io.File.saveContent(Util.getGayPath('rbxhaxe/${classes[thingy].Name}.hx'), Class.getString(classes[thingy]));
				createProgressBar(outt, thingy / classes.length, 20);
			}

			outt.writeString('\n');

			Sys.println('creating enums...');
			for (thingy in 0...enums.length) {
				sys.io.File.saveContent(Util.getGayPath('rbxhaxe/enums/${enums[thingy].Name}.hx'), Enum.getString(enums[thingy]));
				createProgressBar(outt, thingy / enums.length, 20);
			}

			outt.writeString('\n');

			Sys.println('finalizing...');
			var files:Array<String> = sys.FileSystem.readDirectory(Util.getGayPath('include'));
			for (filee in 0...files.length) {
				sys.io.File.saveContent(Util.getGayPath('rbxhaxe/${files[filee]}'), sys.io.File.getContent(Util.getGayPath('include/${files[filee]}')));
				createProgressBar(outt, filee / files.length, 20);
			}
		});
	}

	private static function createProgressBar(output:Output, percentage:Float, length:Int) {
		output.writeString('\r');
		output.writeString('[');

		var progress = percentage * length;
		for (i in 0...length)
			output.writeString((i < progress ? '=' : ' '));

		output.writeString(']');

		output.writeString(' ${Util.round(percentage, 1) * 100}%');
		output.flush();
	}
}