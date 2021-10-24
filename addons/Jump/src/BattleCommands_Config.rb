#==============================================================================
# ** BATTLECOMMANDS_CONFIG
#------------------------------------------------------------------------------
#  Contains the BattleCommands_Config configuration
#==============================================================================

module EBJB
  
  module BATTLECOMMANDS_CONFIG

    #------------------------------------------------------------------------
    # Jump Command related 
    #------------------------------------------------------------------------
    
    # Number of turns before landing
    BC_JUMP_TURNS = 3
    
    # True to enable landing on random turns 
    # (ex.: for 3 turns, it may land after 1, 2 or 3 turns)  
    BC_RANDOM_JUMP_TURNS = true
    
    # Jump bonus damage rate (applied to the battler)
    BC_JUMP_BONUS_DMG_RATE = 50
    
    #------------------------------------------------------------------------
    # Battle Commands Definitions
    #------------------------------------------------------------------------
    
    # Unique ids used to represent battle commands
    # BATTLE_COMMAND = 10xx
    BC_JUMP = Utilities.generate_battle_command_uid("BC_JUMP")
    
    # Battle commands data
    DATA_BATTLE_COMMANDS.push(Battle_Command.new(BC_JUMP, BC_JUMP))
    
    # Actor Battle Commands Settings
    #   syntax: actor_id => [LearningBattleCommand.new('type', ...), ...]
    #   Where 'type' is one of the Battle commands above
    CLASS_BATTLE_COMMANDS_LEARNINGS[1].push(LearningBattleCommand.new(BC_JUMP))
    
  end
end
