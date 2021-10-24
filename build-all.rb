module EBJB_BattleCommands_Addons
  # Build filename
  FINAL   = "build/EBJB_BattleCommands_Addons.rb"
  # Wilcard match to run every build ruby script for each addon
  BUILD_PATTERN = "addons/*/build.rb"
  # Build files
  BUILDS = [
	"build/EBJB_BCJump.rb",
  ]
end

def ebjb_build
  # Keep original working directory
  orig = __dir__
  Dir.glob(EBJB_BattleCommands_Addons::BUILD_PATTERN).each { |file|
    Dir.chdir File.dirname(file)
    load File.basename(file)
  }
  # Reset to the original working directory
  Dir.chdir orig
  final = File.new(EBJB_BattleCommands_Addons::FINAL, "w+")
  EBJB_BattleCommands_Addons::BUILDS.each { |file|
    src = File.open(file, "r+")
    final.write(src.read + "\n")
    src.close
  }
  final.close
end

ebjb_build()