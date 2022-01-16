module EBJB_BCNature
  # Build filename
  FINAL   = "../../build/EBJB_BCNature.rb"
  # Source files
  TARGETS = [
	"src/Script_Header.rb",
    "src/BattleCommands_Config.rb",
	"src/Game Objects/Game_Actor.rb",
    "src/Game Objects/Game_BattleAction.rb",
	"src/RPG Objects/RPG_Area Addon.rb",
	"src/RPG Objects/RPG_Armor Addon.rb",
	"src/RPG Objects/RPG_Weapon Addon.rb",
    "src/Scenes/Scene_Battle.rb",
    "src/User Interface/Vocab.rb",
  ]
end

def ebjb_build
  final = File.new(EBJB_BCNature::FINAL, "w+")
  EBJB_BCNature::TARGETS.each { |file|
    src = File.open(file, "r+")
    final.write(src.read + "\n")
    src.close
  }
  final.close
end

ebjb_build()
