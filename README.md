## Nike Engine 
Play The Original game here [Newgrounds](https://www.newgrounds.com/portal/view/770371) [Itch.io](https://ninja-muffin24.itch.io/funkin)

### Every Modification Or If You Recreate This It HAS To Be Open Source

IF YOU WANT TO COMPILE THE GAME YOURSELF, CONTINUE READING!!! 



### Installing the Required Programs

First, you need to install Haxe and HaxeFlixel. I'm too lazy to write and keep updated with that setup (which is pretty simple). 
1. [Install Haxe 4.2.5](https://haxe.org/download/version/4.2.5/)
2. [Install HaxeFlixel](https://haxeflixel.com/documentation/install-haxeflixel/) after downloading Haxe
3. [Install git-scm](https://git-scm.com/downloads) after downloading HaxeFlixel

Other installations you'd need are the additional libraries, a fully updated list will be in `Project.xml` in the project root. Currently, these are all of the things you need to install:
```
haxelib install flixel
haxelib install flixel-addons
haxelib install flixel-ui
haxelib install hscript
haxelib install newgrounds
haxelib git polymod https://github.com/larsiusprime/polymod.git
haxelib git discord_rpc https://github.com/Aidan63/linc_discord-rpc
haxelib git hxCodec https://github.com/polybiusproxy/hxCodec
haxelib git crashdumper http://github.com/larsiusprime/crashdumper
haxelib git flixel-addons https://github.com/HaxeFlixel/flixel-addons  <--Optional to fix transitions bug in songs with zoomed-out cameras
```

You should have everything ready for compiling the game! Follow the guide below to continue!

### Compiling game
NOTE: If you see any messages relating to deprecated packages, ignore them. They're just warnings that don't affect compiling

If Building On Windows Please Install these tools
* MSVC v142 - VS 2019 C++ x64/x86 build tools
* Windows SDK (10.0.17763.0)

### Building the game in release mode
```
lime build mac
lime build windows
lime build linux
```
### Building the game in debug mode
```
lime build mac -debug
lime build windows -debug
lime build linux -debug
```
You can run the game from the file under export/release/The platform you built on/bin
