package;

import js.jquery.JQuery;
import js.Browser;
import js.html.TextAreaElement;

class MainJS {

	var inArea : Dynamic;
	var outArea : Dynamic;

	var inTextArea : TextAreaElement;
	var outTextArea : TextAreaElement;

	var hxjsondef : Hxjsondef;

	var jsonExample1 : String = '{\n\t"id": 1,\n\t"name": "A green door",\n\t"price": 12.50,\n\t"tags": ["home", "green"]\n}';
	var jsonExample2 : String = '{\n\t"title": "Product",\n\t"description": "A product from Acme\'s catalog",\n\t"type": "object",\n\t"properties": {\n\t\t"id": {\n\t\t\t"description": "The unique identifier for a product",\n\t\t\t"type": "integer"\n\t\t},\n\t\t"name": {\n\t\t\t"description": "Name of the product",\n\t\t\t"type": "string"\n\t\t},\n\t\t"price": {\n\t\t\t"type": "number",\n\t\t\t"minimum": 0,\n\t\t\t"exclusiveMinimum": true\n\t\t},\n\t\t"tags": {\n\t\t\t"type": "array",\n\t\t\t"items": {\n\t\t\t\t"type": "string"\n\t\t\t},\n\t\t\t"minItems": 1,\n\t\t\t"uniqueItems": true\n\t\t}\n\t},\n\t"required": ["id", "name", "price"]\n}';

	public function new()
	{
		new JQuery( function():Void
		{
			// when document is ready
			// js.Lib.alert('document ready');

			// your magic
			new JQuery('#btn_convert').click(onClick);
			new JQuery('#btn_select').click(onClick);

			new JQuery('#example1').click(onClick);
			new JQuery('#example2').click(onClick);

			inArea = new JQuery('#in_json');
			outArea = new JQuery('#out_hxjson');

			inTextArea = cast (js.Browser.document.getElementById('in_json'), TextAreaElement);
			outTextArea = cast (js.Browser.document.getElementById('out_hxjson'), TextAreaElement);

			hxjsondef = new Hxjsondef();
			hxjsondef.fileName = Browser.location.href;

			convert(jsonExample1);
		});
	}

	function convert ( str )
	{
		inArea.val(str);
		outArea.val(hxjsondef.convert('foobar', str));

		outTextArea.scrollTop = outTextArea.scrollHeight;
		outTextArea.select();
	}

	function selectAll():Void {
		outTextArea.select();
	}

	private function onClick (e:Dynamic) : Void
	{
		var id = e.currentTarget.id;
		switch (id) {
			case "example1": convert(jsonExample1);
			case "example2": convert(jsonExample2);
			case "btn_convert": convert(inArea.val());
			case "btn_select": selectAll();
		}
		e.preventDefault();
	}

	static public function main(){
		var app = new MainJS();
	}
}