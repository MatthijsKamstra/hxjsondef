#HxJsonDef

![](icon.png)

HxJsonDef is command-line app/class written in [Haxe](http://www.haxe.org) that helps you quickly define a typedef from some arbitrary `.json`

I found a gist written in ruby that does the same (written by [Justin Donaldson](https://gist.github.com/jdonaldson/1454243)) and it inspired to write it in Haxe/Neko.









### Haxelib


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


```bash
cd path/to/folder
haxelib run jsonhxdef 'filename.json'
```





## How to use

- Download this repo
- Open your terminal
- `cd ` to the correct folder

```
neko jsonhxdef '/Volumes/path/to/twitter.json'
```
And next to the `foobar.json` there will be the converted `ASTfoobar.hx` file.

See two json file converted in the [example folder](bin/example)

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



### source

- <http://haxe.org/manual/type-system-typedef.html>
- <http://haxe.org/manual/types-structure-json.html>
- <http://www.w3schools.com/json/>
- <https://gist.github.com/jdonaldson/1454243>