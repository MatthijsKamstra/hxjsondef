package;

/**
 * Generated with HxJsonDef (version 0.0.2) on 2016-03-30 13:46:28
 * from : /Volumes/Data HD/Users/matthijs/Documents/workingdir/haxe/hxjsondef/bin/example/test.json
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
 * 		GlossDiv
 * 		GlossDef
 * 		GlossList
 * 		TestObj
 * 		Glossary
 * 		GlossEntry
 */

typedef GlossDiv =
{
	var GlossList : GlossList;
	var title : String;
};

typedef GlossDef =
{
	var para : String;
	var GlossSeeAlso : Array<String>;
};

typedef GlossList =
{
	var GlossEntry : GlossEntry;
};

typedef TestObj =
{
	var glossary : Glossary;
};

typedef Glossary =
{
	var GlossDiv : GlossDiv;
	var title : String;
};

typedef GlossEntry =
{
	var GlossDef : GlossDef;
	var GlossSee : String;
	var SortAs : String;
	var ID : String;
	var Acronym : String;
	var GlossTerm : String;
	var Abbrev : String;
};
