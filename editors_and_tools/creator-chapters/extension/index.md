# Extend the editor
Extension of the Cocos Creator editor is achieved by adding plugin packages to `~/.CocosCreator/packages`.
The Cocos Creator plugins follow the package designing method of the node.js community, which describes your plugins using the __package.json__ document.

## Structure

The structure of a plugin package is generally as follows:

```
MyPackage
  |--(optional)panel
  |   |--mypanel.html
  |   |--(optional)mypanel.js
  |   |--(optional)mypanel.css
  |--(optional)assets
  |     |--my-asset
  |       |--my-asset-inspector.html
  |--main.js
  |--package.json
```

The above package includes the general structure of the whole plugin package:

 - __main.js__: This is the entry document of the plugin package. In the initial phase of the plugin package, the loading of plugins will be implemented by running this entry document.
 - __package.json__: This is a file containing a description of the plugin package, which records the main content of the package, panel information, etc. Within the entire plugin package, it's the crucial document that can be loaded and unloaded.
 - __panel__: This is the panel folder. If you want to define your tool set by yourself, then you need to start from the panel folder.
 - __assets__: This is the resource folder. If you want to define your resource extension scheme by yourself, then you need to start from the resource folder.

## Detailed introduction to the package.json document

Every package needs a __package.json__ document to describe its function. Only in this way can the Cocos Creator editor know
what extensions this package needs and load them correctly. It's worth mentioning that, although the definition of __package.json__ on many fields is similar to
that of the npm package in node.js, they are still used for different products. Therefore, packages downloaded from the npm community cannot be directly put
into Cocos Creator and function as plugins.

Here's a simple package document description:

```json
{
  "name": "demo-simple",
  "version": "0.0.1",
  "description": "Simple Demo",
  "author": "Cocos Creator",
  "main": "main.js",
  "menus": {
    "Examples/Simple": {
      "message": "demo-simple:open"
    }
  }
}
```

Explanations:

 - __name__ String - defines the package name; the package name is unique and is associated with the name you used to login on the official website server
 - __version__ String - version number. [semver](http://semver.org/) format is recommended to manage your package version
 - __description__ String (optional) __ a short phrase describing what the package does
 - __author__ String (optional) - package author
 - __build__ Boolean (optional) - whether to use third-party tools to code this package or not
 - __hosts__ Object (optional) - host version; normally our host is Cocos Creator; by defining the host version, you can pre-test if the current Cocos Creator version can load this package
 - __main__ String (optional) - entry document
 - __dependencies__ Object (optional) - dependency list; the dependency lists of other packages can be written here; Cocos Creator will help you load other packages according to the dependency lists

## Entry document

After defining the __package.json__ document, the entry document `main.js` needs to be written next. An entry document is generally as follows:

```javascript
module.exports = {
  load () {
    // implement when package is loaded correctly
  },

  unload () {
    // implement when package is unloaded correctly
  }
};
```

## More contents

Currently, the plugin system is not officially open. There still are some tests and documental works that need to be finished. The whole plugin system will be opened step by step.
The developers through the use of plugins are developing Cocos Creator's main menu, tool panel, user-defined resource and other contents.

Coming soon!


The above package includes the general structure of the whole plugin package:

 - `main.js`: This is the entry document of the plugin package. In the initial phase of the plugin package, the loading of plugins will be implemented by running this entry document.
 - `package.json`: This is the descriptive document of the plugin package, which records the main content of this package, panel information, etc. It's the key document that can be loaded and unloaded in the entire plugin package.
 - `panel`: This is the panel folder. If you want to define your tool set by yourself, then you need to start from the panel folder.
 - `assets`: This is the resource folder. If you want to define your resource extension scheme by yourself, then you need to start from the resource folder.

## Detailed introduction to package.json document

Every package needs a `package.json` document to describe its function. Only in this way can the Cocos Creator editor know
what extensions this package needs and load the extensions correctly. It's worth mentioning that, though the definition of `package.json` on many fields is similar to
that of the npm package in node.js, they still are used for different products. Therefore, packages downloaded from the npm community can not be directly put
into Cocos Creator and function as plugins.

Here's a simple package document description:

```json
{
  "name": "demo-simple",
  "version": "0.0.1",
  "description": "Simple Demo",
  "author": "Cocos Creator",
  "main": "main.js",
  "menus": {
    "Examples/Simple": {
      "message": "demo-simple:open"
    }
  }
}
```

Explanations:

 - `name` String - defines the package name; the package name is unique in the set, which is associated with the name you used to login on the official website server
 - `version` String - version number. [semver](http://semver.org/) format is recommended to manage your package version
 - `description` String (optional) - describe what the package does with one line
 - `author` String (optional) - package author
 - `build` Boolean (optional) - whether use third-party tool to code this package or not
 - `hosts` Object (optional) - host version; normally our host is Cocos Creator; by defining the host version, one can pre-test if the current Cocos Creator version can load this package
 - `main` String (optional) - entry document
 - `dependencies` Object (optional) - dependency list; the dependency lists of other packages can be written here; Cocos Creator will help you load other packages according to dependency lists

## Entry document

After defining the descriptive document, the entry document `main.js` needs to be written next. An entry document is generally as follows:

```javascript
module.exports = {
  load () {
    // implement when package is loaded correctly
  },

  unload () {
    // implement when package is unloaded correctly
  }
};
```

## More contents

Currently, the plugin system is not officially open. There still are some tests and documental works need to be finished. The whole plugin system will be opened step by step.
Let developers develop Cocos Creator's main menu, tool panel, user-defined resource and other contents by plugins.

Coming soon!
