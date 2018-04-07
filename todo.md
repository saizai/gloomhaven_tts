! = slated for next version

These are categorized roughly in order of skill / tool levels required.

# Research

Kingdom Death Monster: Scripted v2 - check out how it handles manual


# Simple but grindy

Put 3-digit ID # of each card in its description
- if ambiguous (e.g. blue vs red designed items), add something to disambiguate the nonstandard one & document in spreadsheet
- if not numbered, start new series and put in spreadsheet


# Layout

Improve layout of ItU setups; make into progressive unlocks
- use entry point tokens
- use special spawn-point & type-per-player-count tokens so scripting can take over spawning, randomization, etc

Lay out all other scenarios

Items & city board:
* put all city-type items into a lockable holder on the city board, separated out to individual cards (for easy search)
* have a separate unlockable holder for reward etc items, again searchable


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




Put help info in description of relevant item, e.g. status tokens, terrain tiles, cards, etc

Remove duplicative / redundant help objects

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
