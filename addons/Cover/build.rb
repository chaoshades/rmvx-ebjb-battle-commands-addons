module EBJB_BCCover
  # Build filename
  FINAL   = "../../build/EBJB_BCCover.rb"
  # Source files
  TARGETS = [
	"src/Script_Header.rb",
    "src/BattleCommands_Config.rb",
    "src/Game Objects/Game_BattleAction.rb",
    "src/Game Objects/Game_Battler.rb",
    "src/Scenes/Scene_Battle.rb",
    "src/User Interface/Vocab.rb",
  ]
end

def ebjb_build
  final = File.new(EBJB_BCCover::FINAL, "w+")
  EBJB_BCCover::TARGETS.each { |file|
    src = File.open(file, "r+")
    final.write(src.read + "\n")
    src.close
  }
  final.close
end

ebjb_build()
