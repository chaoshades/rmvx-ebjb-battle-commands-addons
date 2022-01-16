################################################################################
#                  EBJB Sword Rune Command - EBJB_BCSWORDRUNE         #   VX   #
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
$imported["EBJB_BCSWORDRUNE"] = true

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
  # * Alias element_set
  #--------------------------------------------------------------------------
  alias element_set_bc_sword_rune element_set unless $@
  def element_set
    if sword_rune_affected?
      return @sword_rune_element_set
    else
      return element_set_bc_sword_rune
    end
  end

end

#==============================================================================
# ** Game_Battler
#------------------------------------------------------------------------------
#  This class deals with battlers. It's used as a superclass of the Game_Actor
# and Game_Enemy classes.
#==============================================================================

class Game_Battler
  include EBJB
  
  #//////////////////////////////////////////////////////////////////////////
  # * Attributes
  #//////////////////////////////////////////////////////////////////////////
  
  # 
  attr_accessor :sword_rune_element_set
  
  #//////////////////////////////////////////////////////////////////////////
  # * Properties
  #//////////////////////////////////////////////////////////////////////////
  
  def sword_rune_affected?
    return state?(BATTLECOMMANDS_CONFIG::BC_SWORD_RUNE_STATE_ID) && 
           !@sword_rune_element_set.nil?
  end
  
  #//////////////////////////////////////////////////////////////////////////
  # * Constructor
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Alias initialize
  #--------------------------------------------------------------------------
  alias initialize_bc_sword_rune initialize unless $@
  def initialize
    @sword_rune_element_set = nil
    initialize_bc_sword_rune
  end  
  
  #//////////////////////////////////////////////////////////////////////////
  # * Public Methods
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Alias add_state
  #--------------------------------------------------------------------------
  alias apply_state_changes_bc_rune_sword apply_state_changes unless $@
  def apply_state_changes(obj)
    if (obj.is_a?(RPG::Skill) && 
        BATTLECOMMANDS_CONFIG::BC_SWORD_RUNE_SKILLS_ID.include?(obj.id))
      @sword_rune_element_set = obj.element_set.dup
    end
    
    apply_state_changes_bc_rune_sword(obj)
  end
  
  #--------------------------------------------------------------------------
  # * Alias remove_state
  #--------------------------------------------------------------------------
  alias remove_state_bc_rune_sword remove_state unless $@
  def remove_state(state_id)
    if state_id == BATTLECOMMANDS_CONFIG::BC_SWORD_RUNE_STATE_ID
      @sword_rune_element_set = nil
    end
    remove_state_bc_rune_sword(state_id)
  end
  
end

#==============================================================================
# ** UsableItemFilter
#------------------------------------------------------------------------------
#  Represents a UsableItem filter
#==============================================================================

class UsableItemFilter < Filter
  include EBJB
  
  #//////////////////////////////////////////////////////////////////////////
  # * Public Methods
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Alias apply
  #--------------------------------------------------------------------------
  alias apply_bc_sword_rune apply unless $@
  def apply(x)
    if x != nil && x.is_a?(RPG::UsableItem)
       
      case mode
        when "swordrune"
          return applySwordRune(x)
        #when
          #...
        else
          return apply_bc_sword_rune(x)
      end
      
    else
      return nil
    end
  end
  
  #//////////////////////////////////////////////////////////////////////////
  # * Private Methods
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Apply method (using the id property)
  #     x : object to filter
  #--------------------------------------------------------------------------
  def applySwordRune(x)
    if BATTLECOMMANDS_CONFIG::BC_SWORD_RUNE_SKILLS_ID.include?(x.id)
      return true
    else
      return false
    end
  end
  private:applySwordRune
  
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
    alias battle_commands_strings_bc_sword_rune battle_commands_strings unless $@
    def battle_commands_strings
      return battle_commands_strings_bc_sword_rune.merge(
      {
       BATTLECOMMANDS_CONFIG::BC_SWORD_RUNE => ["Sword Rune", "Enchants weapons during battle"]
      })
    end
    
  end
end

