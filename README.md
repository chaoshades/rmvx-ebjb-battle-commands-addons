# rmvx-ebjb-battle-commands-addons
Adds new battle commands inspired from popular RPG series (jump, blitz, steal, throw, etc.)

## Table of contents

- [Quick start](#quick-start)
- [Documentation](#documentation)
- [Contributing](#contributing)
- [Creators](#creators)
- [Credits](#credits)

## Quick start

- See [dependencies](#dependencies)
- Each battle command is self-contained within the `src` folder. You need to move into the battle command folder you want.
- If needed, run this command to combine external scripts source into one file. `ruby build-ext.rb`
- Run this command to combine core scripts source into one file. `ruby build.rb`
- Copy the resulting files into your RPG Maker VX project 
  > Watch out ! The external scripts, if there are ones, needs to be before the battle command scripts.

OR

- Run this command to combine every battle command scripts source into one file. `ruby build-all.rb`

OR

- There is an already pre-compiled demo with the classic sample project with every battle commands available.

### Dependencies

The dependencies must be inserted, in the below order, before the scripts of this repo :

- Depends on EBJB_Core : <https://github.com/chaoshades/rmvx-ebjb-core/>
- Depends on EBJB_BattleSystem : <https://github.com/chaoshades/rmvx-ebjb-battle-system/>
- Depends on EBJB_BattleCommands : <https://github.com/chaoshades/rmvx-ebjb-battle-commands/>

## Documentation

### Instruction for usage

All of the configuration available are within the `BATTLECOMMANDS_CONFIG` module.

## Contributing

Still in development...

## Creators

- <https://github.com/chaoshades>

## Credits 

- Kal : Protect Skill
- modern algebra : Mime Skill
- Shanghai Simple Script : Minigame Slot Machine
