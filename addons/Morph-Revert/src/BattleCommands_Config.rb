#==============================================================================
# ** BATTLECOMMANDS_CONFIG
#------------------------------------------------------------------------------
#  Contains the BattleCommands_Config configuration
#==============================================================================

module EBJB
  
  #==============================================================================
  # ** Morph_Command
  #------------------------------------------------------------------------------
  #  Represents a morph battle command
  #==============================================================================

  class Morph_Command < Battle_Command
    
    #//////////////////////////////////////////////////////////////////////////
    # * Attributes
    #//////////////////////////////////////////////////////////////////////////
    
    # Skill ID
    attr_reader :skill_id
    # 
    attr_reader :morph_actor_id
    
    #//////////////////////////////////////////////////////////////////////////
    # * Properties
    #//////////////////////////////////////////////////////////////////////////
    
    #--------------------------------------------------------------------------
    # * Get the skill object of the morph battle command
    #--------------------------------------------------------------------------
    def skill()
      return $data_skills[@skill_id]
    end
    
    #--------------------------------------------------------------------------
    # * Get the name of the morph battle command
    #--------------------------------------------------------------------------
    def name()
      return $data_skills[@skill_id].name
    end
    
    #--------------------------------------------------------------------------
    # * Get the description of the morph battle command
    #--------------------------------------------------------------------------
    def description()
      return $data_skills[@skill_id].description
    end
    
    #//////////////////////////////////////////////////////////////////////////
    # * Constructors
    #//////////////////////////////////////////////////////////////////////////
    
    #--------------------------------------------------------------------------
    # * Object Initialization
    #     id : command id
    #     skill_id : Skill ID to get name and description of the battle command
    #     morph_actor_id :
    #--------------------------------------------------------------------------
    def initialize(skill_id, morph_actor_id)
      super(Utilities.generate_battle_command_uid("BC_MORPH_"+skill_id.to_s), 
            BATTLECOMMANDS_CONFIG::BC_MORPH)
      @skill_id = skill_id
      @morph_actor_id = morph_actor_id
    end
    
  end
  
  module BATTLECOMMANDS_CONFIG
       
    #------------------------------------------------------------------------
    # Battle Commands Definitions
    #------------------------------------------------------------------------
    
    # Unique ids used to represent battle commands
    # BATTLE_COMMAND = 10xx
    BC_MORPH = Utilities.generate_battle_command_uid("BC_MORPH")
    BC_REVERT = Utilities.generate_battle_command_uid("BC_REVERT")
    
    # Battle commands data
    DATA_BATTLE_COMMANDS.push(List_Command.new(BC_MORPH, BC_MORPH, UsableItemFilter.new("morph")))
    DATA_BATTLE_COMMANDS.push(Battle_Command.new(BC_REVERT, BC_REVERT))
    
    # Actor Battle Commands Settings
    #   syntax: actor_id => [LearningBattleCommand.new('type', ...), ...]
    #   Where 'type' is one of the Battle commands above
    CLASS_BATTLE_COMMANDS_LEARNINGS[1].push(LearningBattleCommand.new(BC_MORPH))
    CLASS_BATTLE_COMMANDS_LEARNINGS[10] = []
    CLASS_BATTLE_COMMANDS_LEARNINGS[10].push(LearningBattleCommand.new(BC_REVERT))
    
    # Actor Battle Commands Settings
    #   syntax: actor_id => ['type', ...]
    #   Where 'type' is one of the Battle commands above
    ACTOR_BATTLE_COMMANDS[10] = [BC_ATTACK, BC_REVERT, BC_SKILL, BC_GUARD, BC_ITEM]
    
    #------------------------------------------------------------------------
    # Morph Command related 
    #------------------------------------------------------------------------
    
    # Morph Commands Settings
    #   syntax: skill_id => array of inputs
    BC_MORPH_COMMANDS = [
      Morph_Command.new(102, 10)
    ]
    
  end
end
