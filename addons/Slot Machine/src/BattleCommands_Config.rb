#==============================================================================
# ** BATTLECOMMANDS_CONFIG
#------------------------------------------------------------------------------
#  Contains the BattleCommands_Config configuration
#==============================================================================

module EBJB
  
  module BATTLECOMMANDS_CONFIG
    
    #------------------------------------------------------------------------
    # Slot Machine Command related 
    #------------------------------------------------------------------------
    
    # Skills ID that are slot machine skills (depends on SSS::SLOT_ICONS)
    BC_SLOT_MACHINE_SKILLS ={
      1 => 111,
      2 => 112,
      3 => 113
    }
    
    #------------------------------------------------------------------------
    # Battle Commands Definitions
    #------------------------------------------------------------------------
    
    # Unique ids used to represent battle commands
    # BATTLE_COMMAND = 10xx
    BC_SLOT_MACHINE = Utilities.generate_battle_command_uid("BC_SLOT_MACHINE")
    
    # Battle commands data
    DATA_BATTLE_COMMANDS.push(Battle_Command.new(BC_SLOT_MACHINE, BC_SLOT_MACHINE))
    
    # Actor Battle Commands Settings
    #   syntax: actor_id => [LearningBattleCommand.new('type', ...), ...]
    #   Where 'type' is one of the Battle commands above
    CLASS_BATTLE_COMMANDS_LEARNINGS[1].push(LearningBattleCommand.new(BC_SLOT_MACHINE))
    
  end
end
