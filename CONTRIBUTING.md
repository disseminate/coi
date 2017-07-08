# Contributing

Please make a pull request on a new branch. Branches should be named in the manner of `development/*`. Please adorn commit messages with [gitmoji](https://gitmoji.carloscuesta.me/).

`include`s must be in alphabetical order, unless they conflict. `AddCSLuaFile`s must be in alphabetical order.

All strings that the player sees must be internationalized (see [I18](#I18)).

## Mapping

Use the `coi.fgd` provided in this repository.

### coi_truck

Place these where you want spawnpoints/loot points to be. Players spawn at the back of these. The gamemode will only make enough teams as there are trucks, so keep in mind the desired game size when placing these.

### coi_money

Place these in the vault. You can put any number of these in, as long as there's at least one.

## I18

If you'd like to translate the gamemode, you are welcome! Look at `gamemode/i18/en.lua` as a starting point. The language code (`en`) will be what's displayed, according to the Garry's Mod main menu language selection.