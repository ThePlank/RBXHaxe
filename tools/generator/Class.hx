package tools.generator;

import tools.generator.*;

class Class {
	private static final imports:Array<String> = ['lua.Table', 'haxe.extern.Rest', 'haxe.Constraints.Function', 'rbxhaxe.*', 'rbxhaxe.enums.*'];
	public static function getString(json:Dynamic) {
		var file:String = '';
		file += 'package rbxhaxe;\n\n';
		for (importt in imports)
			file += 'import $importt;\n';
		file += '\n';

		file += 'extern class ${json.Name}';
		if (json.Superclass != '<<<ROOT>>>')
			file += ' extends ${json.Superclass}';
		file += ' {\n';

		var properties:Array<String> = [];
		var functions:Array<String> = [];

		var memberrrrrs:Array<Dynamic> = json.Members;

		for (member in memberrrrrs) 
			if (member.MemberType == 'Function') functions.push(Function.getString(member, json.Superclass));
			else properties.push(Property.getString(member));

		for (property in properties)
			file += '\t$property\n';
		file += '\n';
		for (functionn in functions) 
			file += '\t$functionn\n';
		file += '}\n';
		return file;
	}
}