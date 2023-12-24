package tools;

class Main {
	public function new() {
		var args:Array<String> = Sys.args();
		args.pop();

		if (args[0] == null) {
			Sys.println(sys.io.File.getContent(Util.getGayPath('ascii.txt')));
			Sys.println('welcome to the rbxhaxe cli, for a list of commands use haxelib run rbxhaxe help');
			return;
		}

		switch(args[0]) {
			case 'help': 
				Sys.println('heres all the commands that are currently in rbxhaxe:');
				Sys.println('help - you are literally using the command rn');
				Sys.println('rebuild - rebuilds the library to use the latest roblox api version');
				Sys.println(':c_:');
				return;
			case ':c_:': Sys.command('start', ['', 'https://raw.githubusercontent.com/ThePlank/RBXHaxe/master/c_.png']); return;
		}
		
		Sys.println('unknown command');
	}

	static public function main() {
		var app = new Main();
	}
}