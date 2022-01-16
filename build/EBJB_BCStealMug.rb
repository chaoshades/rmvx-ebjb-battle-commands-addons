################################################################################
#                     EBJB Steal Command - EBJB_BCSTEAL               #   VX   #
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
$imported["EBJB_BCSTEAL"] = true

#==============================================================================
# ** BATTLECOMMANDS_CONFIG
#------------------------------------------------------------------------------
#  Contains the BattleCommands_Config configuration
#==============================================================================

module EBJB
  
  #==============================================================================
  # ** StealItem
  #------------------------------------------------------------------------------
  #  Represents a
  #==============================================================================

  class StealItem
    
    #//////////////////////////////////////////////////////////////////////////
    # * Attributes
    #//////////////////////////////////////////////////////////////////////////
    
    attr_accessor :kind
    attr_accessor :item_id
    attr_accessor :denominator

    #//////////////////////////////////////////////////////////////////////////
    # * Properties
    #//////////////////////////////////////////////////////////////////////////
    
    #--------------------------------------------------------------------------
    # * Determine if battler is animated
    #--------------------------------------------------------------------------
    def item
      item = nil
      case @kind
      when 0
        item = $data_items[@item_id]
      when 1
        item = $data_weapons[@item_id]
      when 2
        item = $data_armors[@item_id]
      end
      return item
    end
    
    #//////////////////////////////////////////////////////////////////////////
    # * Constructors
    #//////////////////////////////////////////////////////////////////////////
    
    #--------------------------------------------------------------------------
    # * Object Initialization
    #     kind : Type of the drop item (0: none, 1: item, 2: weapon, 3: armor)
    #     id : item id
    #     denom  : steal rate denominator
    #--------------------------------------------------------------------------
    def initialize(kind, id, denom)
      @kind = kind
      @item_id = id
      @denominator = denom
    end
        
  end

  module BATTLECOMMANDS_CONFIG
    
    #------------------------------------------------------------------------
    # Steal Command related 
    #------------------------------------------------------------------------
    
    # True to steal only one item from a monster in combat, else false
    BC_STEAL_ONLY_ONCE = false
    
    # True for agility based steal, else false
    BC_STEAL_AGILITY_BASED = true
    
    # Items ID that be stealed from enemies
    #   syntax: enemy_id => array of StealItem
    BC_STEAL_ENEMY_STEALS_ID = {
      1 => [StealItem.new(0, 1, 2), StealItem.new(1, 1, 2), StealItem.new(2, 1, 2),
            StealItem.new(0, 8, 256)]
    }
    
    # Items ID that add a bonus to Steal
    #   syntax: item_id => rate
    BC_STEAL_WEAPON_BONUS_ID = {
      34 => 50
    }
    # Items ID that add a bonus to Steal
    #   syntax: item_id => rate
    BC_STEAL_ARMOR_BONUS_ID = {
      32 => 10
    }
    
    #------------------------------------------------------------------------
    # Battle Commands Definitions
    #------------------------------------------------------------------------
    
    # Unique ids used to represent battle commands
    # BATTLE_COMMAND = 10xx
    BC_STEAL = Utilities.generate_battle_command_uid("BC_STEAL")
    BC_MUG = Utilities.generate_battle_command_uid("BC_MUG")
    
    # Battle commands data
    DATA_BATTLE_COMMANDS.push(Battle_Command.new(BC_STEAL, BC_STEAL))
    DATA_BATTLE_COMMANDS.push(Battle_Command.new(BC_MUG, BC_MUG))
    
    # Actor Battle Commands Settings
    #   syntax: actor_id => [LearningBattleCommand.new('type', ...), ...]
    #   Where 'type' is one of the Battle commands above
    CLASS_BATTLE_COMMANDS_LEARNINGS[1].push(LearningBattleCommand.new(BC_STEAL))
    CLASS_BATTLE_COMMANDS_LEARNINGS[1].push(LearningBattleCommand.new(BC_MUG))
    
  end
end

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
    BA_STEAL   = Utilities.generate_battle_action_uid("BA_STEAL")
    BA_MUG     = Utilities.generate_battle_action_uid("BA_MUG")
    
    # Actor Battle Action Animations definitions
    #   syntax: actor_id => {'type' => animation_id}
    #   Where 'type' is one of the IP modes above
    ACTOR_BA_ANIMS[1][BA_STEAL] = 199
    ACTOR_BA_ANIMS[1][BA_MUG] = 200

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
  # * Set Steal Attack
  #--------------------------------------------------------------------------
  def set_steal
    @kind = 0
    @basic = 9
  end
  
  #--------------------------------------------------------------------------
  # * Set Mug Attack
  #--------------------------------------------------------------------------
  def set_mug
    @kind = 0
    @basic = 10
  end
  
  #--------------------------------------------------------------------------
  # * Steal Attack Determination
  #--------------------------------------------------------------------------
  def steal?
    return (@kind == 0 and @basic == 9)
  end
  
  #--------------------------------------------------------------------------
  # * Mug Attack Determination
  #--------------------------------------------------------------------------
  def mug?
    return (@kind == 0 and @basic == 10)
  end
  
  #--------------------------------------------------------------------------
  # * Alias determine_action_name
  #--------------------------------------------------------------------------
  alias determine_action_name_bc_steal determine_action_name unless $@
  def determine_action_name()
    action_name = ""
    if self.steal?
      action_name = "Steal"
    elsif self.mug?
      action_name = "Mug"
    else
      action_name = determine_action_name_bc_steal
    end
    
    return action_name
  end
  
  #--------------------------------------------------------------------------
  # * Alias make_targets
  #--------------------------------------------------------------------------
  alias make_targets_bc_steal make_targets unless $@
  def make_targets
    if steal? || self.mug?
      return make_attack_targets
    else
      return make_targets_bc_steal
    end
  end
  
  #--------------------------------------------------------------------------
  # * Alias valid?
  #--------------------------------------------------------------------------
  alias valid_bc_steal? valid? unless $@
  def valid?
    return true if steal? || self.mug?
    return valid_bc_steal?
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
  # * Checks if animation action is Stealing
  #--------------------------------------------------------------------------
  def is_stealing?
    return @animation_action == BATTLESYSTEM_CONFIG::BA_STEAL
  end
  
  #--------------------------------------------------------------------------
  # * Checks if animation action is Mugging
  #--------------------------------------------------------------------------
  def is_mugging?
    return @animation_action == BATTLESYSTEM_CONFIG::BA_MUG
  end
  
  #//////////////////////////////////////////////////////////////////////////
  # * Public Methods
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Do Steal animation
  #--------------------------------------------------------------------------
  def do_ani_steal
    @animation_loop = false
    set_action_ani(BATTLESYSTEM_CONFIG::BA_STEAL)
  end
  
  #--------------------------------------------------------------------------
  # * Do Steal animation
  #--------------------------------------------------------------------------
  def do_ani_mug
    @animation_loop = false
    set_action_ani(BATTLESYSTEM_CONFIG::BA_MUG)
  end
  
  #--------------------------------------------------------------------------
  # * Alias do_next_battle_animation
  #--------------------------------------------------------------------------
  alias do_next_battle_animation_bc_steal do_next_battle_animation unless $@
  def do_next_battle_animation
    case @animation_action
    when BATTLESYSTEM_CONFIG::BA_STEAL
      do_ani_stand
    when BATTLESYSTEM_CONFIG::BA_MUG
      do_ani_stand
    end
    do_next_battle_animation_bc_steal
  end
  
end
#==============================================================================
# ** Game_Enemy
#------------------------------------------------------------------------------
#  This class handles enemy characters. It's used within the Game_Troop class
# ($game_troop).
#==============================================================================

class Game_Enemy < Game_Battler
  include EBJB
  
  #//////////////////////////////////////////////////////////////////////////
  # * Attributes
  #//////////////////////////////////////////////////////////////////////////
  
  # Array containing the steal items
  attr_reader :steal_items
  
  #//////////////////////////////////////////////////////////////////////////
  # * Constructors
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Alias initialize
  #--------------------------------------------------------------------------
  alias game_enemy_initialize_bc_steal initialize unless $@
  def initialize(index, enemy_id)
    game_enemy_initialize_bc_steal(index, enemy_id)
    if enemy.steal_items != nil
      @steal_items = enemy.steal_items.clone
    end
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
  # * Get total Steal rate bonus
  #--------------------------------------------------------------------------
  def total_steal_rate_bonus()
    n = 0
    equips.compact.each { |item| n += item.steal_rate_bonus }
    return n
  end

end

#===============================================================================
# ** RPG::Enemy Addon
#------------------------------------------------------------------------------
#  Addon functions 
#===============================================================================

class RPG::Enemy
  include EBJB
  
  #//////////////////////////////////////////////////////////////////////////
  # * Properties
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Get Steal items of the enemy 
  #--------------------------------------------------------------------------
  # GET
  def steal_items
    return BATTLECOMMANDS_CONFIG::BC_STEAL_ENEMY_STEALS_ID[self.id]
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
  # * Get Steal rate bonus
  #--------------------------------------------------------------------------
  # GET
  def steal_rate_bonus
    bonus = BATTLECOMMANDS_CONFIG::BC_STEAL_WEAPON_BONUS_ID[self.id]
    if bonus == nil
      bonus = 0
    end
    return bonus
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
  # * Get Steal rate bonus
  #--------------------------------------------------------------------------
  # GET
  def steal_rate_bonus
    bonus = BATTLECOMMANDS_CONFIG::BC_STEAL_ARMOR_BONUS_ID[self.id]
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
  alias execute_battle_commands_bc_steal execute_battle_commands unless $@
  def execute_battle_commands(actor)
    command = @actor_command_window.selected_command
    if command.type == BATTLECOMMANDS_CONFIG::BC_STEAL
      Sound.play_decision
      actor.action.set_steal
      start_target_enemy_selection
    elsif command.type == BATTLECOMMANDS_CONFIG::BC_MUG
      Sound.play_decision
      actor.action.set_mug
      start_target_enemy_selection
    else
      execute_battle_commands_bc_steal(actor)
    end
  end
  
  #--------------------------------------------------------------------------
  # * Alias execute_action
  #--------------------------------------------------------------------------
  alias execute_action_bc_steal execute_action unless $@
  def execute_action
    if @active_battler.action.steal? || @active_battler.action.mug? 
      execute_action_steal
      @active_battler.action.clear
    else
      execute_action_bc_steal
    end
  end
  
  #--------------------------------------------------------------------------
  # * Execute Battle Action: Steal
  #--------------------------------------------------------------------------
  def execute_action_steal
    @top_help_window.set_text(@active_battler.action.determine_action_name)
    @top_help_window.visible = true
    @active_battler.stamina_wait = true
    @active_battler.empty_stamina
    execute_basic_action(nil)
    @top_help_window.visible = false
  end
  
  #--------------------------------------------------------------------------
  # * 
  #     obj : 
  #--------------------------------------------------------------------------
  alias determine_custom_battler_animation_bc_steal determine_custom_battler_animation unless $@
  def determine_custom_battler_animation(battler, obj)
    if battler.action.steal? || @active_battler.action.mug? 
      return CustomAnim.new(nil, BATTLESYSTEM_CONFIG::MOVE_TARGET)
    else
      return determine_custom_battler_animation_bc_steal(battler, obj)
    end
  end
  
  #--------------------------------------------------------------------------
  # * 
  #     obj : 
  #--------------------------------------------------------------------------
  alias do_custom_animation_bc_steal do_custom_animation unless $@
  def do_custom_animation(battler, obj)
    if battler.action.steal?
      battler.battle_animation.do_ani_steal
    elsif battler.action.mug?
      battler.battle_animation.do_ani_mug
    else
      do_custom_animation_bc_steal(battler, obj)
    end
  end

  #--------------------------------------------------------------------------
  # * 
  #     obj : 
  #--------------------------------------------------------------------------
  alias do_custom_target_effect_bc_steal do_custom_target_effect unless $@
  def do_custom_target_effect(battler, target, obj)
    if battler.action.steal?
      do_steal_target_effect(battler, target)
    elsif battler.action.mug?
      do_steal_target_effect(battler, target)
      target.attack_effect(battler)
    else
      do_custom_target_effect_bc_steal(battler, target, obj)
    end
  end
  
  #--------------------------------------------------------------------------
  # * 
  #     obj : 
  #--------------------------------------------------------------------------
  def do_steal_target_effect(battler, target)
    steal_items = target.steal_items
    if steal_items == nil || steal_items.length == 0
      @top_help_window.set_text(Vocab::no_steal_text)
    else
      # Determine steal ratio with bonus
      ratio = 1
      if BATTLECOMMANDS_CONFIG::BC_STEAL_AGILITY_BASED
        ratio = [target.agi, 1].max / [battler.agi, 1].max.to_f
      end
      ratio -= battler.total_steal_rate_bonus.to_f / 100

      # Takes randomly one item in the list
      index = rand(steal_items.length)

      # Determines if the item is successfully stolen
      stolen_item = nil
      denom = (steal_items[index].denominator * ratio).ceil
      if denom <= 1 || rand(denom) == 0
        stolen_item = steal_items[index]
      end
      
      if stolen_item == nil
        @top_help_window.set_text(Vocab::failed_steal_text)
      else
        $game_party.gain_item(stolen_item.item, 1)
        if (BATTLECOMMANDS_CONFIG::BC_STEAL_ONLY_ONCE)
          target.steal_items.clear
        else
          target.steal_items.delete(stolen_item)
        end
        message = sprintf(Vocab::success_steal_text, stolen_item.item.name)
        @top_help_window.set_text(message)
      end
    end
  end
  
  #--------------------------------------------------------------------------
  # * 
  #     obj : 
  #--------------------------------------------------------------------------
  alias display_custom_animation_bc_steal display_custom_animation unless $@
  def display_custom_animation(battler, targets)
    if battler.action.mug?
      display_attack_animation(targets, false)
    else
      display_custom_animation_bc_steal(battler, targets)
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
    alias battle_commands_strings_bc_steal battle_commands_strings unless $@
    def battle_commands_strings
      return battle_commands_strings_bc_steal.merge(
      {
       BATTLECOMMANDS_CONFIG::BC_STEAL => ["Steal", "Steals from a target"],
       BATTLECOMMANDS_CONFIG::BC_MUG => ["Mug", "Steals from a target and attacks if afterwards"]
      })
    end
    
  end
  
  #--------------------------------------------------------------------------
  # * Get Text to show in battle help when there is nothing to steal
  #--------------------------------------------------------------------------
  def self.no_steal_text
    return "Nothing to steal"
  end
  
  #--------------------------------------------------------------------------
  # * Get Text to show in battle help when failing to steal
  #--------------------------------------------------------------------------
  def self.failed_steal_text
    return "Couldn't steal anything"
  end
  
  #--------------------------------------------------------------------------
  # * Get Text to show in battle help when stealing successfully
  #--------------------------------------------------------------------------
  def self.success_steal_text
    return "You stole %s"
  end
end

