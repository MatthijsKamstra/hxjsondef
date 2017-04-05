package;

using StringTools;

class Hxjsondef {

	public static var NAME : String = "HxJsonDef";
	public static var VERSION : String = "0.0.7";

	/**
	 * 0.0.7 - haxelib run command
	 * 0.0.6 - @:optional fixed @optional
	 * 0.0.5 - fixed bug with `\n` in String
	 * 0.0.4 - loop through all arrays, chances that it will add optionals // doesn't work
	 * 0.0.3 - external class so it works with js
	 * 0.0.2 - fixed Array with objects
	 * 0.0.1 - initial release
	 */

	private var str = '';
	private var isComment : Bool = false;

	public var fileName(get_fileName, set_fileName):String;
	private var _fileName:String = 'foobar';



	// private var isFileSet : Bool = false;

	// private var path:String;
	// private var fileName:String;

	private var typeDefMap : Map<String, Array<String>> = new Map<String, Array<String>>();


	public function new() {}

	/**
	 * convert this for js
	 *
	 * @param  name    [description]
	 * @param  content [description]
	 * @return         String
	 */
	public function convert(name:String, content:String):String
	{
		// [mck] reset defaults
		str = '';
		typeDefMap = new Map<String, Array<String>>();

		content = content.replace('\n','');

		// [mck] start everything from here
		convert2Typedef('${capString(name)}Obj', content);

		// [mck] create the content for the .hx file
		for (key in typeDefMap.keys())
		{
			var arr = typeDefMap.get(key);
			str += '\ntypedef ${key} =\n{\n';
			for (i in 0 ... arr.length) {
				str += '${arr[i]}\n';
			}

			str += '};\n';
		}

		str = headerInfo() + str;

		return str;
	}

	function convert2Typedef(typeName:String, pjson:String)
	{
		typeDefMap.set(typeName , []);

		readJson(typeName, haxe.Json.parse(pjson));
	}


	function readJson(typeName:String, pjson:Dynamic, tab:String = '\t')
	{
		// [mck] it's an array?
		if(pjson.length != null)
		{
			for (i in 0 ... pjson.length) {
				readJson(typeName,pjson[i],tab);
			}
			// readJson(typeName,pjson[0],tab);
			return;
		}

		for (varName in Reflect.fields(pjson))
		{
			var store = '';
			var c = '';
			if(isComment) c = ' // ${varName}:${Reflect.field(pjson,varName)}';

			switch (Type.typeof(Reflect.field(pjson,varName)))
			{

				case TObject:
					// deeper into the rabit hole
					store = '${tab}var ${varName} : ${capString(varName)};${c}';
					convert2Typedef(capString(varName), haxe.Json.stringify(Reflect.field(pjson,varName)));

				case TClass(String):
					store = '${tab}var ${varName} : String;${c}';

				case TClass(Array):
					// [mck] is it an Array<String/Int/Bool> or is it an Array<typedef>?
					store = whatSortArray(varName,Reflect.field(pjson,varName),tab);

				case TInt:
					store = '${tab}var ${varName} : Int;${c}';

				case TFloat:
					store = '${tab}var ${varName} : Float;${c}';

				case TBool:
					store = '${tab}var ${varName} : Bool;${c}';

				case TNull:
					store = '${tab}var ${varName} : Dynamic; // ${varName}:${Reflect.field(pjson,varName)} // [mck] provide json without `null` values';

					// trace(Type.getClassName(Type.getClass(Reflect.field(pjson,i))));
				default :
					// trace(">>>>>> " + Type.typeof(pjson));
					// trace(">>>>>> " + (Reflect.field(pjson,i)));
					trace("[FIXME] type: " + Type.typeof(Reflect.field(pjson,varName)) + ' / ${varName}: ' + Reflect.field(pjson,varName));
			}

			var arr = typeDefMap.get('${typeName}');
			arr.push(store);
			typeDefMap.set('${typeName}' , arr);

			// trace(i + ":" + Reflect.field(pjson,i));
		}


	}


	function whatSortArray(varName:String, value:Array<Dynamic>, tab:String = '\t'):String
	{
		var xc = '';
		var type : String = 'Dynamic';

		// for (i in 0 ... value.length) {


		switch (Type.typeof(value[0]))
		{
			case TClass(String):
				type = 'String';

			case TClass(Array):
				// I guess I find this just stupid, so won't fix for now
				type = 'Dynamic';
				if(isComment){
					xc = ' // [FIXME] (array) not sure why you would nest this deep';
				} else {
					xc = ' // ${varName}:${value[0]} // [FIXME] (array) not sure why you would nest this deep';
				}

			case TInt:
				type = 'Int';

			case TFloat:
				type = 'Float';

			case TBool:
				type = 'Bool';

			case TNull:
				type = 'Dynamic';
				if(isComment){
					xc = ' // [mck] provide json without `null` values';
				} else {
					xc = ' // ${varName}:${value[0]} // [mck] provide json without `null` values';
				}

			case TObject:
				type = '${capString(varName)}';
				convert2Typedef(capString(varName), haxe.Json.stringify(value[0]));

			default :
				trace('[FIXME] : ' + Type.typeof(value[0]));

		}

		var c = '';
		if(isComment) c = ' // ${varName}:${value[0]}';

		var _str = '${tab}var ${varName} : Array<$type>;${c}${xc}';
		return _str;
	}

	// ____________________________________ info ____________________________________

	private function headerInfo():String
	{
		var temp = '';
		for (key in typeDefMap.keys())
		{
			temp += '\n * \t\t${key}';
		}

		var str = '';
		str += 'package;';
		if(!isComment){
			str +=
			'\n\n'+
			'/**'+
			'\n * Generated with ${NAME} (version ${VERSION}) on ' + Date.now() +
			'\n * from : ${fileName}' +
			'\n * '+
			'\n * AST = Abstract Syntax Tree'+
			'\n * '+
			'\n * Note:'+
			'\n * If you profide a .json there should be no null values'+
			'\n * comments in this document show you the values that need to be changed!'+
			'\n * '+
			'\n * Some (backend)-developers choose to hide empty/null values, you can add them:'+
			'\n * \t\t@:optional var _id : Int;'+
			'\n * '+
			'\n * Name(s) that you possibly need to change:'+
			'$temp'+
			'\n */'+
			'\n';
		}

		return str;
	}

	// ____________________________________ misc ____________________________________

	private function capString(str:String):String
	{
		var tempstr = '';
		tempstr = str.substring(0,1).toUpperCase() + str.substring(1,str.length);
		return tempstr;
	}

	// ____________________________________ getter/setter ____________________________________

	function get_fileName():String {
		return _fileName;
	}
	function set_fileName(value:String):String {
		return _fileName = value;
	}

}
