package;

/**
 * Generated with json2hxdef on 2016-03-28 12:32:34
 * from : /Volumes/Data HD/Users/matthijs/Documents/workingdir/haxe/hxjsondef/bin/example/test.json
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

typedef TestObj =
{
	var glossary :
	{
		var GlossDiv :
		{
			var GlossList :
			{
				var GlossEntry :
				{
					var GlossDef :
					{
						var para : String;
						var GlossSeeAlso : Array<String>;
					};
					var GlossSee : String;
					var SortAs : String;
					var ID : String;
					var Acronym : String;
					var GlossTerm : String;
					var Abbrev : String;
				};
			};
			var title : String;
		};
		var title : String;
	};
};
