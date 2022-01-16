#==============================================================================
# ** BATTLECOMMANDS_CONFIG
#------------------------------------------------------------------------------
#  Contains the BattleCommands_Config configuration
#==============================================================================

module EBJB
  
  module BATTLECOMMANDS_CONFIG
    
    #------------------------------------------------------------------------
    # Sword Rune Magic Command related 
    #------------------------------------------------------------------------
    
    # Skills ID that are sword runes
    BC_SWORD_RUNE_SKILLS_ID = (93..96).to_a
    
    # State ID of the Rune Sword state
    BC_SWORD_RUNE_STATE_ID = 18
    
    #------------------------------------------------------------------------
    # Battle Commands Definitions
    #------------------------------------------------------------------------
    
    # Unique ids used to represent battle commands
    # BATTLE_COMMAND = 10xx
    BC_SWORD_RUNE = Utilities.generate_battle_command_uid("BC_SWORD_RUNE")
    
    # Battle commands data
    DATA_BATTLE_COMMANDS.push(List_Command.new(BC_SWORD_RUNE, BC_SKILL, UsableItemFilter.new("swordrune")))
    
    # Actor Battle Commands Settings
    #   syntax: actor_id => [LearningBattleCommand.new('type', ...), ...]
    #   Where 'type' is one of the Battle commands above
    CLASS_BATTLE_COMMANDS_LEARNINGS[2].push(LearningBattleCommand.new(BC_SWORD_RUNE))
    
  end
end
