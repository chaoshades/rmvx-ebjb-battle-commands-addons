module EBJB_BCTurnUndead
  # Build filename
  FINAL   = "../../build/EBJB_BCTurnUndead.rb"
  # Source files
  TARGETS = [
	"src/Script_Header.rb",
    "src/BattleCommands_Config.rb",
  ]
end

def ebjb_build
  final = File.new(EBJB_BCTurnUndead::FINAL, "w+")
  EBJB_BCTurnUndead::TARGETS.each { |file|
    src = File.open(file, "r+")
    final.write(src.read + "\n")
    src.close
  }
  final.close
end

ebjb_build()
