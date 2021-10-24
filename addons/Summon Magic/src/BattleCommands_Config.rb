#==============================================================================
# ** BATTLECOMMANDS_CONFIG
#------------------------------------------------------------------------------
#  Contains the BattleCommands_Config configuration
#==============================================================================

module EBJB
  
  module BATTLECOMMANDS_CONFIG

    #------------------------------------------------------------------------
    # Summon Magic Command related 
    #------------------------------------------------------------------------
    
    # Skills ID that are summons
    BC_SUMMON_MAGIC_SKILLS_ID = (84..87).to_a
    
    #------------------------------------------------------------------------
    # Battle Commands Definitions
    #------------------------------------------------------------------------
    
    # Unique ids used to represent battle commands
    # BATTLE_COMMAND = 10xx
    BC_SUMMON_MAGIC = Utilities.generate_battle_command_uid("BC_SUMMON_MAGIC")
    
    # Battle commands data
    DATA_BATTLE_COMMANDS.push(List_Command.new(BC_SUMMON_MAGIC, BC_SKILL, UsableItemFilter.new("summonmagic")))
    
    # Actor Battle Commands Settings
    #   syntax: actor_id => [LearningBattleCommand.new('type', ...), ...]
    #   Where 'type' is one of the Battle commands above
    CLASS_BATTLE_COMMANDS_LEARNINGS[4].push(LearningBattleCommand.new(BC_SUMMON_MAGIC))
    
  end
end
