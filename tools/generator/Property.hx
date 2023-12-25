package tools.generator;

class Property {
	public static function getString(json:Dynamic):String {
		var type:String = '';

		if (!(json.Tags == null || !json.Tags.contains('NotScriptable')))
			return '';

		if (json.MemberType == 'Event')
			type = 'RBXScriptSignal';
		else if (json.MemberType == 'Callback')
			type = 'Function';
		else if (json.ValueType.Category == 'Enum')
			type = 'EnumItem';
		else if (json.ValueType.Category == 'Primitive')
			type = switch(json.ValueType.Name) {
				case 'bool': 'Bool';
				case 'string': 'String';
				case 'int' | 'int64': 'Int';
				case 'float' | 'double': 'Float';
				default: 'kys';
			}
		else if (json.ValueType.Category == 'Class' || json.ValueType.Category == 'DataType')
			type = json.ValueType.Name == 'Content' || json.ValueType.Name == 'ProtectedString' ? 'String' : json.ValueType.Name;

		return 'public var ${json.Name}:$type;';
	}
}