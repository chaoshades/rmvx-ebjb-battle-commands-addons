module EBJB_BCThrow
  # Build filename
  FINAL   = "../../build/EBJB_BCThrow.rb"
  # Source files
  TARGETS = [
	"src/Script_Header.rb",
    "src/BattleCommands_Config.rb",
    "src/BattleSystem_Config.rb",
	"src/RPG Objects/RPG_Actor Addon.rb",
	"src/Game Objects/Game_Actor.rb",
	"src/Game Objects/Game_BattleAction.rb",
	"src/Game Objects/Game_Battle_Commands.rb",
	"src/Game Objects/Game_BattleAnimation.rb",
	"src/Game Objects/Game_Projectile.rb",
	"src/Game Objects/Game_Party.rb",
	"src/Sprites Objects/Sprite_Projectile.rb",
	"src/Scenes/Scene_BattleCommands.rb",
	"src/Scenes/Scene_Battle.rb",
	"src/Windows/Window_ActorCommand.rb",
	"src/Windows/Window_Throw_Command.rb",
	"src/Windows/Window_BattleThrow.rb",
	"src/Windows/Window_AutoBattle_Command.rb",
    "src/Misc Objects/WeaponFilter.rb",
    "src/User Interface/Vocab.rb",
  ]
end

def ebjb_build
  final = File.new(EBJB_BCThrow::FINAL, "w+")
  EBJB_BCThrow::TARGETS.each { |file|
    src = File.open(file, "r+")
    final.write(src.read + "\n")
    src.close
  }
  final.close
end

ebjb_build()
