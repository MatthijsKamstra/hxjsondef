#HxJsonDef

![](icon.png)

HxJsonDef is command-line app written in [Haxe](http://www.haxe.org)  that helps you quickly define a typedef from some arbitrary `.json`

I found a gist written in ruby that does the same (written by [Justin Donaldson](https://gist.github.com/jdonaldson/1454243)) and it inspired to write it in Haxe/Neko.

## How to use

- Download this repo  
- Open your terminal  
- `cd ` to the correct folder

```
neko jsonhxdef '/Volumes/path/to/twitter.json'
```
And next to the `.json` there will be the converted `ASTxxx.hx` file.

## JSON Values

There are some rules you have to keep in mind.  
For the conversion it best **NOT** to use null as a value.  
It will be automatically converted to `Dynamic`, but if you know what the value will be; remove the null and replace with a value described below.

JSON values can be:

- A number (integer or floating point)
- A string (in double quotes)
- A Boolean (true or false)
- An array (in square brackets)
- An object (in curly braces)
- null

source: <http://www.w3schools.com/json/json_syntax.asp>



### source

- <http://haxe.org/manual/type-system-typedef.html>
- <http://haxe.org/manual/types-structure-json.html>
- <http://www.w3schools.com/json/>
- <https://gist.github.com/jdonaldson/1454243>