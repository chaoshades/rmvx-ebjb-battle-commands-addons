module EBJB_BCStealMug
  # Build filename
  FINAL   = "../../build/EBJB_BCStealMug.rb"
  # Source files
  TARGETS = [
	"src/Script_Header.rb",
    "src/BattleCommands_Config.rb",
    "src/BattleSystem_Config.rb",
    "src/Game Objects/Game_BattleAction.rb",
    "src/Game Objects/Game_BattleAnimation.rb",
    "src/Game Objects/Game_Enemy.rb",
    "src/Game Objects/Game_Actor.rb",
    "src/RPG Objects/RPG_Enemy Addon.rb",
    "src/RPG Objects/RPG_Weapon Addon.rb",
    "src/RPG Objects/RPG_Armor Addon.rb",
    "src/Scenes/Scene_Battle.rb",
    "src/User Interface/Vocab.rb",
  ]
end

def ebjb_build
  final = File.new(EBJB_BCStealMug::FINAL, "w+")
  EBJB_BCStealMug::TARGETS.each { |file|
    src = File.open(file, "r+")
    final.write(src.read + "\n")
    src.close
  }
  final.close
end

ebjb_build()
