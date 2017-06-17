# Creating and managing scenes

## Creating a scene
Method one: on the main menu select __File-->New scene__

![new-scene-main-menu](scene-managing/new-scene-main-menu.png)

Method two: click the create menu in **Assets** to create a new scene.

![new-scene-assets-menu](scene-managing/new-scene-assets-menu.png)

## Saving a scene
Method one: use keyboard shortcut __Ctrl + S__ (Windows) or __Command + S__ (Mac)

Method two: on the main menu select __File-->Save scene__

![save-scene-main-menu](scene-managing/save-scene-main-menu.png)

## Switching scenes
Double click the scene that you want to open in **Assets**.

## Change the policy of auto releasing assets from previous scene

In a large game where you have many scenes, as the engine continues to load different scenes, the memory usage will continue to increase. Besides using API such as `cc.loader.release` to accurately release unused assets, we can also use scene's auto releasing feature. To enable auto releasing, select the desired scene in **Assets** panel, then change the "Auto Release Assets" property in **Properties** panel, the property is flase by default.<br>
When switching from current scene to the next scene, if current scene disabled the auto releasing, then all assets (directly or indirectly) referenced by current scene (except loaded dynamically in scripts) will not release **by default**. On the other hand, if enable the auto releasing, then these assets will release **by default**.

> Known issues: The texture referenced by the plist of the particle system is not automatically released. If you want to automatically release the particle texture, remove the texture information from the plist and use the Texture property of the particle component to assign the texture.

### Prevent auto releasing for some specifed assets

With the auto releasing enabled for a scene, if some of the scene assets are referenced in user script, these references will become invalid once scene switched, and is easy to get wrong. Or if you called the `cc.game.addPersistRootNode` method on a scene node to keep it preserved to the next scene, but all the scene assets used by the node or its child nodes will still be released, so these assets can not correctly used in the next scene any more. To prevent these assets from being released automatically, you can use `cc.loader.setAutoRelease` or `cc.loader.setAutoReleaseRecursively` to preserve them.

## Change the policy of scene loading

Select the scene in **Assets** panel, you will see the "Async Load Assets" property in **Properties** panel, the property is flase by default.

### Disable Async Load Assets

When loading a scene, if its "Async Load Assets" is set to false, all its dependent assets (including recursive dependents) will be load and the scene will launch after loaded completely.

### Enable Async Load Assets

When loading a scene, if its "Async Load Assets" is set to true, all its dependent textures, audios and particles will be load lazily after scene launched, this would increase the scene loading speed significantly.<br>
However, the players may see some assets rendered one by one after scene launched, and when a new GUI displayed in the screen, some elements in the GUI may rendered later, so this loading mode is better for web games.<br>
In this mode, to display the entire scene faster, you can make the undisplayed rendering components (such as Sprite) keep inactive from the beginning.

> The depended assets for Spine and TiledMap will always loaded before scene launch.

<hr>

Continue on to read about [Textures](sprite.md).
