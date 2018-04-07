! = slated for next version

These are categorized roughly in order of skill / tool levels required.

# Research

Kingdom Death Monster: Scripted v2 - check out how it handles manual


# Simple but grindy

## In-TTS
Put official 3-digit ID # / map # of each item in its description (e.g. *ID: 123* or *ID: A2*)
  * if ambiguous (e.g. blue vs red designed items), add something to disambiguate the nonstandard one & document in spreadsheet
  * if no official ID, create one in spreadsheet and describe what it is

## Out-of-TTS

Make spreadsheet of info of *all* contents.

Item cards (partially complete)
  * 3-digit ID #s (incl. for items w/ more than one copy)
  * text (corrected w/ errata if any)
  * corrected (boolean) (whether this has been updated with errata from original version)
  * FAQ / errata text (except parts that are edited in)
  * broken down item effects, e.g. column 'heal' value 'self 3'; column 'other' for anything left over

Terrain tiles
  * ID: map coding symbol(s) as below
  * name
  * full rules paragraph, including FAQ / errata

Map tiles (always in canonical orientation, text of map ID is right side up)
  * ID (e.g. A2b)
  * type - *wood* ("man-made wood"), *stone* ("man-made stone"), *cave* ("natural stone"), or *earth*
  * orientation - *horizontal* (bottom of hex is flat) or *vertical* (side of hex is flat)
  * contents, starting from top left corner, using coding system below
  * Example: A2b
      * ID: A2b
      * Type: ice
      * Orientation: vertical
      * Contents:
      `   W-  W-  W-  ]W-  W-
       [W| .   .   .   .   ]W|
          .   .   .   .   .
       W|- [w- w-  w-  w-  W|-`

Scenario maps, using coding system below

Mapmaking key:
* Meta:
  * **(space)** hex separator
  * number of spaces and beginning / end of line spaces are non-semantic, use as desired to make easier to read in fixed width font
  * order within a given hex is non-semantic, e.g. ]# == [#
    * **(newline)** row separator
    * **[** outie tab
    * **]** innie tab
    * **-** half-hex high
    * **|** half-hex wide
      * **|-** quarter tile
    * **.** zero-hex high (for placing features between hex edges)
    * **:** zero-hex wide
* Terrain type:
  * everything assumed to be passable floor unless designated otherwise
  * obstructions (blocks walking and LoS/ranged):
  * **W** wall (total)
  * **w** wall-floor combo (e.g. where straight walls bisect a tile)
    * includes all hexes with any wall in them
  * **** obstacle (blocks walking but not LoS/ranged)
  * **** difficult (2 movement)
  * **** hazardous (permanent half-trap)
  * **$** lootable
  * **^** trap
  * **/** door (including fog)
  * **>** trigger (e.g. pressure plate)
* Features (variants; combinations w/ stuff above)
  * **** altar
  * **** armor (helmet, goggles)
  * **** book(s) (bookcase [obstacle])
  * **** bottle(s)
  * **** boulder
  * **** bones (skeleton, skull)
  * **** cabinet / chest (treasure [lootable])
  * **** coin (stewn coins, purses; token-type coin [lootable])
  * **** coals (hot coals [hazardous])
  * @ barrel
  * **** column (rock column [type: cave])
  * + crate ([obstacle])
  * **** crystal ([obstacle])
  * = drain
  * **** fountain ([obstacle])
  * **** gas cloud (poison gas [trap])
  * ! light (lantern, torch)
  * **** nest
  * **** pit (dark pit [obstacle], spike pit [trap])
  * **** pressure plate (bear trap [trap], pressure plate [trigger])
  * **** rubble
  * **** sarcophagus
  * **** shelf ([obstacle])
  * **** spikes
  * **** stairs (ladder [0-width])
  * **** stalagmite
  * **** table
  * **** totem
  * **** tree (wood pile; stump [size 1 obstacle], full-size tree [adjacent obstacles)
  * % vegetation (planter; bush [obstacle], log [difficult], thorns [hazardous])
  * **** water ([difficult])
  * **** weapon (mace, dagger, sword)
  * ? other
    * e.g.: C1a ??? spotted thing; C2a net; C2b chain
* Scenario coding:
  * **P** player starting point (door symbol)
  * **a** **A** **b** **B** **c** **C** monster spawn points. a, b, c = 2p, 3p, 4p; lower = regular, caps = elite
  * **(numbers 0-9)** progressive unlock codes.
    * **0** is the initially revealed state. **9** is the scenario (successful) conclusion state.
  * **(multiple numbers)** unlock states in which this is visible. When entered / triggered, any states not yet revealed become revealed.
    * E.g. all sections of map that are revealed if door 1 is opened should be labeled with 1. Door 1 itself should be labeled **/01** (since it's visible by default and triggers visibility of section 1).
    * This can also be on triggers, e.g. label a sub-goal card as **>01** to indicate that that sub-goal is visible by default, and triggering it spawns / makes visible all stuff labeled **1**. Or on a pressure plate, or whatever else...
    * Note: these numbers are for coding purposes, and won't always line up exactly with the scenario description.
  * Monsters:
    * ****

Unlock coding example - ItU scenario 3:

There are 4 different zones due to doors, which should be coded 0-3. Two doors are labeled "1" in the scenario document, and scenario text. Those two doors, and the tile with the "1"-labeled scenario text, should all be additionally coded **5**. So clockwise from top left, the doors would be coded as **/015**, **/02**, **/235**, and **/13**.

The scenario goal can't readily be map-coded, so label the scenario goal tile **>09**, and the conclusion, reward, & transition tiles **9**. The scenario goal tile will automatically get a button attached to it (to trigger when complete) that will reveal the scenario completion content when triggered.


### Full scenario coding example - Main Campaign Scenario 1:

Assets:

1. Tile of scenario name and requirements (*not* goal)
2. Tile of scenario goal
3. Tile of scenario introduction text
4. Tile of text labeled as part 1
5. Tile of conclusion text
6. Location 2 map tile
7. Party Achievement: First Steps tile
8. Treasure chest 07


## Layout

Items & city board:
* put all city-type items into a lockable holder on the city board, separated out to individual cards (for easy search)
* have a separate unlockable holder for reward etc items, again searchable

Remove duplicative / redundant help objects (after description-based help has been added)

### Blocked pending data-based info above for auto generation

Lay out scenarios
- use entry point tokens
- use special spawn-point & type-per-player-count tokens so scripting can take over spawning, randomization, etc
- put bottom edge of map at bottom of board as possible
- put monster stat sheets, ability cards w/ mats, monster modifier deck w/ mat above map
- put element tracker to the side of map; delete the round tracker piece unless the scenario calls for it

Lay out all other scenarios


# Content

Cloudify assets from pigneedle, mapmaking, etc, and re-import
Componentize FAQ, put bits where they belong, remove from FAQ object
Fix map tiles that are reversed
Fully re-import & spoiler-minimize scenarios - 1 object per scenario, not per page (i.e. you don't see parts of the next scenario that happen to be printed on the same page in the book), & smaller file sizes too
Modify items that have errata, mark with a symbol to signify errata'd (e.g. euro? dagger?)
Reminder tokens for abilities, statuses, etc (eg shield, retaliate, jump)
Token background for 'immunity to X'


# Scripting

## Basic

Button to control stars effect remotely

Button to replace spawn point & type-per-level tokens with monster of correct type

Element board: end-of-round button to increment counter and decrement elements

City board: add toggle buttons to the board to
* upgrade/downgrade to prosperity level X (default 1; 0 should also be an option, eg for variant campaigns)
  * upgrade: take them from bag, place in appropriate section by type
  * downgrade: remove them from the city board (not elsewhere) into the bag
  * show/hide above buttons (default hide)

Map:
* make prosperity progression track clickable (but pretty, not checkbox buttons)
  * mind FAQ caveat about possibility for temporarily demoted progression
* expose read/write of progression level & prosperity level
* make map tiles clickable (to show completion)
* expose read/write of map state:
  * scenarios list:
    * states:
      * unlocked
      * available (unlocked *and* requirements met)
      * current location
      * failed
      * completed
    * linked from / to (i.e. skip road event)
    * unlocked by (3-digit card # if applicable)
    * requirement conditions


## Advanced


All-in-one weather / background / theme controller

Button to replace terrain tokens with 3d model of correct type (including flooring, walls, etc)

Character & party saver / stager (like Sky Tools Stage, but for the non-board player content)

Mat: char level requirement for item slots (max items = ceil(L/2)); kills; character sheet; battle goal; personal quest; summon minis; envelope; draw/shuffle modifier buttons; tap/untap items if present

Make all side tables work (hide & store objects while not in use)
  * make remote to control them; see e.g. GRID table

End of Round button:
- element board
- shuffle monster abilities if pile has a shufflable
- shuffle modifiers if pile has a shufflable
- flip ID tokens back to number side




Split map/tokens & tools sidebar into 2 pieces
- hide tools into zone visible to color-black (mod) player only (& provide button for mod player to toggle that invisibility)

Fix Kraken drawers so that their stow/hide functions work

Show/hide toggle buttons (copy from e.g. the GRID remote):
- help texts
- map/tokens sidebar
- tools sidebar
- gloomhaven city
- unlockables
- tuckboxes
- map
