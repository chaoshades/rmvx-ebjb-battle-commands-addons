################################################################################
#              EBJB Summon Magic Command - EBJB_BCSUMMONMAGIC         #   VX   #
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
$imported["EBJB_BCSUMMONMAGIC"] = true

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
  alias apply_bc_summon_magic apply unless $@
  def apply(x)
    if x != nil && x.is_a?(RPG::UsableItem)
       
      case mode
        when "summonmagic"
          return applySummonMagic(x)
        #when
          #...
        else
          return apply_bc_summon_magic(x)
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
  def applySummonMagic(x)
    if BATTLECOMMANDS_CONFIG::BC_SUMMON_MAGIC_SKILLS_ID.include?(x.id)
      return true
    else
      return false
    end
  end
  private:applySummonMagic
  
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
    alias battle_commands_strings_bc_summon_magic battle_commands_strings unless $@
    def battle_commands_strings
      return battle_commands_strings_bc_summon_magic.merge(
      {
       BATTLECOMMANDS_CONFIG::BC_SUMMON_MAGIC => ["Summon", "Calls a summoned monster"]
      })
    end
    
  end
end

