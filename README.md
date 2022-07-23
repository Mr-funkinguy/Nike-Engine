## Nike Engine 
Play The Original game here [Newgrounds](https://www.newgrounds.com/portal/view/770371) [Itch.io](https://ninja-muffin24.itch.io/funkin)

### Every Modification Or If You Recreate This It HAS To Be Open Source

IF YOU WANT TO COMPILE THE GAME YOURSELF, CONTINUE READING!!! 



### Installing the Required Programs

First, you need to install Haxe and HaxeFlixel. I'm too lazy to write and keep updated with that setup (which is pretty simple). 
1. [Install Haxe 4.2.5](https://haxe.org/download/version/4.2.5/)
2. [Install HaxeFlixel](https://haxeflixel.com/documentation/install-haxeflixel/) after downloading Haxe

Other installations you'd need are the additional libraries, a fully updated list will be in `Project.xml` in the project root. Currently, these are all of the things you need to install:
```
haxelib install flixel
haxelib install flixel-addons
haxelib install flixel-ui
haxelib install hscript
haxelib install newgrounds
```

You'll also need to install a couple things that involve Gits. To do this, you need to do a few things first.
1. Download [git-scm](https://git-scm.com/downloads). Works for Windows, Mac, and Linux, just select your build.
2. Follow instructions to install the application properly.
3. Run `haxelib git polymod https://github.com/larsiusprime/polymod.git` to install Polymod For Mod Support.
4. Run `haxelib git discord_rpc https://github.com/Aidan63/linc_discord-rpc` to install Discord RPC.
5. Run `haxelib git hxCodec https://github.com/polybiusproxy/hxCodec` to install hxCodec for mp4 support.
6. Run `haxelib git crashdumper http://github.com/larsiusprime/crashdumper` to install CrashDumper So you see your crash logs.

You should have everything ready for compiling the game! Follow the guide below to continue!

At the moment, you can optionally fix the transition bug in songs with zoomed-out cameras.
- Run `haxelib git flixel-addons https://github.com/HaxeFlixel/flixel-addons` in the terminal/command-prompt.


### Compiling game
NOTE: If you see any messages relating to deprecated packages, ignore them. They're just warnings that don't affect compiling

If Building On Windows Please Install these tools
* MSVC v142 - VS 2019 C++ x64/x86 build tools
* Windows SDK (10.0.17763.0)

### Normal building the game
```
lime build mac
lime build windows
lime build linux
```
### building the game in debug
```
lime build mac -debug
lime build windows -debug
lime build linux -debug
```
you can run FNF from the file under export\release\The platform you built on\bin
