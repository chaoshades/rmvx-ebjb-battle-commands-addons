module EBJB_BCPray
  # Build filename
  FINAL   = "../../build/EBJB_BCPray.rb"
  # Source files
  TARGETS = [
	"src/Script_Header.rb",
    "src/BattleCommands_Config.rb",
  ]
end

def ebjb_build
  final = File.new(EBJB_BCPray::FINAL, "w+")
  EBJB_BCPray::TARGETS.each { |file|
    src = File.open(file, "r+")
    final.write(src.read + "\n")
    src.close
  }
  final.close
end

ebjb_build()
