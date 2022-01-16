################################################################################
#                 EBJB Multi Item Command - EBJB_BCMULTIITEM          #   VX   #
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
$imported["EBJB_BCMULTIITEM"] = true

#==============================================================================
# ** BATTLECOMMANDS_CONFIG
#------------------------------------------------------------------------------
#  Contains the BattleCommands_Config configuration
#==============================================================================

module EBJB
  
  module BATTLECOMMANDS_CONFIG
    
    #------------------------------------------------------------------------
    # Battle Commands Definitions
    #------------------------------------------------------------------------
    
    # Unique ids used to represent battle commands
    # BATTLE_COMMAND = 10xx
    BC_MULTI_ITEM = Utilities.generate_battle_command_uid("BC_MULTI_ITEM")
    
    # Battle commands data
    DATA_BATTLE_COMMANDS.push(List_Command.new(BC_MULTI_ITEM, BC_ITEM, nil, 2))
    
    # Actor Battle Commands Settings
    #   syntax: actor_id => [LearningBattleCommand.new('type', ...), ...]
    #   Where 'type' is one of the Battle commands above
    CLASS_BATTLE_COMMANDS_LEARNINGS[4].push(LearningBattleCommand.new(BC_MULTI_ITEM))
    
  end
end

#==============================================================================
# ** Game_Battler
#------------------------------------------------------------------------------
#  This class deals with battlers. It's used as a superclass of the Game_Actor
# and Game_Enemy classes.
#==============================================================================

class Game_Battler
  
  #//////////////////////////////////////////////////////////////////////////
  # * Properties
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Set Multi Item
  #--------------------------------------------------------------------------
  def set_multi_item_actions(nbr)
    @multi_actions_kind = 2
    set_multi_actions(nbr)
  end
  
  #--------------------------------------------------------------------------
  # * Multi Item Determination
  #--------------------------------------------------------------------------
  def multi_item_actions?
    return (@multi_actions_kind == 2)
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
  alias execute_battle_commands_bc_multi_item execute_battle_commands unless $@
  def execute_battle_commands(actor)
    command = @actor_command_window.selected_command
    if command.id == BATTLECOMMANDS_CONFIG::BC_MULTI_ITEM
      actor.set_multi_item_actions(command.multiple)
    end
    execute_battle_commands_bc_multi_item(actor)
  end
#~   
  #--------------------------------------------------------------------------
  # * Alias confirm_no_selection_item
  #--------------------------------------------------------------------------
  alias confirm_no_selection_item_bc_multi_item confirm_no_selection_item unless $@
  def confirm_no_selection_item(item)
    actor = $game_party.members[@actor_index]
    
    if actor.multi_item_actions? 
      
      action = actor.action.dup
      actor.add_multi_action(action)
      
      if !actor.multi_actions_completed?
        start_item_selection
      else
        end_item_selection
        add_to_battleline(actor)
        end_actor_command_selection()
      end
    else
      confirm_no_selection_item_bc_multi_item(item)
    end
  end
  
  #--------------------------------------------------------------------------
  # * Alias confirm_enemy_selection
  #--------------------------------------------------------------------------
  alias confirm_enemy_selection_bc_multi_item confirm_enemy_selection unless $@
  def confirm_enemy_selection(actor)
    if actor.multi_item_actions? 
      end_target_enemy_selection(false)
      
      action = actor.action.dup
      actor.add_multi_action(action)
      
      if !actor.multi_actions_completed?
        start_item_selection
      else
        add_to_battleline(actor)
        end_actor_command_selection()
      end
    else
      confirm_enemy_selection_bc_multi_item(actor)
    end
  end
  
  #--------------------------------------------------------------------------
  # * Alias confirm_actor_selection
  #--------------------------------------------------------------------------
  alias confirm_actor_selection_bc_multi_item confirm_actor_selection unless $@  
  def confirm_actor_selection(actor)
    if actor.multi_item_actions? 
      end_target_actor_selection(false)
      
      action = actor.action.dup
      actor.add_multi_action(action)
      
      if !actor.multi_actions_completed?
        start_item_selection
      else
        add_to_battleline(actor)
        end_actor_command_selection()
      end
    else
      confirm_actor_selection_bc_multi_item(actor)
    end
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
    alias battle_commands_strings_bc_multi_item battle_commands_strings unless $@
    def battle_commands_strings
      return battle_commands_strings_bc_multi_item.merge(
      {
       BATTLECOMMANDS_CONFIG::BC_MULTI_ITEM => ["Multi Item", "Uses multiple items at the same time"]
      })
    end
    
  end
end

