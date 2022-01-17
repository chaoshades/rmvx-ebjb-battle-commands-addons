module EBJB_BCSlotMachine_Ext
  # Build filename
  FINAL   = "../../build/EBJB_BCSlotMachine_Ext.rb"
  # Source files
  TARGETS = [
    "src/External Scripts/SSS_SlotMachine.rb",
  ]
end

def ebjb_build_ext
  final = File.new(EBJB_BCSlotMachine_Ext::FINAL, "w+")
  EBJB_BCSlotMachine_Ext::TARGETS.each { |file|
    src = File.open(file, "r+")
    final.write(src.read + "\n")
    src.close
  }
  final.close
end

ebjb_build_ext()