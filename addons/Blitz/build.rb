module EBJB_BCBlitz
  # Build filename
  FINAL   = "../../build/EBJB_BCBlitz.rb"
  # Source files
  TARGETS = [
	"src/Script_Header.rb",
    "src/BattleCommands_Config.rb",
    "src/Game Objects/Game_BattleAction.rb",
    "src/Misc Objects/BlitzFilter.rb",
    "src/Scenes/Scene_Battle.rb",
    "src/User Interface/Vocab.rb",
  ]
end

def ebjb_build
  final = File.new(EBJB_BCBlitz::FINAL, "w+")
  EBJB_BCBlitz::TARGETS.each { |file|
    src = File.open(file, "r+")
    final.write(src.read + "\n")
    src.close
  }
  final.close
end

ebjb_build()
