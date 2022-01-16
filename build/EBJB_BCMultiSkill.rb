################################################################################
#                EBJB Multi Skill Command - EBJB_BCMULTISKILL         #   VX   #
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
$imported["EBJB_BCMULTISKILL"] = true

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
    BC_MULTI_SKILL = Utilities.generate_battle_command_uid("BC_MULTI_SKILL")
    
    # Battle commands data
    DATA_BATTLE_COMMANDS.push(List_Command.new(BC_MULTI_SKILL, BC_SKILL, nil, 2))
    
    # Actor Battle Commands Settings
    #   syntax: actor_id => [LearningBattleCommand.new('type', ...), ...]
    #   Where 'type' is one of the Battle commands above
    CLASS_BATTLE_COMMANDS_LEARNINGS[4].push(LearningBattleCommand.new(BC_MULTI_SKILL))
    
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
  # * Set Multi Skill
  #--------------------------------------------------------------------------
  def set_multi_skill_actions(nbr)
    @multi_actions_kind = 1
    set_multi_actions(nbr)
  end
  
  #--------------------------------------------------------------------------
  # * Multi Skill Determination
  #--------------------------------------------------------------------------
  def multi_skill_actions?
    return (@multi_actions_kind == 1)
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
  alias execute_battle_commands_bc_multi_skill execute_battle_commands unless $@
  def execute_battle_commands(actor)
    command = @actor_command_window.selected_command
    if command.id == BATTLECOMMANDS_CONFIG::BC_MULTI_SKILL
      actor.set_multi_skill_actions(command.multiple)
    end
    execute_battle_commands_bc_multi_skill(actor)
  end
  
  #--------------------------------------------------------------------------
  # * Alias confirm_no_selection_skill
  #--------------------------------------------------------------------------
  alias confirm_no_selection_skill_bc_multi_skill confirm_no_selection_skill unless $@
  def confirm_no_selection_skill(skill)
    actor = $game_party.members[@actor_index]
    
    if actor.multi_skill_actions? 
      action = actor.action.dup
      actor.add_multi_action(action)
      
      if !actor.multi_actions_completed?
        start_skill_selection(actor)
      else
        end_skill_selection
        for action in actor.multi_actions
          if !action.skill.partners.empty?
            for actor_id in action.skill.partners
              add_to_battleline($game_actors[actor_id])
            end
          else
            add_to_battleline(actor)
          end
        end
        end_actor_command_selection()
      end
    else
      confirm_no_selection_skill_bc_multi_skill(skill)
    end
  end
  
  #--------------------------------------------------------------------------
  # * Alias confirm_enemy_selection
  #--------------------------------------------------------------------------
  alias confirm_enemy_selection_bc_multi_skill confirm_enemy_selection unless $@
  def confirm_enemy_selection(actor)
    if actor.multi_skill_actions? 
      end_target_enemy_selection(false)
      
      action = actor.action.dup
      actor.add_multi_action(action)
      
      if !actor.multi_actions_completed?
        start_skill_selection(actor)
      else
        for action in actor.multi_actions
          if action.skill? && !action.skill.partners.empty?
            for actor_id in action.skill.partners
              add_to_battleline($game_actors[actor_id])
            end
          else
            add_to_battleline(actor)
          end
        end
        
        end_actor_command_selection()
      end
    else
      confirm_enemy_selection_bc_multi_skill(actor)
    end
  end
  
  #--------------------------------------------------------------------------
  # * Alias confirm_actor_selection
  #--------------------------------------------------------------------------
  alias confirm_actor_selection_bc_multi_skill confirm_actor_selection unless $@
  def confirm_actor_selection(actor)
    if actor.multi_skill_actions? 
      end_target_actor_selection(false)
      
      action = actor.action.dup
      actor.add_multi_action(action)
      
      if !actor.multi_actions_completed?
        start_skill_selection(actor)
      else
        add_to_battleline(actor)
        end_actor_command_selection()
      end
    else
      confirm_actor_selection_bc_multi_skill(actor)
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
    alias battle_commands_strings_bc_multi_skill battle_commands_strings unless $@
    def battle_commands_strings
      return battle_commands_strings_bc_multi_skill.merge(
      {
       BATTLECOMMANDS_CONFIG::BC_MULTI_SKILL => ["Multi Skill", "Uses multiple skills at the same time"]
      })
    end
    
  end
end

