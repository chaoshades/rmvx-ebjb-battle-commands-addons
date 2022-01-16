module EBJB_BCMorphRevert
  # Build filename
  FINAL   = "../../build/EBJB_BCMorphRevert.rb"
  # Source files
  TARGETS = [
	"src/Script_Header.rb",
    "src/BattleCommands_Config.rb",
	"src/BattleSystem_Config.rb",
    "src/Game Objects/Game_Actor.rb",
	"src/Game Objects/Game_BattleAction.rb",
	"src/Game Objects/Game_Battle_Commands.rb",
	"src/Game Objects/Game_Party.rb",
    "src/Misc Objects/UsableItemFilter.rb",
    "src/Scenes/Scene_BattleCommands.rb",
	"src/Scenes/Scene_Battle.rb",
	"src/Sprites Objects/Spriteset_Battle.rb",
    "src/User Interface/Vocab.rb",
	"src/Windows/Window_ActorCommand.rb",
	"src/Windows/Window_AutoBattle_Command.rb",
  ]
end

def ebjb_build
  final = File.new(EBJB_BCMorphRevert::FINAL, "w+")
  EBJB_BCMorphRevert::TARGETS.each { |file|
    src = File.open(file, "r+")
    final.write(src.read + "\n")
    src.close
  }
  final.close
end

ebjb_build()
