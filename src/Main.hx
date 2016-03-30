package;

import sys.io.File;
import sys.io.FileOutput;
import sys.FileSystem; 

using StringTools;

class Main {

	private var NAME : String = "HxJsonDef";
	private var VERSION : String = "0.0.2";
	/**
	 * 0.0.2 - fixed Array with objects
	 * 0.0.1 - initial release
	 */
	
	private var str = '';
	private var isLazy : Bool = true;
	private var isComment : Bool = false;

	private var filePath = '';
	private var isFileSet : Bool = false;

	private var path:String;
	private var fileName:String;

	private var typeDefMap : Map<String, Array<String>> = new Map<String, Array<String>>();

	function new(?args : Array<String>) : Void
	{
		var args : Array<String> = args;
		if(args.length > 0 && args[0].indexOf('/') != -1){
			filePath = args[0];
			isFileSet = isValidJson(filePath);
		}

		if (!isFileSet){
			Sys.println('ERROR :: Sorry I need a .json file to convert');
			showHelp();
			return;
		}

		// [mck] validate path?
		// [mck] validate if file exists



		var tmpArr = filePath.split('/');
		fileName = validFileName(tmpArr[tmpArr.length-1].split(".")[0]);
		path = filePath.substring(0,filePath.lastIndexOf("/")+1);

		Sys.println('$NAME :: start converting "${fileName}.json"');

		// trace( "path: " + path );
		// trace( "fileName: " + fileName );


		// trace( "Sys.executablePath(): " + Sys.executablePath() );
		// trace( "Sys.getCwd(): " + Sys.getCwd() );
		// var path = Sys.executablePath();
		// var fin = sys.io.File.getContent(path + fname);

		init(filePath);

		Sys.println('$NAME :: done!\n');

	}



	private function init(file:String):Void
	{
		var content;
		var json;
		try{
			content = sys.io.File.getContent(file);
			json  = haxe.Json.parse(content);
		} catch (e:Dynamic) {
			Sys.println('ERROR :: this path in incorrect: ' + file);
			return ;
		}

		// [mck] start everything from here
		convert2Typedef('${capString(fileName)}Obj', content);

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

		Sys.println('$NAME :: write data to "AST${fileName}.hx" ...');

		write(fileName, str);
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
			readJson(typeName,pjson[0],tab);
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
					store = whatForSortArray(varName,Reflect.field(pjson,varName),tab);

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


	function whatForSortArray(varName:String, value:Array<Dynamic>, tab:String = '\t'):String
	{
		var xc = '';
		var type : String = 'Dynamic';
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

	private function showHelp () : Void {
		Sys.println('
${NAME} (version $VERSION)

how to use: 
neko ${NAME.toLowerCase()} \'path/to/folder/foobar.json\'

	-help : show this help
');
	}

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
			'\n * from : ${filePath}' + 
			'\n * '+
			'\n * AST = Abstract Syntax Tree'+
			'\n * '+
			'\n * Note:'+
			'\n * If you profide a .json there should be no null values'+
			'\n * comments in this document show you the values that need to be changed!'+
			'\n * '+
			'\n * Some (backend)-developers choose to hide empty/null values, you can add them:'+
			'\n * \t\t@optional var _id : Int;'+
			'\n * '+
			'\n * Name(s) that you possibly need to change:'+
			'$temp'+
			'\n */'+
			'\n';
		}

		return str;
	}

	// ____________________________________ misc ____________________________________

	private function isValidJson(filePath:String):Bool
	{
		return (filePath.indexOf(".json") != -1);
	}

	private function validFileName(name:String):String
	{
		return name.replace("-", "");
	}

	private function capString(str:String):String
	{
		var tempstr = '';
		tempstr = str.substring(0,1).toUpperCase() + str.substring(1,str.length);
		return tempstr;
	}

	// ____________________________________ write file ____________________________________

	private function write(name:String, data:String):Void
	{
		// var temp = Sys.executablePath().split('/');
		// temp.pop();

		// var _path = temp.join("/") + '/AST${name}.hx';
		var _path = path + '/AST${name}.hx';
		var f:FileOutput = File.write(_path,false);
		f.writeString(data);
		f.close();
	}

	static public function main(){
		var app = new Main(Sys.args());
	}
}
