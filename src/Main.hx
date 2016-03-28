package;

import sys.io.File;
import sys.io.FileOutput;
import sys.FileSystem; 

class Main {

	private var str = '';
	private var isLazy : Bool = true;
	private var isComment : Bool = false;

	private var filePath = '';
	private var isFileSet : Bool = false;

	private var path:String;
	private var fileName:String;

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


		Sys.println('jsonhxdef :: start');

		var tmpArr = filePath.split('/');
		fileName = tmpArr[tmpArr.length-1].split(".")[0];
		path = filePath.substring(0,filePath.lastIndexOf("/")+1);

		// trace( "path: " + path );
		// trace( "fileName: " + fileName );


		// trace( "Sys.executablePath(): " + Sys.executablePath() );
		// trace( "Sys.getCwd(): " + Sys.getCwd() );
		// var path = Sys.executablePath();
		// var fin = sys.io.File.getContent(path + fname);
		if(isFileSet){
			init(filePath);
		} else {
			init("/Volumes/Data HD/Users/matthijs/Documents/workingdir/haxe/hxjsondef/bin/example/test.json");
			init("/Volumes/Data HD/Users/matthijs/Documents/workingdir/haxe/hxjsondef/bin/example/test0.json");
			init("/Volumes/Data HD/Users/matthijs/Documents/workingdir/haxe/hxjsondef/bin/_test/slack.json");
			init("/Volumes/Data HD/Users/matthijs/Documents/workingdir/haxe/hxjsondef/bin/_test/twitter.json");
		}

		Sys.println('jsonhxdef :: end');

	}



	private function init(file:String):Void
	{
		str = '';
		var content;
		var json;
		try{
			content = sys.io.File.getContent(file);
			json  = haxe.Json.parse(content);
		} catch (e:Dynamic) {
			Sys.println('ERROR :: this path in incorrect: ' + file);
			return ;
		}

		str += headerInfo();

		str += 'typedef ${capString(fileName)}Obj =\n{\n';
		
		readJson(json);
		
		str += '};\n';
		
		write(fileName, str);
	}


	function readJson(pjson:Dynamic, tab:String = '\t')
	{
		// [mck] it's an array
		if(pjson.length != null)
		{
			readJson(pjson[0]);
			return;
		}


		for (i in Reflect.fields(pjson))
		{
			var c = '';
			if(isComment) c = ' // ${i}:${Reflect.field(pjson,i)}';

			switch (Type.typeof(Reflect.field(pjson,i)))
			{

				case TObject: 
					// deeper into the rabit hole
					str += '${tab}var ${i} :\n${tab}{\n';
					readJson(Reflect.field(pjson,i), (tab + '\t'));
					str += '${tab}};\n';
		
				case TClass(String):
					str += '${tab}var ${i} : String;${c}\n';

				case TClass(Array):
					// [mck] is it an Array<String/Int/Bool> or is it an Array<typedef>?
					str += whatForSortArray(i,Reflect.field(pjson,i),tab);

				case TInt:
					str += '${tab}var ${i} : Int;${c}\n';

				case TFloat:
					str += '${tab}var ${i} : Float;${c}\n';

				case TBool:
					str += '${tab}var ${i} : Bool;${c}\n';

				case TNull:
					str += '${tab}var ${i} : Dynamic; // ${i}:${Reflect.field(pjson,i)} // [mck] provide json without `null` values\n';

					// trace(Type.getClassName(Type.getClass(Reflect.field(pjson,i))));
				default : 
					// trace(">>>>>> " + Type.typeof(pjson));
					// trace(">>>>>> " + (Reflect.field(pjson,i)));
					trace("[FIXME] type: " + Type.typeof(Reflect.field(pjson,i)) + ' / ${i}: ' + Reflect.field(pjson,i));
			}

			// trace(i + ":" + Reflect.field(pjson,i));
		}


	}


	function whatForSortArray(i, value:Array<Dynamic>, tab:String = '\t'):String
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
					xc = ' // ${i}:${value[0]} // [FIXME] (array) not sure why you would nest this deep';
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
					xc = ' // ${i}:${value[0]} // [mck] provide json without `null` values';
				}
			
			case TObject:
				type = 'Dynamic';
				if(isComment){
					xc = ' // [FIXME] do something clever with objects';
				} else {
					xc = ' // ${i}:${value[0]} // [FIXME] do something clever with objects';
				}

			default : 
				trace('[FIXME] : ' + Type.typeof(value[0]));

		}

		var c = '';
		if(isComment) c = ' // ${i}:${value[0]}';

		var _str = '${tab}var ${i} : Array<$type>;${c}${xc}\n';
		return _str;
	}

	// ____________________________________ info ____________________________________

	private function showHelp () : Void {
		Sys.println('
jsonhxdef

how to use: 
neko jsonhxdef \'path/to/folder\'

	-help : show this help
');
	}

	private function headerInfo():String
	{
		var str = '';
		str += 'package;';
		if(!isComment){
			str += 
			'\n\n'+
			'/**'+
			'\n * Generated with json2hxdef on ' + Date.now() + 
			'\n * from : ${filePath}' + 
			'\n * '+
			'\n * AST = Abstract Syntax Tree'+
			'\n * '+
			'\n * Note:'+
			'\n * If you profide a .json there should be no null values'+
			'\n * comments in this document show you the values that need to be changed!'+
			'\n * '+
			'\n * Some (backend)-developers choose to hide empty values, you can add them:'+
			'\n * \t\t@optional var _id : Int;'+
			'\n */'+
			'\n\n';
		}

		return str;
	}

	// ____________________________________ misc ____________________________________

	private function isValidJson(filePath:String):Bool
	{
	    return (filePath.indexOf(".json") != -1);
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
