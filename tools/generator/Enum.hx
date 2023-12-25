package tools.generator;

class Enum {
	public static function getString(json:Dynamic):String {
		var file:String = '';
		file += 'package rbxhaxe.enums;\n';
		file += 'import rbxhaxe.EnumItem;\n\n';
		file += '@:native("RBXEnum.${json.Name}")\n';
		file += 'extern class ${json.Name} {\n';
		var items:Array<Dynamic> = json.Items;
		for (item in items)
			file += '\tpublic static var ${item.Name}:EnumItem;\n';
		file += '}';
		return file;
	}
}