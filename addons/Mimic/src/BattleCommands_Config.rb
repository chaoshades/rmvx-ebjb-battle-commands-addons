#==============================================================================
# ** BATTLECOMMANDS_CONFIG
#------------------------------------------------------------------------------
#  Contains the BattleCommands_Config configuration
#==============================================================================

module EBJB
  
  module BATTLECOMMANDS_CONFIG
    
    #------------------------------------------------------------------------
    # Mimic Command related 
    #------------------------------------------------------------------------
    
    # True to consume no MP when mimicking skills, else false, to consume same
    # MP than the mimicked skill
    BC_MIMIC_NO_MP_COST = false
    
    # True to consume the item when mimicking items, else false
    BC_MIMIC_CONSUME_ITEM = true
    
    # True to stop the removal of the last mimicked action 
    # (watch out, though, you will be able to repeat the same action over 
    #  and over again which could be overpowered), else false
    BC_MIMIC_REPEAT_INDEFINITELY = false
    
    #------------------------------------------------------------------------
    # Battle Commands Definitions
    #------------------------------------------------------------------------
    
    # Unique ids used to represent battle commands
    # BATTLE_COMMAND = 10xx
    BC_MIMIC = Utilities.generate_battle_command_uid("BC_MIMIC")
    
    # Battle commands data
    DATA_BATTLE_COMMANDS.push(Battle_Command.new(BC_MIMIC, BC_MIMIC))
    
    # Actor Battle Commands Settings
    #   syntax: actor_id => [LearningBattleCommand.new('type', ...), ...]
    #   Where 'type' is one of the Battle commands above
    CLASS_BATTLE_COMMANDS_LEARNINGS[1].push(LearningBattleCommand.new(BC_MIMIC))
    
  end
end
