#==============================================================================
# ** BATTLECOMMANDS_CONFIG
#------------------------------------------------------------------------------
#  Contains the BattleCommands_Config configuration
#==============================================================================

module EBJB
  
  module BATTLECOMMANDS_CONFIG

    #------------------------------------------------------------------------
    # White Magic Command related 
    #------------------------------------------------------------------------
    
    # Skills ID that are white magics
    BC_WHITE_MAGIC_SKILLS_ID = (33..42).to_a
    
    #------------------------------------------------------------------------
    # Battle Commands Definitions
    #------------------------------------------------------------------------
    
    # Unique ids used to represent battle commands
    # BATTLE_COMMAND = 10xx
    BC_WHITE_MAGIC = Utilities.generate_battle_command_uid("BC_WHITE_MAGIC")
    
    # Battle commands data
    DATA_BATTLE_COMMANDS.push(List_Command.new(BC_WHITE_MAGIC, BC_SKILL, UsableItemFilter.new("whitemagic")))
    
    # Actor Battle Commands Settings
    #   syntax: actor_id => [LearningBattleCommand.new('type', ...), ...]
    #   Where 'type' is one of the Battle commands above
    CLASS_BATTLE_COMMANDS_LEARNINGS[1].push(LearningBattleCommand.new(BC_WHITE_MAGIC))
    
  end
end
