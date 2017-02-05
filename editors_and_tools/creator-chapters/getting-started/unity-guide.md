# Unity User Guide

For users who have used Unity3D before, they will find it extremely easy when starting to use Cocos Creator because many concepts are interlinked between the two. However,
there still are some differences between Cocos Creator and Unity3D on some detailed concepts. This document will enumerate the differences
between Cocos Creator and Unity3D to help Unity3D users learn to use Cocos Creator more quickly.

## Abstract

 Cocos Creator | Unity3D | Instruction
 -------- | ------- | ---
 cc.Node | GameObject | Object in the scene. Each object can contain many components
 node.active | gameObject.activeSelf | Set up the activated state of the node itself
 node.activeInHierarchy | gameObject.activeInHierarchy | Check the activated state of the node in hierarchy
 node.parent | transform.parent |
 node.position | transform.position | Position in Cocos Creator is in the local coordinate system, but in Unity3D it's in the world coordinate system
 node.rotation | transform.rotation | Rotation in Cocos Creator is in the local coordinate system, but in Unity3D it's in the world coordinate system
 node.scale | transform.localScale |
 cc.find(path, refNode) | transform.Find(path), GameObject.Find(path) | If refNode is blank, find it from the scene root node, otherwise, find it from the refNode node.
 cc.game.addPersistRootNode(node) | Object.DontDestroyOnLoad(gameObject) |
 cc.Component | Component | Component
 comp.node | comp.gameObject |
 comp.onLoad() | comp.Awake() |
 comp.start() | comp.Start() |
 comp.update(dt) | comp.Update() |
 comp.lateUpdate(dt) | comp.LateUpdate() |
 obj.destroy() | Object.Destroy(obj) | obj is the concrete example of cc.Object (normally it is: node, component or asset)
 cc.isValid(obj) | obj != null | Judge if cc.Object is effective (normally it is: node, component or asset)

 - The API of Firball use camelCase. The first letter of the method and variable is in lowercase. The first letter of the category definition is in uppercase.
 - The callback of Firball follows the style of Node.js, which means the first parameter of the callback is wrong information.

## cc.Node vs GameObject

Node in Cocos Creator equals to GameObject + Transform in Unity3D. In Cocos Creator,
the hierarchical relation of the parent and child nodes is maintained by Node. But in Unity3D, it's in the charge of Transform.

```javascript
// change the parent-child relation
this.node.parent = anotherNode;

// rotate by 20 degrees
this.node.rotation += 20;

// shift by pixcels of (10,10)
this.node.position.x += 10;
this.node.position.y += 10;

// zoom in/out for 1.5 times
this.node.scale.x *= 1.5;
this.node.scale.y *= 1.5;
```

## Coordinate system

`position`, `rotation` and `scale` in cc.Node are both in the local coordinate system. As for Unity3D, its `Position`,
`Rotation` is in the world coordinate system.

In Cocos Creator, if you want to calculate the world coordinate of cc.Node, you can use the following method:

```javascript
// set up the node to the position of (100,100) in world coordinate system
this.node.position = this.node.convertToNodeSpaceAR(cc.v2(100,100));
// this.node.rotation = TODO
```

## cc.Component vs MonoBehaviour

In Cocos Creator, the user defined script is written by extending the cc.Component category. But in Unity3D, it's written by
extending MonoBehaviour. Let's compare a Cocos Creator script with a Unity3D script that has the same functions:

**Unity3D**:

```csharp
public class Foobar : MonoBehaviour {
  public string text = 'Foobar';
  void Start () {
    Debug.Log('Hello ' + text );
  }
  void Update () {}
}
```

**Cocos Creator**:

```javascript
// Foobar.js
cc.Class({
  extends: cc.Component,
  properties: {
    text: 'Foobar',
  },
  onLoad: function () {
    console.log('Hello ' + this.text);
  },
  update: function (dt) {},
});
```

## Property definition

In Cocos Creator, properties are defined in the `properties` field. But in Unity3D, properties are defined as
member variables of MonoBehaviour. Apart from differences in the defining positions, Cocos Creator also imports the concept of the property parameter into the property. These parameters can be used to control
the display method of properties in Inspector, serialization, etc. For detailed parameters, please refer to: [/manual/scripting/attributes]

The following are defining methods of some commonly used properties in Cocos Creator:

```javascript
var MyEnum = cc.Enum({
  Foo: 1,
  Bar: 2,
});

// MyScript.js
var Foobar = require('Foobar');
cc.Class({
  extends: cc.Component,
  properties: {
    // quote other cc.Node
    // in Unity3D, it is defined as: public GameObject otherGameObject;
    otherNode: { default: null, type: cc.Node },

    // quote a concrete example of Foobar Component
    // in Unity3D, it is defined as: public Foobar foobar;
    foobar: { default: null, type: Foobar },

    // do not serialize this property
    // in Unity3D, it is defined as: [System.NonSerialized] public int index = 0;
    index: { default: 0, type: cc.Integer, serializable: false  },

    // define an array
    // in Unity3D, it is defined as: public float[] idList;
    idList: { default: [],  type: cc.Float },

    // define an enumerated category
    // in Unity3D, it is defined as: public MyEnum myEnum = MyEnum.Foo;
    myEnum: { default: MyEnum.Foo,  type: MyEnum },
  }
})
```

## Life cycle

The life cycle of Cocos Creator is basically the same as Unity3D, having only slight differences in the naming:

 Cocos Creator | Unity3D
 -------- | -------
 onLoad | Awake
 start | Start
 update | Update
 lateUpdate | LateUpdate
 onEnable | OnEnable
 onDisable | OnDisable
 onDestroy | OnDestroy

 - When you want to destroy a cc.Object concrete example (such as: node, component or asset), you can use obj.destroy() function.
 - When you want to determine whether a cc.Object concrete example(such as: node, component or asset) is destroyed or not, you can use cc.isValid(node).

## Message

The message system of Cocos Creator uses the transmit&receive mode of dom, which can send a message upward, but you need to sign up for message in Node.
But in Unity3D, messages are realized by going through SendMessage and directly responding to the member function defined in the script.

The following is the transmit&receive mode of message in Cocos Creator:

```javascript
cc.Class({
  extends: cc.Component,

  onLoad: function () {
    this.node.on('hello-foobar', function ( event ) {
      event.stopPropagation();
      console.log('Hello Foobar');
    });
  },

  start: function () {
    this.node.emit('hello-foobar');
  },
})
```

---

Continue on to read about [Project Structure](project-structure.md).
