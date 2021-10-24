################################################################################
#                      EBJB Jump Command - EBJB_BCJUMP                #   VX   #
#                          Last Update: 2012/07/31                    ##########
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
$imported["EBJB_BCJUMP"] = true

#==============================================================================
# ** BATTLESYSTEM_CONFIG
#------------------------------------------------------------------------------
#  Contains the BattleSystem_Config configuration
#==============================================================================

module EBJB
  
  module BATTLESYSTEM_CONFIG
    
    #------------------------------------------------------------------------
    # Battle Animations Definitions
    #------------------------------------------------------------------------
    
    # Unique ids used to represent Battle actions
    # BATTLE_ACTION = 10xx
    # 
    BA_JUMP   = Utilities.generate_battle_action_uid("BA_JUMP")
    # 
    BA_LAND   = Utilities.generate_battle_action_uid("BA_LAND")
    
    # Actor Battle Action Animations definitions
    #   syntax: actor_id => {'type' => animation_id}
    #   Where 'type' is one of the IP modes above
    ACTOR_BA_ANIMS[1][BA_JUMP] = 194
    ACTOR_BA_ANIMS[1][BA_LAND] = 195
    
  end
end

#==============================================================================
# ** BATTLECOMMANDS_CONFIG
#------------------------------------------------------------------------------
#  Contains the BattleCommands_Config configuration
#==============================================================================

module EBJB
  
  module BATTLECOMMANDS_CONFIG

    #------------------------------------------------------------------------
    # Jump Command related 
    #------------------------------------------------------------------------
    
    # Number of turns before landing
    BC_JUMP_TURNS = 3
    
    # True to enable landing on random turns 
    # (ex.: for 3 turns, it may land after 1, 2 or 3 turns)  
    BC_RANDOM_JUMP_TURNS = true
    
    # Jump bonus damage rate (applied to the battler)
    BC_JUMP_BONUS_DMG_RATE = 50
    
    #------------------------------------------------------------------------
    # Battle Commands Definitions
    #------------------------------------------------------------------------
    
    # Unique ids used to represent battle commands
    # BATTLE_COMMAND = 10xx
    BC_JUMP = Utilities.generate_battle_command_uid("BC_JUMP")
    
    # Battle commands data
    DATA_BATTLE_COMMANDS.push(Battle_Command.new(BC_JUMP, BC_JUMP))
    
    # Actor Battle Commands Settings
    #   syntax: actor_id => [LearningBattleCommand.new('type', ...), ...]
    #   Where 'type' is one of the Battle commands above
    CLASS_BATTLE_COMMANDS_LEARNINGS[1].push(LearningBattleCommand.new(BC_JUMP))
    
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
  # * Set Jump Attack
  #--------------------------------------------------------------------------
  def set_jump
    @kind = 0
    @basic = 4
  end
  
  #--------------------------------------------------------------------------
  # * Jump Attack Determination
  #--------------------------------------------------------------------------
  def jump?
    return (@kind == 0 and @basic == 4)
  end
  
  #--------------------------------------------------------------------------
  # * Alias determine_action_name
  #--------------------------------------------------------------------------
  alias determine_action_name_bc_jump determine_action_name unless $@
  def determine_action_name()
    action_name = ""
    if self.jump?
      action_name = "Jump"
    else
      action_name = determine_action_name_bc_jump
    end
    
    return action_name
  end
  
#~   #--------------------------------------------------------------------------
#~   # * Alias available_targets
#~   #--------------------------------------------------------------------------
#~   alias available_targets_bc_jump available_targets unless $@
#~   def available_targets
#~     if jump?
#~       return opponents_unit.existing_members
#~     else
#~       return available_targets_bc_jump
#~     end
#~   end
  
  #--------------------------------------------------------------------------
  # * Alias make_targets
  #--------------------------------------------------------------------------
  alias make_targets_bc_jump make_targets unless $@
  def make_targets
    if jump?
      return make_attack_targets
    else
      return make_targets_bc_jump
    end
  end
  
  #--------------------------------------------------------------------------
  # * Alias valid?
  #--------------------------------------------------------------------------
  alias valid_bc_jump? valid? unless $@
  def valid?
    return true if jump?
    return valid_bc_jump?
  end
  
end
#==============================================================================
# ** Game_BattleAnimation
#------------------------------------------------------------------------------
#  This class deals with the battles animations in battle. It is referenced by
# the Game_Battler and Game_Projectile classes.
#==============================================================================

class Game_BattleAnimation
  include EBJB
  
  #//////////////////////////////////////////////////////////////////////////
  # * Properties
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Checks if animation action is Jumping
  #--------------------------------------------------------------------------
  def is_jumping?
    return @animation_action == BATTLESYSTEM_CONFIG::BA_JUMP
  end
  
  #--------------------------------------------------------------------------
  # * Checks if animation action is Landing
  #--------------------------------------------------------------------------
  def is_landing?
    return @animation_action == BATTLESYSTEM_CONFIG::BA_LAND
  end
  
  #//////////////////////////////////////////////////////////////////////////
  # * Public Methods
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Do Jump animation
  #--------------------------------------------------------------------------
  def do_ani_jump
    @animation_loop = false
    set_action_ani(BATTLESYSTEM_CONFIG::BA_JUMP)
  end
  
  #--------------------------------------------------------------------------
  # * Do Land animation
  #--------------------------------------------------------------------------
  def do_ani_land
    @animation_loop = false
    set_action_ani(BATTLESYSTEM_CONFIG::BA_LAND)
  end
  
#~   #--------------------------------------------------------------------------
#~   # * Alias do_next_battle_animation
#~   #--------------------------------------------------------------------------
#~   alias do_next_battle_animation_bc_jump do_next_battle_animation unless $@
#~   def do_next_battle_animation
#~     case @animation_action
#~     when BATTLESYSTEM_CONFIG::BA_JUMP
#~       do_ani_stand
#~     when BATTLESYSTEM_CONFIG::BA_LAND
#~       do_ani_stand
#~     end
#~     do_next_battle_animation_bc_jump
#~   end
  
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
  # * Properties
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Alias ready_for_action?
  #--------------------------------------------------------------------------
  alias ready_for_action_bc_jump? ready_for_action? unless $@
  def ready_for_action?
    if full_stamina? && @battle_animation.is_jumping?
      ready = false
      
      if @temp_jump_count == nil
        if BATTLECOMMANDS_CONFIG::BC_RANDOM_JUMP_TURNS
          turns_to_add = rand(BATTLECOMMANDS_CONFIG::BC_JUMP_TURNS)
        else
          turns_to_add = BATTLECOMMANDS_CONFIG::BC_JUMP_TURNS
        end
        
        @temp_jump_count = self.turn_count + turns_to_add
      end
      
      self.empty_stamina
      self.increase_turn_count

      if self.turn_count >= @temp_jump_count
        ready = true
        @temp_jump_count = nil
      end
      
      return ready
    else
      return ready_for_action_bc_jump?
    end
  end
  
  #//////////////////////////////////////////////////////////////////////////
  # * Constructors
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Alias initialize
  #--------------------------------------------------------------------------
  alias initialize_bc_jump initialize unless $@
  def initialize
    initialize_bc_jump
    @temp_jump_count = nil
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
  alias execute_battle_commands_bc_jump execute_battle_commands unless $@
  def execute_battle_commands(actor)
    command = @actor_command_window.selected_command
    if command.type == BATTLECOMMANDS_CONFIG::BC_JUMP
      Sound.play_decision
      actor.action.set_jump
      start_target_enemy_selection
    else
      execute_battle_commands_bc_jump(actor)
    end
  end
  
  #--------------------------------------------------------------------------
  # * Alias execute_action
  #--------------------------------------------------------------------------
  alias execute_action_bc_jump execute_action unless $@
  def execute_action
    if @active_battler.action.jump?

      if @active_battler.battle_animation.is_jumping?
        execute_action_land
        @active_battler.action.clear
      else
        execute_action_jump
      end
    else
      execute_action_bc_jump
    end
  end
  
  #--------------------------------------------------------------------------
  # * 
  #--------------------------------------------------------------------------
  alias battler_update_stamina_bc_jump battler_update_stamina unless $@
  def battler_update_stamina(battler)
    if battler.battle_animation.is_jumping?
      battler.increase_stamina
    else
      battler_update_stamina_bc_jump(battler)
    end
  end
  
  #--------------------------------------------------------------------------
  # * Alias make_auto_action
  #--------------------------------------------------------------------------
  alias make_auto_action_bc_jump make_auto_action unless $@
  def make_auto_action(battler)
    action_made = make_auto_action_bc_jump(battler)
    if !action_made && battler.battle_animation.is_jumping?
      return true
    end
    return action_made
  end
  
  #--------------------------------------------------------------------------
  # * Execute Battle Action: Jump
  #--------------------------------------------------------------------------
  def execute_action_jump
    @top_help_window.set_text(@active_battler.action.determine_action_name)
    @top_help_window.visible = true
    @active_battler.stamina_wait = true
    @active_battler.empty_stamina
    @active_battler.hidden = true
    @active_battler.battle_animation.do_ani_jump
    @top_help_window.visible = false
  end
  
  #--------------------------------------------------------------------------
  # * Execute Battle Action: Land
  #--------------------------------------------------------------------------
  def execute_action_land
    @active_battler.stamina_wait = true
    @active_battler.empty_stamina
    execute_basic_action(nil)
    @active_battler.hidden = false
  end
  
  #--------------------------------------------------------------------------
  # * 
  #     obj : 
  #--------------------------------------------------------------------------
  alias determine_custom_battler_animation_bc_jump determine_custom_battler_animation unless $@
  def determine_custom_battler_animation(battler, obj)
    if battler.action.jump?
      return CustomAnim.new(nil, BATTLESYSTEM_CONFIG::MOVE_TARGET_INSTANT)
    else
      return determine_custom_battler_animation_bc_jump(battler, obj)
    end
  end
#~   
#~   #--------------------------------------------------------------------------
#~   # * 
#~   #     obj : 
#~   #--------------------------------------------------------------------------
#~   def determine_custom_action_times(battler, obj)
#~     return 1
#~   end
  
  #--------------------------------------------------------------------------
  # * 
  #     obj : 
  #--------------------------------------------------------------------------
  alias do_custom_animation_bc_jump do_custom_animation unless $@
  def do_custom_animation(battler, obj)
    if battler.action.jump?
      battler.battle_animation.do_ani_land
    else
      do_custom_animation_bc_jump(battler, obj)
    end
  end

  #--------------------------------------------------------------------------
  # * 
  #     obj : 
  #--------------------------------------------------------------------------
  alias do_custom_target_effect_bc_jump do_custom_target_effect unless $@
  def do_custom_target_effect(battler, target, obj)
    if battler.action.jump?
      temp = battler.clone
      temp.atk += (temp.atk * (BATTLECOMMANDS_CONFIG::BC_JUMP_BONUS_DMG_RATE / 100.0))
      target.attack_effect(temp)
    else
      do_custom_target_effect_bc_jump(battler, target, obj)
    end
  end
  
  #--------------------------------------------------------------------------
  # * 
  #     obj : 
  #--------------------------------------------------------------------------
  alias display_custom_animation_bc_jump display_custom_animation unless $@
  def display_custom_animation(battler, targets)
    if battler.action.jump?
      display_attack_animation(targets, false)
    else
      display_custom_animation_bc_jump(battler, targets)
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
    alias battle_commands_strings_bc_jump battle_commands_strings unless $@
    def battle_commands_strings
      return battle_commands_strings_bc_jump.merge(
      {
       BATTLECOMMANDS_CONFIG::BC_JUMP => ["Jump", "Attacks by jumping on the target"]
      })
    end
    
  end
end


