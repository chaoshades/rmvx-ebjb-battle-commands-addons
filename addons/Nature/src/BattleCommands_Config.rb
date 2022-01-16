#==============================================================================
# ** BATTLECOMMANDS_CONFIG
#------------------------------------------------------------------------------
#  Contains the BattleCommands_Config configuration
#==============================================================================

module EBJB
  
  #==============================================================================
  # ** TerrainSkill
  #------------------------------------------------------------------------------
  #  Represents a 
  #==============================================================================

  class TerrainSkill
    
    #//////////////////////////////////////////////////////////////////////////
    # * Attributes
    #//////////////////////////////////////////////////////////////////////////
    
    # 
    attr_reader :skill_id
    #
    attr_reader :denominator
    
    #//////////////////////////////////////////////////////////////////////////
    # * Constructors
    #//////////////////////////////////////////////////////////////////////////
    
    #--------------------------------------------------------------------------
    # * Object Initialization
    #     skill_id : id
    #     denominator :
    #--------------------------------------------------------------------------
    def initialize(skill_id, denominator)
      @skill_id = skill_id
      @denominator = denominator
    end
    
  end
  
  module BATTLECOMMANDS_CONFIG
    
    #------------------------------------------------------------------------
    # Nature Command related 
    #------------------------------------------------------------------------
    
    # Unique ids used to represent Terrain types
    # TERRAIN_TYPE = 40xx
    
    # Town terrain
    BC_NATURE_TOWN = 4001
    # Forest terrain
    BC_NATURE_FOREST = 4002
    # Plains terrain
    BC_NATURE_PLAINS = 4003
    # Caves terrain
    BC_NATURE_CAVES = 4004
    
    # Terrain Areas definitions
    #   syntax: area_id => 'terrain'
    #   Where 'terrain' is one of the terrain types above
    BC_NATURE_TERRAIN_AREAS = {
      1 => BC_NATURE_TOWN,
      2 => BC_NATURE_FOREST,
    }
    
    # Terrain Skills definitions
    #   syntax: 'terrain' => [TerrainSkill.new(area_id, denominator), ...]
    #   Where 'terrain' is one of the terrain types above
    BC_NATURE_TERRAIN_SKILLS = {
      BC_NATURE_TOWN => [TerrainSkill.new(107, 2),
                         TerrainSkill.new(108, 3),
                         TerrainSkill.new(109, 5)],
      BC_NATURE_FOREST => [TerrainSkill.new(81, 2),
                           TerrainSkill.new(82, 2)],
    }
    
    # Items ID that add a bonus to Nature
    #   syntax: item_id => rate
    BC_NATURE_WEAPON_BONUS_ID = {
      35 => 50
    }
    # Items ID that add a bonus to Nature
    #   syntax: item_id => rate
    BC_NATURE_ARMOR_BONUS_ID = {
      33 => 10
    }
    
    #------------------------------------------------------------------------
    # Battle Commands Definitions
    #------------------------------------------------------------------------
    
    # Unique ids used to represent battle commands
    # BATTLE_COMMAND = 10xx
    BC_NATURE = Utilities.generate_battle_command_uid("BC_NATURE")
    
    # Battle commands data
    DATA_BATTLE_COMMANDS.push(Battle_Command.new(BC_NATURE, BC_NATURE))
    
    # Actor Battle Commands Settings
    #   syntax: actor_id => [LearningBattleCommand.new('type', ...), ...]
    #   Where 'type' is one of the Battle commands above
    CLASS_BATTLE_COMMANDS_LEARNINGS[4].push(LearningBattleCommand.new(BC_NATURE))
    
  end
end
