package tools.generator;

using StringTools;

class Function {
	public static function getString(json:Dynamic, ?classParent) {
		var returnType:String = parseReturnType(json.ReturnType);

		var line:String = '';

		if (returnType == 'Tuple') {
			var unpackShit:Bool = false;
			line = 'public inline function ${json.Name}(';
			for (i in 0...json.Parameters.length) {
				if (json.Parameters[i].Type.Category == 'Group' && json.Parameters[i].Type.Name == 'Tuple') {
					unpackShit = true;
					line += '${json.Parameters[i].Name}:AnyTable';
				} else {
					line += parseParameter(json.Parameters[i]);
					if (i != json.Parameters.length - 1) line += ', ';
				}
			}
			line += '):AnyTable ';
			line += 'return untyped __lua__(\"{{0}';
			if (classParent == '<<<ROOT>>>') line += '.';
			else line += ':';
			line += '${json.Name}(';
			for (i in 0...json.Parameters.length) {
				if (i == json.Parameters.length - 1)
					if (unpackShit) line += 'unpack({${i + 1}})';
					else line += '{${i + 1}}';
				else 
					line += '{${i + 1}}, ';
			}
			line += ')}\", this';
			for (i in 0...json.Parameters.length)
				line += ', ${json.Parameters[i].Name}';
			line += ');';
		} else {
			line = 'public function ${json.Name}(';
			for (i in 0...json.Parameters.length) {
				line += parseParameter(json.Parameters[i]);
				if (i != json.Parameters.length - 1) line += ', ';
			}
			line += '):$returnType;';
		}

		return line;
	}

	private static function parseReturnType(returnType:Dynamic):String
		return switch(returnType.Category) {
			case 'Primitive':
				switch(returnType.Name) {
					case 'bool': 'Bool';
					case 'string': 'String';
					case 'int' | 'int64': 'Int';
					case 'float' | 'double': 'Float';
					case 'void': 'Void';
					default: 'Void';
				}
			case 'DataType':
				switch(returnType.Name) {
					case 'Objects': 'AnyTable';
					case 'Function': 'Function';
					case 'Content': 'String';
					default: returnType.Name;
				}
			case 'Enum': 'EnumItem';
			case 'Class': (returnType.Name == 'Instance' ? 'Dynamic' : returnType.Name);
			case 'Group':
				switch(returnType.Name) {
					case 'Tuple': 'Tuple';
					case 'Variant': 'Dynamic';
					case 'Array' | 'Map' | 'Dictionary': 'AnyTable';
					default: 'kys';
				}
			default: 'kys';
		}

	private static function parseParameter(param:Dynamic):String {
		var name:String = param.Name;
		var type:String = '';
		if(name == 'function' || name == 'Function') name = 'func';
		if(name == 'override')  name = 'overrideArg';

		var typeName:String = param.Type.Name;
		typeName = typeName.replace('?', '');

		var isOptional:Bool = (param.Type.Name != typeName);

		if (param.Type.Category == 'DataType')
			switch(typeName) {
				case 'OverlapParams' | 'Objects': type = 'AnyTable';
				case 'Function': type = 'Function';
				case 'Content': type = 'String';
				default: type = param.Type.Name;
			}
		else if (param.Type.Category == 'Primitive')
			switch(typeName) {
				case 'bool': type = 'Bool';
				case 'string': type ='String';
				case 'int' | 'int64': type = 'Int';
				case 'float' | 'double': type = 'Float';
			}
		else if (param.Type.Category == 'Group')
			switch(typeName) {
				case 'Tuple': type = 'Rest<Dynamic>';
				case 'Variant': type = 'Dynamic';
				case 'Array' | 'Dictionary': type = 'AnyTable';
			}
		else if (param.Type.Category == 'Class')
			type = typeName;
		else if (param.Type.Category == 'Enum')
			type = 'EnumItem';

		return '${isOptional ? '?' : ''}$name:$type';
	}
}