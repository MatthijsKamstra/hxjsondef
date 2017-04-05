package;

/**
 * Generated with HxJsonDef (version 0.0.7) on 2017-04-05 22:44:04
 * from : test0
 * 
 * AST = Abstract Syntax Tree
 * 
 * Note:
 * If you profide a .json there should be no null values
 * comments in this document show you the values that need to be changed!
 * 
 * Some (backend)-developers choose to hide empty/null values, you can add them:
 * 		@:optional var _id : Int;
 * 
 * Name(s) that you possibly need to change:
 * 		Obj
 * 		Glossary
 * 		Test0ObjObj
 */

typedef Obj =
{
	var para : String;
	var GlossSeeAlso : Array<String>;
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

typedef Test0ObjObj =
{
	var glossary : Glossary;
};
