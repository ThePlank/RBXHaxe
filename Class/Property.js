module.exports = class Class {
	constructor(json) {
		this.RawJson = json;
		this.Name = json.Name;
		this.Line = "TODO " + json.MemberType;

		if (!(json.Tags == null || !json.Tags.includes("NotScriptable"))) {
			this.Line = null;
			return;
		}

		if (json.MemberType == "Event") {
			this.Line = "public var " + json.Name + ":" + "RBXScriptSignal" + ";";
			return;
		}

		if (json.MemberType == "Callback") {
			this.Line = "public var " + this.Name + ":Function;";
			return;
		}

		if (json.ValueType.Category == "Enum") {
			this.Line = "public var " + this.Name + ":EnumItem;";
			return;
		}

		if (json.ValueType.Category == "Primitive") {
			switch (json.ValueType.Name) {
				case "bool":
					json.ValueType.Name = "Bool";
					break;
				case "string":
					json.ValueType.Name = "String";
					break;
				case "int":
				case "int64":
					json.ValueType.Name = "Int";
					break;
				case "float":
				case "double":
					json.ValueType.Name = "Float";
					break;
				default:
					console.log("Invalid primitive type: " + json.ValueType.Name);
			}
			this.Line = "public var " + json.Name + ":" + json.ValueType.Name + ";";
			return;
		}

		if (json.ValueType.Category == "Class" || json.ValueType.Category == "DataType") {
			var typeThing = json.ValueType.Name == "Content" || json.ValueType.Name == "ProtectedString" ? 'String' : json.ValueType.Name;
			this.Line = "public var " + json.Name + ":" + typeThing + ";";
			return;
		}

		this.Line = "TODO PRIMITIVE: " + json.ValueType.Category; 
		return;
	}

	getLine() { return this.Line; }
}