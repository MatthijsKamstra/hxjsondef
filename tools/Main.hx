package;

import sys.io.File;
import sys.io.FileOutput;
import sys.FileSystem;

using StringTools;

class Main {

	var filePath = '';
	var isFileSet : Bool = false;

	var path:String;
	var fileName:String;

	var hxjsondef : Hxjsondef;

	function new(?args : Array<String>) : Void
	{
		var args : Array<String> = args;
		if(args.length == 1 && args[0].indexOf('.') != -1){
			filePath = args[0];
			isFileSet = isValidJson(filePath);
		}
		if(args.length == 2 && args[0].indexOf('.') != -1){
			filePath = args[1]+args[0];
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

		hxjsondef = new Hxjsondef();
		hxjsondef.fileName = fileName;

		Sys.println('${Hxjsondef.NAME} :: start converting "${fileName}.json"');

		// trace( "path: " + path );
		// trace( "fileName: " + fileName );


		// trace( "Sys.executablePath(): " + Sys.executablePath() );
		// trace( "Sys.getCwd(): " + Sys.getCwd() );
		// var path = Sys.executablePath();
		// var fin = sys.io.File.getContent(path + fname);

		init(filePath);

		Sys.println('${Hxjsondef.NAME} :: done!\n');

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

		var str = hxjsondef.convert('${capString(fileName)}Obj', content);

		Sys.println('${Hxjsondef.NAME} :: write data to "AST${fileName}.hx" ...');

		write(fileName, str);
	}


	// ____________________________________ info ____________________________________

	private function showHelp () : Void {
		Sys.println('
${Hxjsondef.NAME} (version ${Hxjsondef.VERSION})

how to use:
neko ${Hxjsondef.NAME.toLowerCase()} \'path/to/folder/foobar.json\'

	-help : show this help
');
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
