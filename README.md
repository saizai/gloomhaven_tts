# TTS: Gloomhaven - Complete Setup mod

This repo contains the text-based content of the [Table Top Simulator mod "Gloomhaven - Complete Setup"](https://steamcommunity.com/sharedfiles/filedetails/?id=1340508741).

The goals of the mod, and help wanted, are at [this Reddit thread](https://www.reddit.com/r/Gloomhaven/comments/88prsq/tts_gloomhaven_complete_setup_goals_help_wanted/).

The game's creator, Isaac Childres (cephalofair), explicitly gave his approval to both the mod and its posting on GitHub, via personal email to Sai (@saizai).

**WARNING: This repo contains unmarked spoilers for everything, including secret content.**

## Overview

Most of the mod content consists of images that are re-uploaded to Steam via TTS' cloud manager. The underlying [assets are on Google Drive](https://drive.google.com/drive/folders/1SiXb3u2mJbN-Dg2j3Rb-y5amnRJSXIDc?usp=sharing).

If you would like to contribute by helping set up maps or providing better asset contents, please [contact Sai](https://s.ai/contact) (saizai on Steam).

This repo is primarily intended for creating a DSL and templating system for TTS Lua using tools such as erb, jq, and make, and working on the mod programmatically (rather than just in-TTS).

## Layout

### Next

The files in `next` are the working space for GitHub-based modifications. Please make your changes there (and *only* there).

`party_saver.lua` is a WIP, based on the Sky Tools Stage tool, to save the state of all parts of the table that have to do with the party's state. In final form, it should allow easily saving all and only the "save game" state that would change between parties (with the mod's shipped base state being one such "party"). People should be ale to easily save their state to an object and import it to a different server; load a different party; update to the latest release of the mod and resume (transparently getting everything upgraded from the new release); etc.

### Current

The files in `current` represent the actual current published version of the mod. Do not make changes to it, since they will be overwritten with every release.

`1340508741.json` represents the full compiled version of the mod. This is the only part that TTS actually ships directly.

`workshop text.bbcode` is the text used in the Steam workshop. Note that Steam limits the length to approximately 7700 characters, and only a subset of BBcode is supported (e.g. `[h2]` is not).

`lua` includes Lua code of all assets, including those of 3rd party mod tools, extracted using the [Atom](https://atom.io) editor's TTS Lua package. These are (or should be) all credited in the `workshop text` file to their original source(s).

### WIP

The files in `wip` represent the actual current published version of the [WIP version of the mod](http://steamcommunity.com/sharedfiles/filedetails/?id=1344456817), used by collaborators. Do not make changes to it either. `1344456817.json` works as above.

The WIP version mod contains the most recent work-in-progress iteration, plus work surfaces for staging and working on changes. The release version of the mod is created by simply deleting everything on the work surfaces, checking that the main section is set correctly (e.g. unlockable ).

If you would like access, contact Sai on Steam. Please note that it has major unmarked spoilers lying around in the open on work surfaces.
