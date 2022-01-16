module EBJB_BCSwordRune
  # Build filename
  FINAL   = "../../build/EBJB_BCSwordRune.rb"
  # Source files
  TARGETS = [
	"src/Script_Header.rb",
    "src/BattleCommands_Config.rb",
    "src/Game Objects/Game_Actor.rb",
    "src/Game Objects/Game_Battler.rb",
    "src/Misc Objects/UsableItemFilter.rb",
    "src/User Interface/Vocab.rb",
  ]
end

def ebjb_build
  final = File.new(EBJB_BCSwordRune::FINAL, "w+")
  EBJB_BCSwordRune::TARGETS.each { |file|
    src = File.open(file, "r+")
    final.write(src.read + "\n")
    src.close
  }
  final.close
end

ebjb_build()
