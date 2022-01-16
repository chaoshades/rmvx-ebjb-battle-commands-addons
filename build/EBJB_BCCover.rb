################################################################################
#                     EBJB Cover Command - EBJB_BCCOVER               #   VX   #
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
$imported["EBJB_BCCOVER"] = true

#==============================================================================
# ** BATTLECOMMANDS_CONFIG
#------------------------------------------------------------------------------
#  Contains the BattleCommands_Config configuration
#==============================================================================

module EBJB
  
  module BATTLECOMMANDS_CONFIG
    
    #------------------------------------------------------------------------
    # Cover Command related 
    #------------------------------------------------------------------------
    
    # True to enable protection from physical damage, else false
    PROTECT_PHYSICAL = true
    # True to enable protection from magic (skills) damage, else false
    PROTECT_SKILLS = true
    
    # This is the number of allies one character can protect at the same time
    PROTECT_LIMIT = 1
    # This is a percentage of damage the protector will take when protecting
    # an ally. For example, if this value is set to 50, the protector will take
    # half damage when protecting an ally.
    DAMAGE_EFFECT = 100
    
    #------------------------------------------------------------------------
    # Battle Commands Definitions
    #------------------------------------------------------------------------
    
    # Unique ids used to represent battle commands
    # BATTLE_COMMAND = 10xx
    BC_COVER = Utilities.generate_battle_command_uid("BC_COVER2")
    
    # Battle commands data
    DATA_BATTLE_COMMANDS.push(Battle_Command.new(BC_COVER, BC_COVER, nil, false))
    
    # Actor Battle Commands Settings
    #   syntax: actor_id => [LearningBattleCommand.new('type', ...), ...]
    #   Where 'type' is one of the Battle commands above
    CLASS_BATTLE_COMMANDS_LEARNINGS[1].push(LearningBattleCommand.new(BC_COVER))
    
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
  # * Set Cover Attack
  #--------------------------------------------------------------------------
  def set_cover
    @kind = 0
    @basic = 15
  end
  
  #--------------------------------------------------------------------------
  # * Cover Attack Determination
  #--------------------------------------------------------------------------
  def cover?
    return (@kind == 0 and @basic == 15)
  end
  
  #--------------------------------------------------------------------------
  # * Alias determine_action_name
  #--------------------------------------------------------------------------
  alias determine_action_name_bc_cover determine_action_name unless $@
  def determine_action_name()
    action_name = ""
    if self.cover?
      action_name = "Cover"
    else
      action_name = determine_action_name_bc_cover
    end
    
    return action_name
  end
  
  #--------------------------------------------------------------------------
  # * Alias valid?
  #--------------------------------------------------------------------------
  alias valid_bc_cover? valid? unless $@
  def valid?
    return true if cover? 
    return valid_bc_cover?
  end
  
  #--------------------------------------------------------------------------
  # * Alias available_targets
  #--------------------------------------------------------------------------
  alias available_targets_bc_cover available_targets unless $@
  def available_targets
    if self.cover?
      targets = []
      targets += friends_unit.existing_members
      # Prevent Cover on self
      targets.delete(@battler)
      
      # Prevent Cover on a char that is already protected
      targets.each do |ally|
        targets.delete(ally) if ally.protected?
      end

      return targets
    else
      return available_targets_bc_cover
    end
  end
  
  #--------------------------------------------------------------------------
  # * Alias make_targets
  #--------------------------------------------------------------------------
  alias make_targets_bc_cover make_targets unless $@
  def make_targets
    if self.cover?
      return [available_targets[0]]
    else
      return make_targets_bc_cover
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
  
  #//////////////////////////////////////////////////////////////////////////
  # * Attributes
  #//////////////////////////////////////////////////////////////////////////
  
  # 
  attr_accessor :protecting
  # Keeps reference to the protector
  attr_accessor :protector
  
  #//////////////////////////////////////////////////////////////////////////
  # * Properties
  #//////////////////////////////////////////////////////////////////////////
  
  def protected?
    return !@protector.nil?
  end
  
  #//////////////////////////////////////////////////////////////////////////
  # * Constructor
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Alias initialize
  #--------------------------------------------------------------------------
  alias initialize_bc_cover initialize unless $@
  def initialize
    @protector = nil
    @protecting = false
    initialize_bc_cover
  end
  
  #//////////////////////////////////////////////////////////////////////////
  # * Public Methods
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Alias make_attack_damage_value
  #--------------------------------------------------------------------------
  alias make_attack_damage_value_bc_cover make_attack_damage_value unless $@
  def make_attack_damage_value(attacker, effect = nil)
    make_attack_damage_value_bc_cover(attacker)
    if protected? && (!@protector.movable? || !@protector.exist?)
      @protector = nil
    end
    
    if protected? && BATTLECOMMANDS_CONFIG::PROTECT_PHYSICAL && 
       !$game_party.members.include?(attacker)
      @hp_damage *= ((100 - BATTLECOMMANDS_CONFIG::DAMAGE_EFFECT) / 100)
      @protector.protecting = true
      @protector.attack_effect(attacker)
    end
    if @protecting
      @hp_damage *= (BATTLECOMMANDS_CONFIG::DAMAGE_EFFECT / 100)
      @protecting = false
    end
  end
  
  #--------------------------------------------------------------------------
  # * Alias make_obj_damage_value
  #--------------------------------------------------------------------------
  alias make_obj_damage_value_bc_cover make_obj_damage_value unless $@
  def make_obj_damage_value(user, obj)
    make_obj_damage_value_bc_cover(user, obj)
    if protected? && (!@protector.movable? || !@protector.exist?)
      @protector = nil
    end
    
    if protected? && BATTLECOMMANDS_CONFIG::PROTECT_SKILLS && 
       !$game_party.members.include?(user)
      @hp_damage *= ((100 - BATTLECOMMANDS_CONFIG::DAMAGE_EFFECT) / 100)
      @mp_damage *= ((100 - BATTLECOMMANDS_CONFIG::DAMAGE_EFFECT) / 100)
      @protector.protecting = true
      @protector.skill_effect(user, obj)
    end
    if @protecting
      @hp_damage *= (BATTLECOMMANDS_CONFIG::DAMAGE_EFFECT / 100)
      @mp_damage *= (BATTLECOMMANDS_CONFIG::DAMAGE_EFFECT / 100)
      @protecting = false
    end
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
  alias execute_battle_commands_bc_cover execute_battle_commands unless $@
  def execute_battle_commands(actor)
    command = @actor_command_window.selected_command
    if command.type == BATTLECOMMANDS_CONFIG::BC_COVER
      Sound.play_decision
      actor.action.set_cover
      start_target_actor_selection
    else
      execute_battle_commands_bc_cover(actor)
    end
  end
  
  #--------------------------------------------------------------------------
  # * Alias execute_action
  #--------------------------------------------------------------------------
  alias execute_action_bc_cover execute_action unless $@
  def execute_action
    if @active_battler.action.cover? 
      execute_action_cover
      @active_battler.action.clear
    else
      execute_action_bc_cover
    end
  end
  
  #--------------------------------------------------------------------------
  # * Execute Battle Action: Cover
  #--------------------------------------------------------------------------
  def execute_action_cover
    @top_help_window.set_text(@active_battler.action.determine_action_name)
    @top_help_window.visible = true
    @active_battler.stamina_wait = true
    @active_battler.empty_stamina
    
    $game_party.members.each do |ally|
      ally.protector = nil if ally.protected? && ally.protector == @active_battler
    end
    
    target = @active_battler.action.target_index
    $game_party.members[target].protector = @active_battler
    
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
    alias battle_commands_strings_bc_cover battle_commands_strings unless $@
    def battle_commands_strings
      return battle_commands_strings_bc_cover.merge(
      {
       BATTLECOMMANDS_CONFIG::BC_COVER => ["Cover", "Covers partners that are low on health"]
      })
    end
    
  end
end

