package;

/**
 * Generated with HxJsonDef (version 0.0.2) on 2016-03-30 13:46:28
 * from : /Volumes/Data HD/Users/matthijs/Documents/workingdir/haxe/hxjsondef/bin/example/test0.json
 * 
 * AST = Abstract Syntax Tree
 * 
 * Note:
 * If you profide a .json there should be no null values
 * comments in this document show you the values that need to be changed!
 * 
 * Some (backend)-developers choose to hide empty/null values, you can add them:
 * 		@optional var _id : Int;
 * 
 * Name(s) that you possibly need to change:
 * 		Obj
 * 		Test0Obj
 * 		Glossary
 */

typedef Obj =
{
	var para : String;
	var GlossSeeAlso : Array<String>;
};

typedef Test0Obj =
{
	var glossary : Glossary;
};

typedef Glossary =
{
	var intArray : Array<Int>;
	var boolean : Bool;
	var int : Int;
	var obj : Obj;
	var float : Float;
	var string : String;
	var number : Int;
	var stringArray : Array<String>;
};
