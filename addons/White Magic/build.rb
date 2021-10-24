module EBJB_BCWhiteMagic
  # Build filename
  FINAL   = "../../build/EBJB_BCWhiteMagic.rb"
  # Source files
  TARGETS = [
	"src/Script_Header.rb",
    "src/BattleCommands_Config.rb",
    "src/Misc Objects/UsableItemFilter.rb",
    "src/User Interface/Vocab.rb",
  ]
end

def ebjb_build
  final = File.new(EBJB_BCWhiteMagic::FINAL, "w+")
  EBJB_BCWhiteMagic::TARGETS.each { |file|
    src = File.open(file, "r+")
    final.write(src.read + "\n")
    src.close
  }
  final.close
end

ebjb_build()
