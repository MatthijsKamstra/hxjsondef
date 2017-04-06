# HxJsonDef

![](icon.png)

HxJsonDef is command-line app/macro/class written in [Haxe](http://www.haxe.org) that helps you quickly define a typedef from some arbitrary `.json`

I found a gist written in ruby that does the same (written by [Justin Donaldson](https://gist.github.com/jdonaldson/1454243)) and it inspired to write it in Haxe/Neko.

## JSON Values

There are some rules you have to keep in mind.
For the conversion it best **NOT** to use `null` as a value.
It will be automatically converted to `Dynamic`, but if you know what the value will be; remove `null` and replace with one of the values described below.

JSON values can be:

- A number (integer or floating point `1` / `1.1`)
- A string (in double quotes `"...."`)
- A Boolean (`true` or `false`)
- An array (in square brackets `[...]`)
- An object (in curly braces `{...}`)
- null

[http://www.w3schools.com/json/json_syntax.asp](source)




## Haxelib

How to get this working?


You might want to update and/or correct the externs: install this repo locally

```bash
haxelib dev hxjsondef path/to/folder/src
```

Or use the developers version / cutting edge: this git repo

```bash
haxelib git jsonhxdef https://github.com/MatthijsKamstra/jsonhxdef
```

And don't forget to add it to your build file

```bash
-lib jsonhxdef
```



## Usage

You choose what works best for you:

- Initialization [macro](#macro) in your build file
- [haxelib run](#haxerun)
- [neko](#neko)
- via [class](#class)
- [online](http://matthijskamstra.github.io/hxjsondef/)

<a href="#macro"></a>
### Macro

Install the lib and add this to your `build.hmxl`

```haxe
--macro hxjsondef.macro.AutomaticJsonDef.build('bin/example','src/ast')
```

First param is the source folder of the jsons, the second param is the "export" folder

Remember this is done **every** time you build. And the `.hx` are automaticly overwritten so any changes to that file are gone.

**NOTE: this macro needs more love, so let me know what would work better.**


<a href="#haxerun"></a>
### Haxelib run

Install the lib and use your terminal to generate a `.hx` file based upon a `.json` file.

```bash
cd path/to/folder
haxelib run jsonhxdef 'filename.json'
```

And next to the `filename.json ` there will be the converted `ASTfilename.hx` file.

You need to send the file you want to change. I might consider creating it for folders as well. Just let me know. Create an issue or a pull request.

<a href="#neko"></a>
### neko

- Download this repo
- Open your terminal
- `cd ` to the correct folder (where hxjsondef is located: `/hxjsondef/bin/`)

```
neko jsonhxdef '/Volumes/path/to/foobar.json'
```

And next to the `foobar.json` there will be the converted `ASTfoobar.hx` file.

See two json file converted in the [example folder](bin/example)

<a href="#class"></a>
### class

Add lib to `build.hxml`

```bash
-lib jsonhxdef
```

Example code

```haxe
var str = '{
	"id": 1,
	"name": "A green door",
	"price": 12.50,
	"tags": ["home", "green"]
}';

var hxjsondef = new Hxjsondef();
hxjsondef.fileName = 'foo';
trace(hxjsondef.convert('foobar', str));

```



## source

- <http://haxe.org/manual/type-system-typedef.html>
- <http://haxe.org/manual/types-structure-json.html>
- <http://www.w3schools.com/json/>
- <https://gist.github.com/jdonaldson/1454243>
