module EBJB_BCMultiSkill
  # Build filename
  FINAL   = "../../build/EBJB_BCMultiSkill.rb"
  # Source files
  TARGETS = [
	"src/Script_Header.rb",
    "src/BattleCommands_Config.rb",
    "src/Game Objects/Game_Battler.rb",
    "src/Scenes/Scene_Battle.rb",
    "src/User Interface/Vocab.rb",
  ]
end

def ebjb_build
  final = File.new(EBJB_BCMultiSkill::FINAL, "w+")
  EBJB_BCMultiSkill::TARGETS.each { |file|
    src = File.open(file, "r+")
    final.write(src.read + "\n")
    src.close
  }
  final.close
end

ebjb_build()
