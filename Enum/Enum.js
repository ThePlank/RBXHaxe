const strStream = require('string-to-stream');

function writeLine(str, line) { return str + line + "\n"; }

module.exports = class Class {   
	constructor(json) {
		this.Name = json.Name;
		this.rawJson = json;
		this.Items = [];
		this.ItemsJson = json.Items;
	}

	getReadStream() {
		let file = "package rbxhaxe.enums;\n";
		file = writeLine(file, `import rbxhaxe.EnumItem;`)
		file = writeLine(file, `@:native("RBXEnum.${this.Name}")`)
		file = writeLine(file, `extern class ${this.Name} {`);
		for (var i = 0; i<this.ItemsJson.length; i++) {
			file = writeLine(file, `\tpublic static var ${this.ItemsJson[i].Name}:EnumItem;`);
		}
		file = writeLine(file, "}");
		return strStream(file);
	}
}