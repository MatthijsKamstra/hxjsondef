package;

/**
 * Generated with json2hxdef on 2016-03-28 12:32:34
 * from : /Volumes/Data HD/Users/matthijs/Documents/workingdir/haxe/hxjsondef/bin/example/test0.json
 * 
 * AST = Abstract Syntax Tree
 * 
 * Note:
 * If you profide a .json there should be no null values
 * comments in this document show you the values that need to be changed!
 * 
 * Some (backend)-developers choose to hide empty values, you can add them:
 * 		@optional var _id : Int;
 */

typedef Test0Obj =
{
	var glossary :
	{
		var intArray : Array<Int>;
		var boolean : Bool;
		var int : Int;
		var obj :
		{
			var para : String;
			var GlossSeeAlso : Array<String>;
		};
		var float : Float;
		var string : String;
		var number : Int;
		var stringArray : Array<String>;
	};
};
