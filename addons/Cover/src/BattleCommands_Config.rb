#==============================================================================
# ** BATTLECOMMANDS_CONFIG
#------------------------------------------------------------------------------
#  Contains the BattleCommands_Config configuration
#==============================================================================

module EBJB
  
  module BATTLECOMMANDS_CONFIG
    
    #------------------------------------------------------------------------
    # Cover Command related 
    #------------------------------------------------------------------------
    
    # True to enable protection from physical damage, else false
    PROTECT_PHYSICAL = true
    # True to enable protection from magic (skills) damage, else false
    PROTECT_SKILLS = true
    
    # This is the number of allies one character can protect at the same time
    PROTECT_LIMIT = 1
    # This is a percentage of damage the protector will take when protecting
    # an ally. For example, if this value is set to 50, the protector will take
    # half damage when protecting an ally.
    DAMAGE_EFFECT = 100
    
    #------------------------------------------------------------------------
    # Battle Commands Definitions
    #------------------------------------------------------------------------
    
    # Unique ids used to represent battle commands
    # BATTLE_COMMAND = 10xx
    BC_COVER = Utilities.generate_battle_command_uid("BC_COVER2")
    
    # Battle commands data
    DATA_BATTLE_COMMANDS.push(Battle_Command.new(BC_COVER, BC_COVER, nil, false))
    
    # Actor Battle Commands Settings
    #   syntax: actor_id => [LearningBattleCommand.new('type', ...), ...]
    #   Where 'type' is one of the Battle commands above
    CLASS_BATTLE_COMMANDS_LEARNINGS[1].push(LearningBattleCommand.new(BC_COVER))
    
  end
end
