module EBJB_BCInputSkills
  # Build filename
  FINAL   = "../../build/EBJB_BCInputSkills.rb"
  # Source files
  TARGETS = [
	"src/Script_Header.rb",
    "src/BattleCommands_Config.rb",
    "src/Game Objects/Game_BattleAction.rb",
	"src/Game Objects/Game_Battle_Commands.rb",
    "src/Misc Objects/UsableItemFilter.rb",
	"src/Scenes/Scene_BattleCommands.rb",
    "src/Scenes/Scene_Battle.rb",
	"src/User Controls/UCInputIcon.rb",
	"src/User Interface/Color.rb",
    "src/User Interface/Vocab.rb",
	"src/Windows/Window_InputSkill.rb",
  ]
end

def ebjb_build
  final = File.new(EBJB_BCInputSkills::FINAL, "w+")
  EBJB_BCInputSkills::TARGETS.each { |file|
    src = File.open(file, "r+")
    final.write(src.read + "\n")
    src.close
  }
  final.close
end

ebjb_build()
