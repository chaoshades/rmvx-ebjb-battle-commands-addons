################################################################################
#                    EBJB Nature Command - EBJB_BCNATURE              #   VX   #
#                          Last Update: 2012/10/28                    ##########
#                          Author : ChaosHades                                 #
#     Source :                                                                 #
#     http://www.google.com                                                    #
#------------------------------------------------------------------------------#
#  Description of the script                                                   #
#==============================================================================#
#                         ** Instructions For Usage **                         #
#  There are settings that can be configured in the BattleCommands_Config      #
#  class. For more info on what and how to adjust these settings, see the      #
#  documentation  in the class.                                                #
#==============================================================================#
#                                ** Examples **                                #
#  See the documentation in each classes.                                      #
#==============================================================================#
#                           ** Installation Notes **                           #
#  Copy this script in the Materials section                                   #
#==============================================================================#
#                             ** Compatibility **                              #
#  Works With: Script Names, ...                                               #
#  Alias: Class - method, ...                                                  #
#  Overwrites: Class - method, ...                                             #
################################################################################

$imported = {} if $imported == nil
$imported["EBJB_BCNATURE"] = true

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

#==============================================================================
# ** Game_Actor
#------------------------------------------------------------------------------
#  This class handles actors. It's used within the Game_Actors class
# ($game_actors) and referenced by the Game_Party class ($game_party).
#==============================================================================

class Game_Actor < Game_Battler
  include EBJB
  
  #//////////////////////////////////////////////////////////////////////////
  # * Properties
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Get total Nature rate bonus
  #--------------------------------------------------------------------------
  def total_nature_rate_bonus()
    n = 0
    equips.compact.each { |item| n += item.nature_rate_bonus }
    return n
  end

end

#==============================================================================
# ** Game_BattleAction
#------------------------------------------------------------------------------
#  This class handles battle actions. This class is used within the
# Game_Battler class.
#==============================================================================

class Game_BattleAction
  
  #--------------------------------------------------------------------------
  # * Set Nature Attack
  #--------------------------------------------------------------------------
  def set_nature(skill_id)
    @kind = 0
    @basic = 16
    @skill_id = skill_id
  end
  
  #--------------------------------------------------------------------------
  # * Set Failed Nature Attack
  #--------------------------------------------------------------------------
  def set_failed_nature
    @kind = 0
    @basic = 17
  end
  
  #--------------------------------------------------------------------------
  # * Nature Attack Determination
  #--------------------------------------------------------------------------
  def nature?
    return (@kind == 0 and @basic == 16)
  end
  
  #--------------------------------------------------------------------------
  # * Failed Nature Attack Determination
  #--------------------------------------------------------------------------
  def failed_nature?
    return (@kind == 0 and @basic == 17)
  end
  
  #--------------------------------------------------------------------------
  # * Get Skill Object
  #--------------------------------------------------------------------------
  alias skill_bc_nature skill unless $@
  def skill
    return nature? ? $data_skills[@skill_id] : skill_bc_nature
  end
  
  #--------------------------------------------------------------------------
  # * Alias make_targets
  #--------------------------------------------------------------------------
  alias make_targets_bc_nature make_targets unless $@
  def make_targets
    if nature?
      return make_obj_targets(skill)
    elsif failed_nature?
      return [battler]
    else
      return make_targets_bc_nature
    end
  end
  
  #--------------------------------------------------------------------------
  # * Alias determine_action_name
  #--------------------------------------------------------------------------
  alias determine_action_name_bc_nature determine_action_name unless $@
  def determine_action_name()
    action_name = ""
    if self.nature?
      action_name = "Nature"
    else
      action_name = determine_action_name_bc_nature
    end
    
    return action_name
  end
  
  #--------------------------------------------------------------------------
  # * Alias valid?
  #--------------------------------------------------------------------------
  alias valid_bc_nature? valid? unless $@
  def valid?
    return true if nature?
    return true if failed_nature?
    return valid_bc_nature?
  end
  
end
#===============================================================================
# ** RPG::Area Addon
#------------------------------------------------------------------------------
#  Addon functions 
#===============================================================================

class RPG::Area
  include EBJB
  
  #//////////////////////////////////////////////////////////////////////////
  # * Properties
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Get 
  #--------------------------------------------------------------------------
  # GET
  def terrain
    return BATTLECOMMANDS_CONFIG::BC_NATURE_TERRAIN_AREAS[self.id]
  end
  
end

#===============================================================================
# ** RPG::Armor Addon
#------------------------------------------------------------------------------
#  Addon functions 
#===============================================================================

class RPG::Armor
  include EBJB
  
  #//////////////////////////////////////////////////////////////////////////
  # * Properties
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Get Nature rate bonus
  #--------------------------------------------------------------------------
  # GET
  def nature_rate_bonus
    bonus = BATTLECOMMANDS_CONFIG::BC_STEAL_ARMOR_BONUS_ID[self.id]
    if bonus == nil
      bonus = 0
    end
    return bonus
  end
  
end

#===============================================================================
# ** RPG::Weapon Addon
#------------------------------------------------------------------------------
#  Addon functions 
#===============================================================================

class RPG::Weapon
  include EBJB
  
  #//////////////////////////////////////////////////////////////////////////
  # * Properties
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Get Nature rate bonus
  #--------------------------------------------------------------------------
  # GET
  def nature_rate_bonus
    bonus = BATTLECOMMANDS_CONFIG::BC_STEAL_WEAPON_BONUS_ID[self.id]
    if bonus == nil
      bonus = 0
    end
    return bonus
  end
  
end

#==============================================================================
# ** Scene_Battle
#------------------------------------------------------------------------------
#   This class performs battle screen processing.
#==============================================================================

class Scene_Battle < Scene_Base
  include EBJB
  
  #--------------------------------------------------------------------------
  # * Alias execute_battle_commands
  #--------------------------------------------------------------------------
  alias execute_battle_commands_bc_nature execute_battle_commands unless $@
  def execute_battle_commands(actor)
    command = @actor_command_window.selected_command
    if command.type == BATTLECOMMANDS_CONFIG::BC_NATURE
      Sound.play_decision
      skill_id = determine_nature_skill(actor)
      if skill_id == nil
        actor.action.set_failed_nature
      else
        actor.action.set_nature(skill_id)
      end
      add_to_battleline(actor)
      end_actor_command_selection()
    else
      execute_battle_commands_bc_nature(actor)
    end
  end
  
  #--------------------------------------------------------------------------
  # * Alias execute_action
  #--------------------------------------------------------------------------
  alias execute_action_bc_nature execute_action unless $@
  def execute_action
    if @active_battler.action.nature?
      execute_action_skill
      @active_battler.action.clear
    elsif @active_battler.action.failed_nature?
      execute_action_failed_nature
      @active_battler.action.clear
    else
      execute_action_bc_nature
    end
  end
  
  #--------------------------------------------------------------------------
  # * Execute Battle Action: Failed Nature
  #--------------------------------------------------------------------------
  def execute_action_failed_nature
    @top_help_window.set_text("No response")
    @top_help_window.visible = true
    @active_battler.stamina_wait = true
    @active_battler.empty_stamina
    execute_basic_action(nil)
    @top_help_window.visible = false
  end
  
  #--------------------------------------------------------------------------
  # * 
  #--------------------------------------------------------------------------
  def determine_nature_skill(battler)
    skill_id = nil
    
    # Finds the current area
    current_area = nil
    areas = $data_areas.values
    i = 0
    while current_area == nil && i < areas.size
      if $game_player.in_area?(areas[i])
        current_area = areas[i]
      end
      i += 1
    end
    
    # Determines the skill ID randomly depending on probabilities
    if current_area != nil
      available_skills = BATTLECOMMANDS_CONFIG::BC_NATURE_TERRAIN_SKILLS[current_area.terrain]
      
      # Determine terrain skill ratio with bonus
      ratio = 1
      ratio -= battler.total_nature_rate_bonus.to_f / 100
      
      # Takes randomly one skill in the list
      index = rand(available_skills.length)

      # Determines if the skill is successfully casted
      denom = (available_skills[index].denominator * ratio).ceil
      if denom <= 1 || rand(denom) == 0
        skill_id = available_skills[index].skill_id
      end
    end
    
    return skill_id
  end
  
end

#==============================================================================
# ** Vocab
#------------------------------------------------------------------------------
#  This module defines terms and messages. It defines some data as constant
# variables. Terms in the database are obtained from $data_system.
#==============================================================================

module Vocab
  class << self
  include EBJB
    #//////////////////////////////////////////////////////////////////////////
    # * Public Methods
    #//////////////////////////////////////////////////////////////////////////
    
    #//////////////////////////////////////////////////////////////////////////
    # Battle Commands related
    #//////////////////////////////////////////////////////////////////////////
    
    #--------------------------------------------------------------------------
    # * Get Strings to show for every battle command (name + description)
    #--------------------------------------------------------------------------
    alias battle_commands_strings_bc_nature battle_commands_strings unless $@
    def battle_commands_strings
      return battle_commands_strings_bc_nature.merge(
      {
       BATTLECOMMANDS_CONFIG::BC_NATURE => ["Nature", "Asks nature to come to help"]
      })
    end
    
  end
end

