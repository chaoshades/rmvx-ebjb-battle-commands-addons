################################################################################
#                     EBJB Mimic Command - EBJB_BCMIMIC               #   VX   #
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
$imported["EBJB_BCMIMIC"] = true

#==============================================================================
# ** BATTLECOMMANDS_CONFIG
#------------------------------------------------------------------------------
#  Contains the BattleCommands_Config configuration
#==============================================================================

module EBJB
  
  module BATTLECOMMANDS_CONFIG
    
    #------------------------------------------------------------------------
    # Mimic Command related 
    #------------------------------------------------------------------------
    
    # True to consume no MP when mimicking skills, else false, to consume same
    # MP than the mimicked skill
    BC_MIMIC_NO_MP_COST = false
    
    # True to consume the item when mimicking items, else false
    BC_MIMIC_CONSUME_ITEM = true
    
    # True to stop the removal of the last mimicked action 
    # (watch out, though, you will be able to repeat the same action over 
    #  and over again which could be overpowered), else false
    BC_MIMIC_REPEAT_INDEFINITELY = false
    
    #------------------------------------------------------------------------
    # Battle Commands Definitions
    #------------------------------------------------------------------------
    
    # Unique ids used to represent battle commands
    # BATTLE_COMMAND = 10xx
    BC_MIMIC = Utilities.generate_battle_command_uid("BC_MIMIC")
    
    # Battle commands data
    DATA_BATTLE_COMMANDS.push(Battle_Command.new(BC_MIMIC, BC_MIMIC))
    
    # Actor Battle Commands Settings
    #   syntax: actor_id => [LearningBattleCommand.new('type', ...), ...]
    #   Where 'type' is one of the Battle commands above
    CLASS_BATTLE_COMMANDS_LEARNINGS[1].push(LearningBattleCommand.new(BC_MIMIC))
    
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
  # * Set Mimic Attack
  #--------------------------------------------------------------------------
  def set_mimic
    @kind = 0
    @basic = 13
  end
  
  #--------------------------------------------------------------------------
  # * Set Failed Mimic Attack
  #--------------------------------------------------------------------------
  def set_failed_mimic
    @kind = 0
    @basic = 14
  end
  
  #--------------------------------------------------------------------------
  # * Mimic Attack Determination
  #--------------------------------------------------------------------------
  def mimic?
    return (@kind == 0 and @basic == 13)
  end

  #--------------------------------------------------------------------------
  # * Failed Mimic Attack Determination
  #--------------------------------------------------------------------------
  def failed_mimic?
    return (@kind == 0 and @basic == 14)
  end
  
  #--------------------------------------------------------------------------
  # * Alias make_targets
  #--------------------------------------------------------------------------
  alias make_targets_bc_mimic make_targets unless $@
  def make_targets
    if failed_mimic?
      return [battler]
    else
      return make_targets_bc_mimic
    end
  end
  
  #--------------------------------------------------------------------------
  # * Alias determine_action_name
  #--------------------------------------------------------------------------
  alias determine_action_name_bc_mimic determine_action_name unless $@
  def determine_action_name()
    action_name = ""
    if self.mimic?
      action_name = "Mimic"
    else
      action_name = determine_action_name_bc_mimic
    end
    
    return action_name
  end
  
  #--------------------------------------------------------------------------
  # * Alias valid?
  #--------------------------------------------------------------------------
  alias valid_bc_mimic? valid? unless $@
  def valid?
    return true if mimic? 
    return true if failed_mimic? 
    return valid_bc_mimic?
  end
  
end
#==============================================================================
# ** Game_Unit
#------------------------------------------------------------------------------
#  This class handles units. It's used as a superclass of the Game_Party and
# Game_Troop classes.
#==============================================================================

class Game_Unit
  include EBJB
  
  #//////////////////////////////////////////////////////////////////////////
  # * Attributes
  #//////////////////////////////////////////////////////////////////////////
  
  # Keeps reference to last action for Mimic battle command
  attr_accessor :last_action
  
  #//////////////////////////////////////////////////////////////////////////
  # * Public Methods
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * 
  #--------------------------------------------------------------------------
  def valid_last_action?(battler)
    result = true
    if last_action.is_a?(Array)
      for action in last_action
        result &= (action.nil? ||
                   valid_skill_action?(action, battler) ||
                   valid_item_action?(action))
      end
    else
      result = (last_action.nil? ||
                valid_skill_action?(last_action, battler) ||
                valid_item_action?(last_action))
    end
    
    return result
  end
  
  #//////////////////////////////////////////////////////////////////////////
  # * Private Methods
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * 
  #--------------------------------------------------------------------------
  def valid_skill_action?(action, battler)
    return (!BATTLECOMMANDS_CONFIG::BC_MIMIC_NO_MP_COST && 
            action.skill? && battler.mp < battler.calc_mp_cost(action.skill))
  end
  private :valid_skill_action?

  #--------------------------------------------------------------------------
  # * 
  #--------------------------------------------------------------------------
  def valid_item_action?(action)
    return (BATTLECOMMANDS_CONFIG::BC_MIMIC_CONSUME_ITEM && 
            action.item? && !$game_party.has_item?(action.item))
  end
  private :valid_item_action?
  
end

#==============================================================================
# ** Game_Battler
#------------------------------------------------------------------------------
#  This class deals with battlers. It's used as a superclass of the Game_Actor
# and Game_Enemy classes.
#==============================================================================

class Game_Battler

  #//////////////////////////////////////////////////////////////////////////
  # * Attributes
  #//////////////////////////////////////////////////////////////////////////

  # 
  attr_accessor :override_no_mp_cost
  # 
  attr_accessor :override_consume_item
  # Needs to be able to set the action when using the Mimic battle command
  attr_writer :action
  
  #//////////////////////////////////////////////////////////////////////////
  # * Public Methods
  #//////////////////////////////////////////////////////////////////////////  

  #--------------------------------------------------------------------------
  # * Alias calc_mp_cost
  #--------------------------------------------------------------------------
  alias calc_mp_cost_bc_mimic calc_mp_cost unless $@
  def calc_mp_cost(skill)
    return 0 if !@override_no_mp_cost.nil? && @override_no_mp_cost == true
    return calc_mp_cost_bc_mimic(skill)
  end
  
  #--------------------------------------------------------------------------
  # * Alias consume_item?
  #--------------------------------------------------------------------------
  alias consume_item_bc_mimic? consume_item? unless $@
  def consume_item?
    return @override_consume_item unless @override_consume_item.nil?
    return consume_item_bc_mimic?
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
  alias execute_battle_commands_bc_mimic execute_battle_commands unless $@
  def execute_battle_commands(actor)
    command = @actor_command_window.selected_command
    if command.type == BATTLECOMMANDS_CONFIG::BC_MIMIC
      Sound.play_decision
      actor.action.set_mimic
      add_to_battleline(actor)
      end_actor_command_selection()
    else
      execute_battle_commands_bc_mimic(actor)
    end
  end
  
  #--------------------------------------------------------------------------
  # * Alias execute_action
  #--------------------------------------------------------------------------
  alias execute_action_bc_mimic execute_action unless $@
  def execute_action
    if @active_battler.action.mimic?
      if @active_battler.action.friends_unit.valid_last_action?(@active_battler)
        # Do failed mimic
        @active_battler.action.set_failed_mimic
        execute_action_failed_mimic
        @active_battler.action.clear
      else
        last_action = @active_battler.action.friends_unit.last_action
        # Do last action
        @active_battler.override_no_mp_cost = BATTLECOMMANDS_CONFIG::BC_MIMIC_NO_MP_COST
        @active_battler.override_consume_item = BATTLECOMMANDS_CONFIG::BC_MIMIC_CONSUME_ITEM
        if last_action.is_a?(Array)
          @active_battler.set_multi_actions(last_action.size)
          for action in last_action
            new_action = action.dup
            new_action.battler = @active_battler
            @active_battler.add_multi_action(new_action)
          end
        else
          @active_battler.action = last_action.dup
          @active_battler.action.battler = @active_battler
        end
        
        if !BATTLECOMMANDS_CONFIG::BC_MIMIC_REPEAT_INDEFINITELY
          # Remove the last action (otherwise you can do the same thing over and over)
          @active_battler.action.friends_unit.last_action = nil
        end
        
        execute_action_bc_mimic
        @active_battler.override_no_mp_cost = nil
        @active_battler.override_consume_item = nil  
      end
    else
      # Set this action to the last action of this unit
      last_action = nil
      if @active_battler.multi_actions?
        last_action = []
        for action in @active_battler.multi_actions
          last_action.push(action.dup)
        end
      else
        last_action = @active_battler.action.dup
      end

      @active_battler.action.friends_unit.last_action = last_action

      execute_action_bc_mimic
    end
  end
  
  #--------------------------------------------------------------------------
  # * Execute Battle Action: Failed Mimic
  #--------------------------------------------------------------------------
  def execute_action_failed_mimic
    @top_help_window.set_text("Nothing to Mimic")
    @top_help_window.visible = true
    @active_battler.stamina_wait = true
    @active_battler.empty_stamina
    execute_basic_action(nil)
    @top_help_window.visible = false
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
    alias battle_commands_strings_bc_mimic battle_commands_strings unless $@
    def battle_commands_strings
      return battle_commands_strings_bc_mimic.merge(
      {
       BATTLECOMMANDS_CONFIG::BC_MIMIC => ["Mimic", "Mimes last team partner action"]
      })
    end
    
  end
end

