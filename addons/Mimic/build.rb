module EBJB_BCMimic
  # Build filename
  FINAL   = "../../build/EBJB_BCMimic.rb"
  # Source files
  TARGETS = [
	"src/Script_Header.rb",
    "src/BattleCommands_Config.rb",
    "src/Game Objects/Game_BattleAction.rb",
    "src/Game Objects/Game_Unit.rb",
    "src/Game Objects/Game_Battler.rb",
    "src/Scenes/Scene_Battle.rb",
    "src/User Interface/Vocab.rb",
  ]
end

def ebjb_build
  final = File.new(EBJB_BCMimic::FINAL, "w+")
  EBJB_BCMimic::TARGETS.each { |file|
    src = File.open(file, "r+")
    final.write(src.read + "\n")
    src.close
  }
  final.close
end

ebjb_build()
