package;

/**
 * Generated with HxJsonDef (version 0.0.8) on 2017-04-06 10:44:24
 * from : test
 * 
 * AST = Abstract Syntax Tree
 * 
 * Note:
 * If you provide a .json there should be no null values
 * comments in this document show you the values that need to be changed!
 * 
 * Some (backend)-developers choose to hide empty/null values, you can add them:
 * 		@:optional var _id : Int;
 * 
 * Name(s) that you possibly need to change:
 * 		GlossDiv
 * 		GlossDef
 * 		GlossList
 * 		Glossary
 * 		GlossEntry
 * 		TestObjObj
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

typedef TestObjObj =
{
	var glossary : Glossary;
};
