module EBJB_BCJump
  # Build filename
  FINAL   = "../../build/EBJB_BCJump.rb"
  # Source files
  TARGETS = [
	"src/Script_Header.rb",
    "src/BattleSystem_Config.rb",
    "src/BattleCommands_Config.rb",
    "src/Game Objects/Game_BattleAction.rb",
    "src/Game Objects/Game_BattleAnimation.rb",
    "src/Game Objects/Game_Battler.rb",
    "src/Scenes/Scene_Battle.rb",
    "src/User Interface/Vocab.rb",
  ]
end

def ebjb_build
  final = File.new(EBJB_BCJump::FINAL, "w+")
  EBJB_BCJump::TARGETS.each { |file|
    src = File.open(file, "r+")
    final.write(src.read + "\n")
    src.close
  }
  final.close
end

ebjb_build()
