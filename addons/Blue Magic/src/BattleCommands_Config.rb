#==============================================================================
# ** BATTLECOMMANDS_CONFIG
#------------------------------------------------------------------------------
#  Contains the BattleCommands_Config configuration
#==============================================================================

module EBJB
  
  module BATTLECOMMANDS_CONFIG
    
    #------------------------------------------------------------------------
    # Blue Magic Command related 
    #------------------------------------------------------------------------
    
    # Unique ids used to represent Blue Magic Learn types
    # BM_TYPE = 10xx
    
    # Learn magic when battler is hit by it
    BM_TYPE_HIT = 1001
    # Learn magic when enemy cast it
    BM_TYPE_CAST = 1002
    # Learn magic when battler analyze the enemy
    BM_TYPE_ANALYZE = 1003
    
    # Array of learning types, combine any type that you want
    BC_BLUE_MAGIC_LEARN_TYPE = [BM_TYPE_HIT, BM_TYPE_CAST, BM_TYPE_ANALYZE]
    
    # Skills ID that are blue magics
    BC_BLUE_MAGIC_SKILLS_ID = (104..105).to_a
    
    #------------------------------------------------------------------------
    # Battle Commands Definitions
    #------------------------------------------------------------------------
    
    # Unique ids used to represent battle commands
    # BATTLE_COMMAND = 10xx
    BC_BLUE_MAGIC = Utilities.generate_battle_command_uid("BC_BLUE_MAGIC")
    BC_ANALYZE = Utilities.generate_battle_command_uid("BC_ANALYZE")
    
    # Battle commands data
    DATA_BATTLE_COMMANDS.push(List_Command.new(BC_BLUE_MAGIC, BC_SKILL, UsableItemFilter.new("bluemagic")))
    DATA_BATTLE_COMMANDS.push(Skill_Command.new(BC_ANALYZE, 91, true))
    
    # Actor Battle Commands Settings
    #   syntax: actor_id => [LearningBattleCommand.new('type', ...), ...]
    #   Where 'type' is one of the Battle commands above
    CLASS_BATTLE_COMMANDS_LEARNINGS[4].push(LearningBattleCommand.new(BC_BLUE_MAGIC))
    CLASS_BATTLE_COMMANDS_LEARNINGS[4].push(LearningBattleCommand.new(BC_ANALYZE))
    
  end
end
