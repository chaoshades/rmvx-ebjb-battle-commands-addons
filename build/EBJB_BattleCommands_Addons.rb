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


################################################################################
#               EBJB Black Magic Command - EBJB_BCBLACKMAGIC          #   VX   #
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
$imported["EBJB_BCBLACKMAGIC"] = true

#==============================================================================
# ** BATTLECOMMANDS_CONFIG
#------------------------------------------------------------------------------
#  Contains the BattleCommands_Config configuration
#==============================================================================

module EBJB
  
  module BATTLECOMMANDS_CONFIG

    #------------------------------------------------------------------------
    # Black Magic Command related 
    #------------------------------------------------------------------------
    
    # Skills ID that are black magics
    BC_BLACK_MAGIC_SKILLS_ID = (59..82).to_a
    
    #------------------------------------------------------------------------
    # Battle Commands Definitions
    #------------------------------------------------------------------------
    
    # Unique ids used to represent battle commands
    # BATTLE_COMMAND = 10xx
    BC_BLACK_MAGIC = Utilities.generate_battle_command_uid("BC_BLACK_MAGIC")
    
    # Battle commands data
    DATA_BATTLE_COMMANDS.push(List_Command.new(BC_BLACK_MAGIC, BC_SKILL, UsableItemFilter.new("blackmagic")))
    
    # Actor Battle Commands Settings
    #   syntax: actor_id => [LearningBattleCommand.new('type', ...), ...]
    #   Where 'type' is one of the Battle commands above
    CLASS_BATTLE_COMMANDS_LEARNINGS[1].push(LearningBattleCommand.new(BC_BLACK_MAGIC))
    
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
  alias apply_bc_black_magic apply unless $@
  def apply(x)
    if x != nil && x.is_a?(RPG::UsableItem)
       
      case mode
        when "blackmagic"
          return applyBlackMagic(x)
        #when
          #...
        else
          return apply_bc_black_magic(x)
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
  def applyBlackMagic(x)
    if BATTLECOMMANDS_CONFIG::BC_BLACK_MAGIC_SKILLS_ID.include?(x.id)
      return true
    else
      return false
    end
  end
  private:applyBlackMagic
  
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
    alias battle_commands_strings_bc_black_magic battle_commands_strings unless $@
    def battle_commands_strings
      return battle_commands_strings_bc_black_magic.merge(
      {
       BATTLECOMMANDS_CONFIG::BC_BLACK_MAGIC => ["Black Magic", "Uses an offensive spell"]
      })
    end
    
  end
end


################################################################################
#               EBJB White Magic Command - EBJB_BCWHITEMAGIC          #   VX   #
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
$imported["EBJB_BCWHITEMAGIC"] = true

#==============================================================================
# ** BATTLECOMMANDS_CONFIG
#------------------------------------------------------------------------------
#  Contains the BattleCommands_Config configuration
#==============================================================================

module EBJB
  
  module BATTLECOMMANDS_CONFIG

    #------------------------------------------------------------------------
    # White Magic Command related 
    #------------------------------------------------------------------------
    
    # Skills ID that are white magics
    BC_WHITE_MAGIC_SKILLS_ID = (33..42).to_a
    
    #------------------------------------------------------------------------
    # Battle Commands Definitions
    #------------------------------------------------------------------------
    
    # Unique ids used to represent battle commands
    # BATTLE_COMMAND = 10xx
    BC_WHITE_MAGIC = Utilities.generate_battle_command_uid("BC_WHITE_MAGIC")
    
    # Battle commands data
    DATA_BATTLE_COMMANDS.push(List_Command.new(BC_WHITE_MAGIC, BC_SKILL, UsableItemFilter.new("whitemagic")))
    
    # Actor Battle Commands Settings
    #   syntax: actor_id => [LearningBattleCommand.new('type', ...), ...]
    #   Where 'type' is one of the Battle commands above
    CLASS_BATTLE_COMMANDS_LEARNINGS[1].push(LearningBattleCommand.new(BC_WHITE_MAGIC))
    
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
  alias apply_bc_white_magic apply unless $@
  def apply(x)
    if x != nil && x.is_a?(RPG::UsableItem)
       
      case mode
        when "whitemagic"
          return applyWhiteMagic(x)
        #when
          #...
        else
          return apply_bc_white_magic(x)
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
  def applyWhiteMagic(x)
    if BATTLECOMMANDS_CONFIG::BC_WHITE_MAGIC_SKILLS_ID.include?(x.id)
      return true
    else
      return false
    end
  end
  private:applyWhiteMagic
  
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
    alias battle_commands_strings_bc_white_magic battle_commands_strings unless $@
    def battle_commands_strings
      return battle_commands_strings_bc_white_magic.merge(
      {
       BATTLECOMMANDS_CONFIG::BC_WHITE_MAGIC => ["White Magic", "Uses an healing/defensive spell"]
      })
    end
    
  end
end


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


################################################################################
#                    EBJB Throw Command - EBJB_BCTHROW                #   VX   #
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
$imported["EBJB_BCTHROW"] = true

#==============================================================================
# ** BATTLECOMMANDS_CONFIG
#------------------------------------------------------------------------------
#  Contains the BattleCommands_Config configuration
#==============================================================================

module EBJB

  #==============================================================================
  # ** Throw_Command
  #------------------------------------------------------------------------------
  #  Represents a throwable weapon battle command
  #==============================================================================

  class Throw_Command < Battle_Command
    
    #//////////////////////////////////////////////////////////////////////////
    # * Attributes
    #//////////////////////////////////////////////////////////////////////////
    
    # Item ID
    attr_reader :item_id
    
    #//////////////////////////////////////////////////////////////////////////
    # * Properties
    #//////////////////////////////////////////////////////////////////////////
    
    #--------------------------------------------------------------------------
    # * Get the item object of the item battle command
    #--------------------------------------------------------------------------
    def item()
      return $data_weapons[@item_id]
    end
    
    #--------------------------------------------------------------------------
    # * Get the name of the item battle command
    #--------------------------------------------------------------------------
    def name()
      return $data_weapons[@item_id].name
    end
    
    #--------------------------------------------------------------------------
    # * Get the description of the item battle command
    #--------------------------------------------------------------------------
    def description()
      return $data_weapons[@item_id].description
    end
    
    #//////////////////////////////////////////////////////////////////////////
    # * Constructors
    #//////////////////////////////////////////////////////////////////////////
    
    #--------------------------------------------------------------------------
    # * Object Initialization
    #     id : id
    #     item_id : Item ID to get name and description of the battle command
    #     type :
    #--------------------------------------------------------------------------
    def initialize(id, item_id)
      super(id, BATTLECOMMANDS_CONFIG::BC_THROW)
      @item_id = item_id
    end
    
  end
    
  module BATTLECOMMANDS_CONFIG
  
    # Icons used for the Elemental Resistance Graph and the Elements icons list
    #0 = None           5 = Bow   (no)    10 = Ice    (105) 15 = Holy     (110) 
    #1 = Melee    (no)  6 = Whip  (no)    11 = Thunder(106) 16 = Darkness (111)
    #2 = Percing  (no)  7 = Mind  (no)    12 = Water  (107)
    #3 = Slashing (no)  8 = Absorb (no)   13 = Earth  (108)  
    #4 = Blow  (no)     9 = Fire   (104)  14 = Wind   (109)   
    ELEMENT_ICONS = [0,0,0,0,0,0,0,0,0,104,105,106,107,108,109,110,111]
    
    # Icons used for the Bonus stat in the Bonus icons list
    #0 = Two Handed (50)             2 = Prevent Critical (52) 
    #1 = Critical Bonus  (119)       3 = Half MP Cost (133) 
    BONUS_ICONS = [50,119,52,133]
    
    #------------------------------------------------------------------------
    # Item/Skill Details Window related
    #------------------------------------------------------------------------
    
    # Number of icons to show at the same time
    SW_LIST_MAX_ICONS = 4
    # Timeout in seconds before switching icons
    SW_LIST_ICONS_TIMEOUT = 1

    # Pattern used to show the value of the Recovery effect
    REC_PATTERN = "%d%%+%d"
    # Sign for plus state set
    STATES_PLUS_SIGN = "+"
    # Sign for minus state set
    STATES_MINUS_SIGN = "-"
    
    #------------------------------------------------------------------------
    # Throw Command related 
    #------------------------------------------------------------------------
    
    # Items ID that can be thrown
    BC_THROW_ITEMS_ID = [1,2,3,6,9,10,12,13,14,16,20,21,23,27,29,30,32,33]
    
    # Throw bonus damage rate (applied to weapon)
    BC_THROW_BONUS_DMG_RATE = 250
    
    #------------------------------------------------------------------------
    # Battle Commands Definitions
    #------------------------------------------------------------------------
    
    # Unique ids used to represent battle commands
    # BATTLE_COMMAND = 10xx
    BC_THROW = Utilities.generate_battle_command_uid("BC_THROW")
    
    # Battle commands data
    #WeaponFilter.new("throw")
    DATA_BATTLE_COMMANDS.push(List_Command.new(BC_THROW, BC_THROW))
    
    # Actor Battle Commands Settings
    #   syntax: actor_id => [LearningBattleCommand.new('type', ...), ...]
    #   Where 'type' is one of the Battle commands above
    CLASS_BATTLE_COMMANDS_LEARNINGS[1].push(LearningBattleCommand.new(BC_THROW))
    
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
    BA_THROW   = Utilities.generate_battle_action_uid("BA_THROW")
    
    # Actor Battle Action Animations definitions
    #   syntax: actor_id => {'type' => animation_id}
    #   Where 'type' is one of the IP modes above
    ACTOR_BA_ANIMS[1][BA_THROW] = 196

    # Actor Battler Settings
    #   syntax: actor_id => CustomBattler(width, height, move_speed, ba_show_weapon)
    ACTOR_BATTLER_SETTINGS[1].ba_show_weapon.push(BA_THROW)
    
    # Actor Weapon Animations definitions
    #   syntax: actor_id => {weapon_id => CustomAnim(animation_id, 'type'), ...}
    #   Where 'type' is one of the movement types above
    ACTOR_THROW_WEAPON_ANIMS = {
      1 => {1 => CustomAnim.new(nil, MOVE_STEPS, 0, 197),
            2 => CustomAnim.new(nil, MOVE_STEPS, 0, 197),
            3 => CustomAnim.new(nil, MOVE_STEPS, 0, 198)},
    }
    ACTOR_THROW_WEAPON_ANIMS.default = Hash.new(CustomAnim.new(nil, MOVE_STEPS))
    
  end
end

#===============================================================================
# ** RPG::Actor Addon
#------------------------------------------------------------------------------
#  Addon functions 
#===============================================================================

class RPG::Actor
  include EBJB
  
  #//////////////////////////////////////////////////////////////////////////
  # * Properties
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Get custom animation for throwable weapon
  #     weapon_id : weapon ID
  #--------------------------------------------------------------------------
  # GET
  def ani_throw_weapons(weapon_id=nil)
    if weapon_id == nil
      return BATTLESYSTEM_CONFIG::ACTOR_THROW_WEAPON_ANIMS[self.id]
    else
      return BATTLESYSTEM_CONFIG::ACTOR_THROW_WEAPON_ANIMS[self.id][weapon_id]
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
  # * Constructors
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Alias initialize
  #--------------------------------------------------------------------------
  alias setup_bc_throw setup unless $@
  def setup(actor_id)
    setup_bc_throw(actor_id)
    actor = $data_actors[actor_id]

    @battle_animation.ani_throw_weapons = actor.ani_throw_weapons
  end
  
  #//////////////////////////////////////////////////////////////////////////
  # * Public Methods
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Alias is_command_equipped?
  #--------------------------------------------------------------------------
  alias is_command_equipped_bc_throw? is_command_equipped? unless $@
  def is_command_equipped?(obj)
    if (obj.is_a?(RPG::Weapon))
      return active_battle_commands.any?{|c| c.is_a?(Throw_Command) && c.item_id == obj.id} || 
             is_command_equipped_bc_throw?(obj)
    elsif (obj.is_a?(Throw_Command))
      return active_battle_commands.any?{|c| c.id == obj.id} 
    else
      return is_command_equipped_bc_throw?(obj)
    end
  end
  
  #--------------------------------------------------------------------------
  # * Create Battle Action (for automatic battle)
  #--------------------------------------------------------------------------
  def make_autobattle_action
    @action.clear
    return unless movable?
    action = Game_BattleAction.new(self)
    
    command = self.autobattle_command
    if command.is_a?(Skill_Command)
      if command.is_custom
        action.forcing = true
      end
      if self.skill_can_use?(command.skill) || command.is_custom
        action.set_skill(command.skill.id)
      end
    elsif command.is_a?(Item_Command)
      if $game_party.item_can_use?(command.item)
        action.set_item(command.item.id)
      end
    elsif command.is_a?(Throw_Command)
      if $game_party.item_can_throw?(command.item)
        action.set_throw(command.item.id)
      end
    else
      case command.type
      when BATTLECOMMANDS_CONFIG::BC_ATTACK 
        action.set_attack
      when BATTLECOMMANDS_CONFIG::BC_GUARD
        action.set_guard
      end
    end
    
    action.evaluate
    
    #Keeps action if it has been evaluated, else don't do anything
    if action.value > 0
      @action = action
    end
  end
  
end

#==============================================================================
# ** Game_BattleAction
#------------------------------------------------------------------------------
#  This class handles battle actions. This class is used within the
# Game_Battler class.
#==============================================================================

class Game_BattleAction
  
  #//////////////////////////////////////////////////////////////////////////
  # * Attributes
  #//////////////////////////////////////////////////////////////////////////
  
  # weapon ID
  attr_accessor :weapon_id
  
  #//////////////////////////////////////////////////////////////////////////
  # * Public Methods
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Set Throw Attack
  #--------------------------------------------------------------------------
  def set_throw(weapon_id)
    @kind = 0
    @basic = 5
    @weapon_id = weapon_id
  end
  
  #--------------------------------------------------------------------------
  # * Throw Attack Determination
  #--------------------------------------------------------------------------
  def throw?
    return (@kind == 0 and @basic == 5)
  end
  
  #--------------------------------------------------------------------------
  # * Get Throw Object
  #--------------------------------------------------------------------------
  def throw_weapon
    return throw? ? $data_weapons[@weapon_id] : nil
  end
  
  #--------------------------------------------------------------------------
  # * Alias determine_action_name
  #--------------------------------------------------------------------------
  alias determine_action_name_bc_throw determine_action_name unless $@
  def determine_action_name()
    action_name = ""
    if self.throw?
      action_name = "Throw"
    else
      action_name = determine_action_name_bc_throw
    end
    
    return action_name
  end
  
  #--------------------------------------------------------------------------
  # * Alias make_targets
  #--------------------------------------------------------------------------
  alias make_targets_bc_throw make_targets unless $@
  def make_targets
    if throw?
      return make_attack_targets
    else
      return make_targets_bc_throw
    end
  end
  
  #--------------------------------------------------------------------------
  # * Alias valid?
  #--------------------------------------------------------------------------
  alias valid_bc_throw? valid? unless $@
  def valid?
    return true if throw?
    return valid_bc_throw?
  end
  
end

#==============================================================================
# ** Game_Battle_Commands
#------------------------------------------------------------------------------
#  This class handles the battle commands array. The instance of this class is
# referenced by $game_battle_commands.
#==============================================================================

class Game_Battle_Commands
  include EBJB
  
  #//////////////////////////////////////////////////////////////////////////
  # * Public Methods
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Add new Item command
  #     item : item object
  #--------------------------------------------------------------------------
  def add_throw_command(item)
    id = Utilities.generate_battle_command_uid("BC_THROW_"+item.id.to_s)
    if (!@data.include?(id))
      @data[id] = Throw_Command.new(id, item.id)
    end
    return @data[id]
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
  # * Attributes
  #//////////////////////////////////////////////////////////////////////////

  # Array of Weapon Animations definitions
  attr_accessor :ani_throw_weapons
  
  #//////////////////////////////////////////////////////////////////////////
  # * Properties
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Checks if animation action is Throwing
  #--------------------------------------------------------------------------
  def is_throwing?
    return @animation_action == BATTLESYSTEM_CONFIG::BA_THROW
  end
  
  #//////////////////////////////////////////////////////////////////////////
  # * Constructors
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Alias initialize
  #--------------------------------------------------------------------------
  alias initialize_bc_throw initialize unless $@
  def initialize
    initialize_bc_throw
  
    @ani_throw_weapons = nil
  end
  
  #//////////////////////////////////////////////////////////////////////////
  # * Public Methods
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Do Throw animation
  #--------------------------------------------------------------------------
  def do_ani_throw(weapon_id=0)
    @animation_loop = false
    set_action_ani(BATTLESYSTEM_CONFIG::BA_THROW, weapon_id)
  end
  
  #--------------------------------------------------------------------------
  # * Alias do_next_battle_animation
  #--------------------------------------------------------------------------
  alias do_next_battle_animation_bc_throw do_next_battle_animation unless $@
  def do_next_battle_animation
    do_next_battle_animation_bc_throw
        
    case @animation_action
    when BATTLESYSTEM_CONFIG::BA_THROW
      do_ani_stand
    end
  end
  
  #--------------------------------------------------------------------------
  # * Sets animation action and animation id (can vary depending of the obj_id) 
  #   for this action
  #     action : battle action
  #     obj_id : weapon/skill/item ID
  #--------------------------------------------------------------------------
  def set_action_ani(action, obj_id=0)
    @animation_action = action
    #if not self.is_a?(Game_Enemy)
      if obj_id > 0
        case action
        when BATTLESYSTEM_CONFIG::BA_ATTACK
          if @ani_weapons[obj_id] != nil
            anim_id = @ani_weapons[obj_id].animation_id
          end
        when BATTLESYSTEM_CONFIG::BA_SKILL
          if @ani_skills[obj_id] != nil
            anim_id = @ani_skills[obj_id].animation_id
          end
        when BATTLESYSTEM_CONFIG::BA_ITEM
          if @ani_items[obj_id] != nil
            anim_id = @ani_items[obj_id].animation_id
          end
        when BATTLESYSTEM_CONFIG::BA_THROW
          if @ani_throw_weapons[obj_id] != nil
            anim_id = @ani_throw_weapons[obj_id].animation_id
          end
        end

        # If no animation id was found, use default action
        if anim_id == nil
          anim_id = @ani_actions[action]
        end
      else
        anim_id = @ani_actions[action]
      end
    #end
    if anim_id != nil
      @animation_id = anim_id
    end
  end
  
end
#==============================================================================
# ** Game_Projectile
#------------------------------------------------------------------------------
#  This class deals with projectiles in battle.
#==============================================================================

class Game_Projectile
  include EBJB
  
  #//////////////////////////////////////////////////////////////////////////
  # * Attributes
  #//////////////////////////////////////////////////////////////////////////
  
  # weapon ID
  attr_reader   :weapon_id
  
  #//////////////////////////////////////////////////////////////////////////
  # * Constructors
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Alias initialize
  #--------------------------------------------------------------------------
  alias initialize_bc_throw initialize unless $@
  def initialize(battler, animation_id)
    initialize_bc_throw(battler, animation_id)
    
    if battler.action.throw?
      @battle_animation.ba_show_weapon.push(BATTLESYSTEM_CONFIG::BA_MOVE)
      @weapon_id = battler.action.weapon_id
    end
  end
  
end

#==============================================================================
# ** Game_Party
#------------------------------------------------------------------------------
#  This class handles the party. It includes information on amount of gold 
# and items. The instance of this class is referenced by $game_party.
#==============================================================================

class Game_Party < Game_Unit
  include EBJB
  
  #--------------------------------------------------------------------------
  # * Determine if Weapon is Throwable
  #     weapon : weapon
  #--------------------------------------------------------------------------
  def item_can_throw?(weapon)
    return false unless weapon.is_a?(RPG::Weapon)
    return false if item_number(weapon) == 0
    return true
  end
  
end
#==============================================================================
# ** Sprite_Projectile
#------------------------------------------------------------------------------
#  This sprite is used to display projectiles. It observes a instance of the
# Game_Projectile class and automatically changes sprite conditions.
#==============================================================================

class Sprite_Projectile < Sprite_BattleAnimBase
  include EBJB
      
  #//////////////////////////////////////////////////////////////////////////
  # * Public Methods
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Overrides the loop animation animation for weapon (contents are defined by the subclasses)
  #--------------------------------------------------------------------------
  def override_loop_animation_weapon
    if @projectile.weapon_id != nil && @projectile.weapon_id > 0
      weapon = $data_weapons[@projectile.weapon_id]
    end
    return weapon
  end

end

#==============================================================================
# ** Scene_BattleCommands
#------------------------------------------------------------------------------
#  This class performs the battle commands change screen processing.
#===============================================================================

class Scene_BattleCommands < Scene_Base
  include EBJB
  
  #//////////////////////////////////////////////////////////////////////////
  # * Public Methods
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Alias start
  #--------------------------------------------------------------------------
  alias start_bc_throw start unless $@
  def start
    start_bc_throw()
    
    @throw_command_window = Window_Throw_Command.new(640, 208, 440, 176)
    @throw_command_window.active = false
    @throw_command_window.visible = false
    @throw_command_window.index = -1
    
    @throw_command_window.help_window = @help_window
    
    @equip_details_window = Window_EquipDetails.new(0,384,640,96,nil)
    @equip_details_window.visible = false    
    @throw_command_window.detail_window = @equip_details_window
    
    [@throw_command_window, @equip_details_window].each{
      |w| w.opacity = BATTLESYSTEM_CONFIG::WINDOW_OPACITY;
          w.back_opacity = BATTLESYSTEM_CONFIG::WINDOW_BACK_OPACITY
    }
  end
  
  #--------------------------------------------------------------------------
  # * Alias terminate
  #--------------------------------------------------------------------------
  alias terminate_bc_throw terminate unless $@
  def terminate
    terminate_bc_throw()
    
    @throw_command_window.dispose if @throw_command_window != nil
    @equip_details_window.dispose if @equip_details_window != nil
  end
  
  #--------------------------------------------------------------------------
  # * Alias update
  #--------------------------------------------------------------------------
  alias update_bc_throw update unless $@
  def update
    update_bc_throw()
    
    @throw_command_window.update
    @equip_details_window.update
    if @throw_command_window.active
      update_throw_command_selection
    end
  end
  
  #--------------------------------------------------------------------------
  # * Alias update_window_movement
  #--------------------------------------------------------------------------
  alias update_window_movement_bc_throw update_window_movement unless $@
  def update_window_movement()
    update_window_movement_bc_throw()
    
    # Battle command window position
    if @throw_command_window.active
      if @battle_commands_window.x > 0
        @battle_commands_window.x -= 20
      end
    end
    
    # Throw window position
    if @throw_command_window.active
      @throw_command_window.visible = true
      if @throw_command_window.x > 200
        @throw_command_window.x -= 40
      end
    else
      if @throw_command_window.x < 640
        @throw_command_window.x += 40
      else
        @throw_command_window.visible = false
      end
    end
    
  end
  
  #//////////////////////////////////////////////////////////////////////////
  # * Private Methods
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Alias update_detail_window
  #-------------------------------------------------------------------------- 
  alias update_detail_window_bc_throw update_detail_window unless $@
  def update_detail_window(command)    
    if command.is_a?(Throw_Command)
      @actor_commands_window.detail_window = @equip_details_window
    else
      update_detail_window_bc_throw(command)
    end
  end
  private :update_detail_window
  
  #//////////////////////////////////////////////////////////////////////////
  # * Scene input management methods
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Alias update_battle_command_selection
  #--------------------------------------------------------------------------
  alias update_battle_command_selection_bc_throw update_battle_command_selection unless $@
  def update_battle_command_selection()
    update_battle_command_selection_bc_throw()
    
    if Input.trigger?(Input::RIGHT)
      if @battle_commands_window.selected_battle_command.is_a?(List_Command)
        if @battle_commands_window.selected_battle_command.type == BATTLECOMMANDS_CONFIG::BC_THROW
          throw_command()
        end
      end
    end    
  end
  private :update_battle_command_selection
  
  #--------------------------------------------------------------------------
  # * Update Throw Command Selection
  #--------------------------------------------------------------------------
  def update_throw_command_selection()
    if Input.trigger?(Input::B)
      Sound.play_cancel
      cancel_throw_command()
      
    elsif Input.trigger?(Input::C)
      if @throw_command_window.selected_item == nil ||
         (!@autobattle_window.active && !@throw_command_window.enable?(@throw_command_window.selected_item))
        Sound.play_buzzer
      else
        Sound.play_decision
        command = $game_battle_commands.add_throw_command(@throw_command_window.selected_item)
        change_battle_command(command)
      end
    end
  end
  private :update_throw_command_selection
  
  #//////////////////////////////////////////////////////////////////////////
  # * Scene Commands
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Change battle command
  #     command : New battle command
  #--------------------------------------------------------------------------
  alias change_battle_command_bc_throw change_battle_command unless $@
  def change_battle_command(command)
    change_battle_command_bc_throw(command)
    
    if @throw_command_window.active
      @throw_command_window.window_update(@actor, $game_party.items, @battle_commands_window.selected_battle_command.filter)
    end
  end
  private :change_battle_command
  
  #--------------------------------------------------------------------------
  # * Throw command
  #--------------------------------------------------------------------------
  def throw_command()
    @battle_commands_window.active = false
    @throw_command_window.window_update(@actor, $game_party.items, @battle_commands_window.selected_battle_command.filter)
    @throw_command_window.active = true
    @throw_command_window.index = 0
  end
  private :throw_command
  
  #--------------------------------------------------------------------------
  # * Cancel Throw command
  #--------------------------------------------------------------------------
  def cancel_throw_command()
    @battle_commands_window.active = true
    @throw_command_window.active = false
    @throw_command_window.index = -1
    @battle_commands_window.call_update_help()
    @equip_details_window.window_update(nil)
    @equip_details_window.visible = false
  end
  private :cancel_throw_command
  
end

#==============================================================================
# ** Scene_Battle
#------------------------------------------------------------------------------
#   This class performs battle screen processing.
#==============================================================================

class Scene_Battle < Scene_Base
  include EBJB
  
  #//////////////////////////////////////////////////////////////////////////
  # * Public Methods
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Alias start
  #--------------------------------------------------------------------------
  alias start_bc_throw start unless $@
  def start
    start_bc_throw
    
    @throw_window = Window_BattleThrow.new(0, 480, 298, 176, nil)
    @throw_window.active = false
    @throw_window.help_window = @bot_help_window
    
    [@throw_window].each{
      |w| w.opacity = BATTLESYSTEM_CONFIG::WINDOW_OPACITY;
          w.back_opacity = BATTLESYSTEM_CONFIG::WINDOW_BACK_OPACITY
    }
  end
  
  #--------------------------------------------------------------------------
  # * Alias terminate
  #--------------------------------------------------------------------------
  alias terminate_bc_throw terminate unless $@
  def terminate
    terminate_bc_throw
    
    @throw_window.dispose if @throw_window != nil
  end
  
  #--------------------------------------------------------------------------
  # * Alias update_basic
  #--------------------------------------------------------------------------
  alias update_basic_bc_throw update_basic unless $@
  def update_basic(main = false)
    update_basic_bc_throw(main)

    @throw_window.update
  end
  
  #--------------------------------------------------------------------------
  # * Alias update_window_movement
  #--------------------------------------------------------------------------
  alias update_window_movement_bc_throw update_window_movement unless $@
  def update_window_movement()
    update_window_movement_bc_throw
    
    # Throw window position
    if @throw_window.active
      @throw_window.visible = true
      if @throw_window.y > 288+16
        @throw_window.y -= 16
      end
    else
      if @throw_window.y < 480
        @throw_window.y += 16
      else
        @throw_window.visible = false
      end
    end
  end
  
  #--------------------------------------------------------------------------
  # * Alias custom_actor_command_active?
  #--------------------------------------------------------------------------
  alias custom_actor_command_active_bc_throw? custom_actor_command_active? unless $@
  def custom_actor_command_active?
    if @throw_window.active
      return true
    else 
      return custom_actor_command_active_bc_throw?
    end
  end
  
  #--------------------------------------------------------------------------
  # * Alias update_custom_actor_command_input 
  #--------------------------------------------------------------------------
  alias update_custom_actor_command_input_bc_throw update_custom_actor_command_input unless $@
  def update_custom_actor_command_input
    if @throw_window.active
      update_throw_selection    # Select throwable weapon
    else
      update_custom_actor_command_input_bc_throw
    end
  end
  
  #--------------------------------------------------------------------------
  # * Alias execute_battle_commands
  #--------------------------------------------------------------------------
  alias execute_battle_commands_bc_throw execute_battle_commands unless $@
  def execute_battle_commands(actor)
    command = @actor_command_window.selected_command
    if command.type == BATTLECOMMANDS_CONFIG::BC_THROW
      if command.is_a?(List_Command)
        Sound.play_decision
        #@throw_window.filter = command.filter
        start_throw_selection
      elsif command.is_a?(Throw_Command)
        if $game_party.item_can_throw?(command.item)
          Sound.play_decision
          @actor_command_window.active = false
          determine_throw(command.item)
        else
          Sound.play_buzzer
        end
      end
    else
      execute_battle_commands_bc_throw(actor)
    end
  end
  
  #--------------------------------------------------------------------------
  # * Alias execute_action
  #--------------------------------------------------------------------------
  alias execute_action_bc_throw execute_action unless $@
  def execute_action
    if @active_battler.action.throw?
      execute_action_throw
      @active_battler.action.clear
    else
      execute_action_bc_throw
    end
  end
  
  #--------------------------------------------------------------------------
  # * Execute Battle Action: Throw
  #--------------------------------------------------------------------------
  def execute_action_throw
    weapon = @active_battler.action.throw_weapon
    @top_help_window.set_text(@active_battler.action.determine_action_name)
    @top_help_window.visible = true
    $game_party.lose_item(weapon, 1)
    @active_battler.stamina_wait = true
    @active_battler.empty_stamina
    execute_basic_action(nil)
    @top_help_window.visible = false
  end
  
  #--------------------------------------------------------------------------
  # * 
  #     obj : 
  #--------------------------------------------------------------------------
  alias determine_custom_battler_animation_bc_throw determine_custom_battler_animation unless $@
  def determine_custom_battler_animation(battler, obj)
    if battler.action.throw?
      return battler.battle_animation.ani_throw_weapons[battler.action.weapon_id]
      #return CustomAnim.new(nil, BATTLESYSTEM_CONFIG::MOVE_STEPS)
    else
      return determine_custom_battler_animation_bc_throw(battler, obj)
    end
  end

  #--------------------------------------------------------------------------
  # * 
  #     obj : 
  #--------------------------------------------------------------------------
  alias do_custom_target_effect_bc_throw do_custom_target_effect unless $@
  def do_custom_target_effect(battler, target, obj)
    if battler.action.throw?
      temp = battler.clone
      temp.atk = (battler.action.throw_weapon.atk * (BATTLECOMMANDS_CONFIG::BC_THROW_BONUS_DMG_RATE / 100.0))
      target.attack_effect(temp)
    else
      do_custom_target_effect_bc_throw(battler, target, obj)
    end
  end
  
  #--------------------------------------------------------------------------
  # * 
  #     obj : 
  #--------------------------------------------------------------------------
  alias do_custom_animation_bc_throw do_custom_animation unless $@
  def do_custom_animation(battler, obj)
    if battler.action.throw?
      battler.battle_animation.do_ani_throw(battler.action.weapon_id)
    else
      do_custom_animation_bc_throw(battler, obj)
    end
  end
  
  #--------------------------------------------------------------------------
  # * 
  #     obj : 
  #--------------------------------------------------------------------------
  alias display_custom_animation_bc_throw display_custom_animation unless $@
  def display_custom_animation(battler, targets)
    if battler.action.throw?
      display_animation(targets, battler.action.throw_weapon.animation_id, false)
    else
      display_custom_animation_bc_throw(battler, targets)
    end
  end
  
  #--------------------------------------------------------------------------
  # * Confirm Throw
  #     weapon : weapon object
  #--------------------------------------------------------------------------
  def determine_throw(weapon)
    actor = $game_party.members[@actor_index]
    actor.action.set_throw(weapon.id)
    @throw_window.active = false
    start_target_enemy_selection
  end
  
  #//////////////////////////////////////////////////////////////////////////
  # * Scene Commands
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Update Throw Selection
  #--------------------------------------------------------------------------
  def update_throw_selection   
    actor = $game_party.members[@actor_index]
    if (not actor.ready_for_action?) and (not actor.inputable?)
      end_throw_selection()
      return
    end
    
    @throw_window.call_update_help()

    if Input.trigger?(Input::B)
      Sound.play_cancel
      end_throw_selection
    elsif Input.trigger?(Input::C)
      weapon = @throw_window.selected_weapon
      if weapon != nil
        Sound.play_decision
        @targeting_window = @throw_window
        determine_throw(weapon)
      else
        Sound.play_buzzer
      end
    end
  end
  
  #--------------------------------------------------------------------------
  # * Start Throw Selection
  #--------------------------------------------------------------------------
  def start_throw_selection
    @throw_window.index = 0
    @throw_window.window_update($game_party.items)
    @throw_window.active = true
    @throw_window.call_update_help()
    @actor_command_window.active = false
    deactivate_stamina(0)
  end
 
  #--------------------------------------------------------------------------
  # * End Throw Selection
  #--------------------------------------------------------------------------
  def end_throw_selection
    @throw_window.active = false
    @actor_command_window.active = true
    activate_stamina(0)
  end
  
end

#==============================================================================
# ** Window_ActorCommand
#------------------------------------------------------------------------------
#  This window is used to select actor commands, such as "Attack" or "Skill".
#==============================================================================

class Window_ActorCommand < Window_Command
  include EBJB
  
  #//////////////////////////////////////////////////////////////////////////
  # * Public Methods
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Alias update_detail
  #--------------------------------------------------------------------------
  alias update_detail_bc_throw update_detail unless $@
  def update_detail
    update_detail_bc_throw()
    
    if selected_command != nil
      if selected_command.is_a?(Throw_Command)
        @detail_window.window_update(selected_command.item)
      else
        update_detail_bc_throw()
      end
    else
      update_detail_bc_throw()
    end
  end
  
  #--------------------------------------------------------------------------
  # * Alias is_switchable
  #--------------------------------------------------------------------------
  alias is_switchable_bc_throw is_switchable unless $@
  def is_switchable
    return is_switchable_bc_throw() ||
           (selected_command != nil && 
           (selected_command.is_a?(Throw_Command) && detail_window.is_a?(Window_EquipDetails)))
  end
  
  #//////////////////////////////////////////////////////////////////////////
  # * Private Methods
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Alias create_item
  #--------------------------------------------------------------------------
  alias create_item_bc_throw create_item unless $@
  def create_item(index)
    command = @commands[index]
    rect = item_rect(index, true)
    
    if command.is_a?(Throw_Command)
      control = UCItem.new(self, command.item, rect)
      control.active = $game_party.item_can_throw?(command.item)
    else
      control = create_item_bc_throw(index)
    end

    return control
  end
  private :create_item
  
end

#==============================================================================
# ** Window_Throw_Command
#------------------------------------------------------------------------------
#  This window displays a list of throwable items for the item screen, etc.
#==============================================================================

class Window_Throw_Command < Window_Selectable
  include EBJB
  
  #//////////////////////////////////////////////////////////////////////////
  # * Attributes
  #//////////////////////////////////////////////////////////////////////////
  
  # Array of UCItem for every item in the inventory
  attr_reader :ucItemsList

  #//////////////////////////////////////////////////////////////////////////
  # * Properties
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Get the current item
  #--------------------------------------------------------------------------
  # GET
  def selected_item
    return (self.index < 0 ? nil : @data[self.index])
  end
  
  #//////////////////////////////////////////////////////////////////////////
  # * Constructors
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Object Initialization
  #     x : window x-coordinate
  #     y : window y-coordinate
  #     width : window width
  #     height : window height
  #     actor : actor object
  #     items : items list
  #     filter : filter object
  #--------------------------------------------------------------------------
  def initialize(x, y, width, height, actor=nil, items=nil, filter=nil)
    super(x, y, width, height)
    @column_max = 2
    @ucItemsList = []
    window_update(actor, items, filter)
    self.index = 0
  end
  
  #//////////////////////////////////////////////////////////////////////////
  # * Public Methods
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Update
  #     actor : actor object
  #     items : items list
  #     filter : filter object
  #--------------------------------------------------------------------------
  def window_update(actor, items, filter)
    @data = []
    if actor != nil && items != nil 
      @actor = actor

      if filter != nil
        temp_items = items.find_all{|x| filter.apply(x)}
      else
        temp_items = items
      end

      for item in temp_items
        if item != nil && (filter != nil || include?(item))
          @data.push(item)
        end
      end
      @item_max = @data.size
      create_contents()
      @ucItemsList.clear()
      for i in 0..@item_max-1
        @ucItemsList.push(create_item(i))
      end
    end
    refresh()
  end
  
  #--------------------------------------------------------------------------
  # * Refresh
  #--------------------------------------------------------------------------
  def refresh()
    self.contents.clear
    @ucItemsList.each() { |ucItem| ucItem.draw() }
  end
  
  #--------------------------------------------------------------------------
  # * Update Help Text
  #--------------------------------------------------------------------------
  def update_help
#~     if @help_window.is_a?(Window_Help)
#~       @help_window.set_text(item == nil ? "" : item.description)
#~     else
      if selected_item != nil
        @help_window.window_update(selected_item.description)
      else
        @help_window.window_update("")
      end
#~     end
  end
  
  #--------------------------------------------------------------------------
  # * Update Detail Window
  #--------------------------------------------------------------------------
  def update_detail
    if selected_item != nil
      @detail_window.window_update(selected_item)
    else
      @detail_window.window_update(nil)
    end
  end
  
  #--------------------------------------------------------------------------
  # * Determine if help/detail window can be switched
  #--------------------------------------------------------------------------
  def is_switchable
    return selected_item != nil && selected_item.is_a?(RPG::Weapon)
  end
  
  #--------------------------------------------------------------------------
  # * Whether or not to display in enabled state
  #     item : item object
  #--------------------------------------------------------------------------
  def enable?(item)
    return !@actor.is_command_equipped?(item)
  end
  
  #//////////////////////////////////////////////////////////////////////////
  # * Private Methods
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Whether or not to include in item list
  #     item : item
  #--------------------------------------------------------------------------
  def include?(item)
    return item.is_a?(RPG::Weapon) && BATTLECOMMANDS_CONFIG::BC_THROW_ITEMS_ID.include?(item.id)
  end
  private :include?
  
  #--------------------------------------------------------------------------
  # * Create an item for SkillsList
  #     index : item index
  #--------------------------------------------------------------------------
  def create_item(index)
    item = @data[index]
    rect = item_rect(index, true)
    
    ucItem = UCItem.new(self, item, rect)
    ucItem.active = enable?(item)
                              
    return ucItem
  end
  private :create_item
  
end

#==============================================================================
# ** Window_BattleThrow
#------------------------------------------------------------------------------
#  This window displays a list of usable throwable weapons during battle.
#==============================================================================

class Window_BattleThrow < Window_Selectable
  include EBJB
  
  #//////////////////////////////////////////////////////////////////////////
  # * Attributes
  #//////////////////////////////////////////////////////////////////////////
  
  # Array of CLabel for every throwable weapons
  attr_reader :cWeaponsList
  
  #//////////////////////////////////////////////////////////////////////////
  # * Properties
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Get the current weapon
  #--------------------------------------------------------------------------
  # GET
  def selected_weapon
    return (self.index < 0 ? nil : @data[self.index])
  end
  
  #//////////////////////////////////////////////////////////////////////////
  # * Constructors
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Object Initialization
  #     x : window x-coordinate
  #     y : window y-coordinate
  #     width : window width
  #     height : window height
  #     actor : actor object
  #--------------------------------------------------------------------------
  def initialize(x, y, width, height, items)
    super(x, y, width, height)
    @column_max = 1
    @cWeaponsList = []
    window_update(items)
    self.index = 0
  end
  
  #//////////////////////////////////////////////////////////////////////////
  # * Public Methods
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Update
  #     items : items list
  #--------------------------------------------------------------------------
  def window_update(items)
    @data = []
    if items != nil
      for item in items
        next unless include?(item)
        if item != nil
          @data.push(item)
        end
      end
      @item_max = @data.size
      create_contents()
      @cWeaponsList.clear()
      for i in 0..@item_max-1
        @cWeaponsList.push(create_item(i))
      end
    end
    refresh()
  end
  
  #--------------------------------------------------------------------------
  # * Refresh
  #--------------------------------------------------------------------------
  def refresh()
    self.contents.clear
    @cWeaponsList.each() { |cWeapon| cWeapon.draw() }
  end
  
  #--------------------------------------------------------------------------
  # * Update Help Text
  #--------------------------------------------------------------------------
  def update_help
    if @help_window.is_a?(Window_Help)
      @help_window.set_text(selected_weapon == nil ? "" : selected_weapon.description)
#~     else
#~       if selected_weapon != nil
#~         @help_window.window_update(selected_weapon.description)
#~       else
#~         @help_window.window_update("")
#~       end
    end
  end
  
  #--------------------------------------------------------------------------
  # * Update Detail Window
  #--------------------------------------------------------------------------
  def update_detail
    if selected_weapon != nil
      @detail_window.window_update(selected_weapon)
    else
      @detail_window.window_update(nil)
    end
  end
  
  #//////////////////////////////////////////////////////////////////////////
  # * Private Methods
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Whether or not to include in item list
  #     item : item
  #--------------------------------------------------------------------------
  def include?(item)
    return item.is_a?(RPG::Weapon) && BATTLECOMMANDS_CONFIG::BC_THROW_ITEMS_ID.include?(item.id)
  end
  private :include?
  
  #--------------------------------------------------------------------------
  # * Create an item for WeaponsList
  #     index : item index
  #--------------------------------------------------------------------------
  def create_item(index)
    weapon = @data[index]
    rect = item_rect(index, true)
    
    cWeapon = UCItem.new(self, weapon, rect)
  
    return cWeapon
  end
  private :create_item
  
end

#===============================================================================
# ** Window_AutoBattle_Command
#------------------------------------------------------------------------------
#  This window displays 
#===============================================================================

class Window_AutoBattle_Command < Window_Base
  include EBJB
  
  #//////////////////////////////////////////////////////////////////////////
  # * Private Methods
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Alias create_item
  #--------------------------------------------------------------------------
  alias create_item_bc_throw create_item unless $@
  def create_item(command, actor, rect)   
    if command.is_a?(Throw_Command)
      control = UCItem.new(self, command.item, rect)
      control.active = $game_party.item_can_throw?(command.item)
      return control
    else
      return create_item_bc_throw(command, actor, rect)
    end
  end
  private :create_item
  
end

#==============================================================================
# ** WeaponFilter
#------------------------------------------------------------------------------
#  Represents a Weapon filter
#==============================================================================

class WeaponFilter < Filter
  include EBJB
  
  #//////////////////////////////////////////////////////////////////////////
  # * Public Methods
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Alias apply
  #--------------------------------------------------------------------------
  alias apply_bc_throw apply unless $@  
  def apply(x)
    if x != nil && x.is_a?(RPG::Weapon)
       
      case mode
        when "throw"
          return applyThrow(x)
        #when
          #...
        else
          return apply_bc_throw(x)
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
  def applyThrow(x)
    if BATTLECOMMANDS_CONFIG::BC_THROW_ITEMS_ID.include?(x.id)
      return true
    else
      return false
    end
  end
  private:applyThrow
  
end

#==============================================================================
# ** Vocab
#------------------------------------------------------------------------------
#  This module defines terms and messages. It defines some data as constant
# variables. Terms in the database are obtained from $data_system.
#==============================================================================

module Vocab
  
  #//////////////////////////////////////////////////////////////////////////
  # * Stats Parameters related
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Get ATK Label
  #--------------------------------------------------------------------------
  def self.atk_label
    return self.atk
  end
  
  #--------------------------------------------------------------------------
  # * Get DEF Label
  #--------------------------------------------------------------------------
  def self.def_label
    return self.def
  end
  
  #--------------------------------------------------------------------------
  # * Get SPI Label
  #--------------------------------------------------------------------------
  def self.spi_label
    return self.spi
  end
  
  #--------------------------------------------------------------------------
  # * Get AGI Label
  #--------------------------------------------------------------------------
  def self.agi_label
    return self.agi
  end
  
  #--------------------------------------------------------------------------
  # * Get EVA Label
  #--------------------------------------------------------------------------
  def self.eva_label
    return "EVA"
  end
  
  #--------------------------------------------------------------------------
  # * Get HIT Label
  #--------------------------------------------------------------------------
  def self.hit_label
    return "HIT"
  end
  
  #--------------------------------------------------------------------------
  # * Get CRI Label
  #--------------------------------------------------------------------------
  def self.cri_label
    return "CRI"
  end
  
  #//////////////////////////////////////////////////////////////////////////
  # * Details Window related
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Get Label to show for the Stats
  #--------------------------------------------------------------------------
  def self.stats_label
    return "STATS"
  end

  #--------------------------------------------------------------------------
  # * Get Label to show for the Bonus list
  #--------------------------------------------------------------------------
  def self.bonus_label
    return "BONUS"
  end
    
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
    alias battle_commands_strings_bc_throw battle_commands_strings unless $@
    def battle_commands_strings
      return battle_commands_strings_bc_throw.merge(
      {
       BATTLECOMMANDS_CONFIG::BC_THROW => ["Throw", "Attacks by throwing a weapon to a target"]
      })
    end
    
  end
end


################################################################################
#                      EBJB Pray Command - EBJB_BCPRAY                #   VX   #
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
$imported["EBJB_BCPRAY"] = true

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
    BC_PRAY = Utilities.generate_battle_command_uid("BC_PRAY2")
    
    # Battle commands data
    DATA_BATTLE_COMMANDS.push(Skill_Command.new(BC_PRAY, 89, true))
    
    # Actor Battle Commands Settings
    #   syntax: actor_id => [LearningBattleCommand.new('type', ...), ...]
    #   Where 'type' is one of the Battle commands above
    CLASS_BATTLE_COMMANDS_LEARNINGS[3].push(LearningBattleCommand.new(BC_PRAY))
    
  end
end


################################################################################
#                EBJB Turn Undead Command - EBJB_BCTURNUNDEAD         #   VX   #
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
$imported["EBJB_BCTURNUNDEAD"] = true

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
    BC_TURN_UNDEAD = Utilities.generate_battle_command_uid("BC_TURN_UNDEAD")
    
    # Battle commands data
    DATA_BATTLE_COMMANDS.push(Skill_Command.new(BC_TURN_UNDEAD, 90, true))
    
    # Actor Battle Commands Settings
    #   syntax: actor_id => [LearningBattleCommand.new('type', ...), ...]
    #   Where 'type' is one of the Battle commands above
    CLASS_BATTLE_COMMANDS_LEARNINGS[1].push(LearningBattleCommand.new(BC_TURN_UNDEAD))
    
  end
end


################################################################################
#                     EBJB Blitz Command - EBJB_BCBLITZ               #   VX   #
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
$imported["EBJB_BCBLITZ"] = true

#==============================================================================
# ** BATTLECOMMANDS_CONFIG
#------------------------------------------------------------------------------
#  Contains the BattleCommands_Config configuration
#==============================================================================

module EBJB
  
  module BATTLECOMMANDS_CONFIG
    
    #------------------------------------------------------------------------
    # Blitz Command related 
    #------------------------------------------------------------------------
    
    # Blitz Button Inputs Settings
    #   syntax: skill_id => array of inputs
    BC_BLITZ_BUTTON_INPUTS = {
      98 => [Input::LEFT,Input::RIGHT,Input::LEFT],
      99 => [Input::LEFT,Input::DOWN,Input::RIGHT],
      100 => [Input::LEFT,Input::UP,Input::RIGHT,Input::DOWN]
    }
    
    # Timer between inputs (in seconds)
    BLITZ_INPUT_TIMER = 1
    
    # Max time before ending the blitz inputs (in seconds)
    BLITZ_MAX_INPUT_TIME = 6
    
    #------------------------------------------------------------------------
    # Battle Commands Definitions
    #------------------------------------------------------------------------
    
    # Unique ids used to represent battle commands
    # BATTLE_COMMAND = 10xx
    BC_BLITZ = Utilities.generate_battle_command_uid("BC_BLITZ")
    
    # Battle commands data
    DATA_BATTLE_COMMANDS.push(Battle_Command.new(BC_BLITZ, BC_BLITZ, nil, false))
    
    # Actor Battle Commands Settings
    #   syntax: actor_id => [LearningBattleCommand.new('type', ...), ...]
    #   Where 'type' is one of the Battle commands above
    CLASS_BATTLE_COMMANDS_LEARNINGS[1].push(LearningBattleCommand.new(BC_BLITZ))
    
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
  # * Set Blitz Attack
  #--------------------------------------------------------------------------
  def set_blitz(skill_id)
    @kind = 0
    @basic = 6
    @skill_id = skill_id
  end
  
  #--------------------------------------------------------------------------
  # * Set Failed Blitz Attack
  #--------------------------------------------------------------------------
  def set_failed_blitz
    @kind = 0
    @basic = 7
  end
  
  #--------------------------------------------------------------------------
  # * Blitz Attack Determination
  #--------------------------------------------------------------------------
  def blitz?
    return (@kind == 0 and @basic == 6)
  end
  
  #--------------------------------------------------------------------------
  # * Failed Blitz Attack Determination
  #--------------------------------------------------------------------------
  def failed_blitz?
    return (@kind == 0 and @basic == 7)
  end
  
  #--------------------------------------------------------------------------
  # * Get Skill Object
  #--------------------------------------------------------------------------
  alias skill_bc_blitz skill unless $@
  def skill
    return blitz? ? $data_skills[@skill_id] : skill_bc_blitz
  end
  
  #--------------------------------------------------------------------------
  # * Alias make_targets
  #--------------------------------------------------------------------------
  alias make_targets_bc_blitz make_targets unless $@
  def make_targets
    if blitz?
      return make_obj_targets(skill)
    elsif failed_blitz?
      return [battler]
    else
      return make_targets_bc_blitz
    end
  end
  
  #--------------------------------------------------------------------------
  # * Alias determine_action_name
  #--------------------------------------------------------------------------
  alias determine_action_name_bc_blitz determine_action_name unless $@
  def determine_action_name()
    action_name = ""
    if self.blitz?
      action_name = "Blitz"
    else
      action_name = determine_action_name_bc_blitz
    end
    
    return action_name
  end
  
  #--------------------------------------------------------------------------
  # * Alias valid?
  #--------------------------------------------------------------------------
  alias valid_bc_blitz? valid? unless $@
  def valid?
    return true if blitz?
    return true if failed_blitz?
    return valid_bc_blitz?
  end
  
end
#==============================================================================
# ** BlitzFilter
#------------------------------------------------------------------------------
#  Represents a Blitz filter
#==============================================================================

class BlitzFilter < Filter
  
  #//////////////////////////////////////////////////////////////////////////
  # * Public Methods
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Apply method
  #     x : object to filter
  #--------------------------------------------------------------------------
  def apply(x, index)
    if x != nil && index != nil
       
      case mode
        when "input"
          return applyInput(x, index)
        #when
          #...
        else
          return true
      end
      
    else
      return nil
    end
  end
  
  #//////////////////////////////////////////////////////////////////////////
  # * Private Methods
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Apply method (using the name property)
  #     x : object to filter
  #     index : index to check
  #--------------------------------------------------------------------------
  def applyInput(x, index)
    if x[1][index] == @value
      return true
    else
      return false
    end
  end
  private:applyInput
  
end
#==============================================================================
# ** Scene_Battle
#------------------------------------------------------------------------------
#   This class performs battle screen processing.
#==============================================================================

class Scene_Battle < Scene_Base
  include EBJB
  
  #//////////////////////////////////////////////////////////////////////////
  # * Public Methods
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Alias start
  #--------------------------------------------------------------------------
  alias start_bc_blitz start unless $@
  def start
    start_bc_blitz
    
    @blitz_button_inputting = false
  end
  
  #--------------------------------------------------------------------------
  # * Alias custom_actor_command_active?
  #--------------------------------------------------------------------------
  alias custom_actor_command_active_bc_blitz? custom_actor_command_active? unless $@
  def custom_actor_command_active?
    if @blitz_button_inputting
      return true
    else 
      return custom_actor_command_active_bc_blitz?
    end
  end
  
  #--------------------------------------------------------------------------
  # * Alias update_actor_command_input
  #--------------------------------------------------------------------------
  alias update_actor_command_input_bc_blitz update_actor_command_input unless $@
  def update_actor_command_input
    if @blitz_button_inputting
      update_blitz_button_inputting     # Button inputting (for Blitz Command)
    else
      update_actor_command_input_bc_blitz
    end
  end
  
  #--------------------------------------------------------------------------
  # * Alias execute_battle_commands
  #--------------------------------------------------------------------------
  alias execute_battle_commands_bc_blitz execute_battle_commands unless $@
  def execute_battle_commands(actor)
    command = @actor_command_window.selected_command
    if command.type == BATTLECOMMANDS_CONFIG::BC_BLITZ
      Sound.play_decision
      start_blitz_button_inputting
    else
      execute_battle_commands_bc_blitz(actor)
    end
  end
  
  #--------------------------------------------------------------------------
  # * Execute Battle Actions
  #--------------------------------------------------------------------------
  alias execute_action_bc_blitz execute_action unless $@
  def execute_action
    if @active_battler.action.blitz?
      execute_action_skill
      @active_battler.action.clear
    elsif @active_battler.action.failed_blitz?
      execute_action_failed_blitz
      @active_battler.action.clear
    else
      execute_action_bc_blitz
    end
  end
  
  #--------------------------------------------------------------------------
  # * Execute Battle Action: Failed Blitz
  #--------------------------------------------------------------------------
  def execute_action_failed_blitz
    @top_help_window.set_text("Incorrect Blitz input")
    @top_help_window.visible = true
    @active_battler.stamina_wait = true
    @active_battler.empty_stamina
    execute_basic_action(nil)
    @top_help_window.visible = false
  end
  
  #//////////////////////////////////////////////////////////////////////////
  # * Scene Commands
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Setup everything needed to start listening for blitz button inputs
  #--------------------------------------------------------------------------
  def start_blitz_button_inputting
    actor = $game_party.members[@actor_index]
    actor.white_flash = true
    @targeting_window.active = false
    @blitz_button_inputting = true
    @blitz_button_index = 0
    @max_input_time = BATTLECOMMANDS_CONFIG::BLITZ_MAX_INPUT_TIME*60
    @button_time = BATTLECOMMANDS_CONFIG::BLITZ_INPUT_TIMER*60
    @complete_blitzes = nil
    deactivate_stamina(0)
  end
  
  #--------------------------------------------------------------------------
  # * Reset everything changed when listening for blitz button inputs ends
  #--------------------------------------------------------------------------
  def end_blitz_button_inputting
    for actor in $game_party.members
      actor.white_flash = false
    end

    @blitz_button_inputting = false
    @blitz_button_index = nil
    @max_input_time = nil
    @button_time = nil
    @complete_blitzes = nil
    activate_stamina(0)
  end
  
  #--------------------------------------------------------------------------
  # * Wait until player presses a button. Returns false if doesn't match
  # input string or if time is reduced to 0. Else returns true.
  #--------------------------------------------------------------------------
  def update_blitz_button_inputting
    actor = $game_party.members[@actor_index]
    current_input = get_current_input()
    @max_input_time -= 1
    @button_time -= 1
    
    if current_input != nil
      @button_time = BATTLECOMMANDS_CONFIG::BLITZ_INPUT_TIMER*60
      filter = BlitzFilter.new("input", current_input)
      remaining_blitzes = BATTLECOMMANDS_CONFIG::BC_BLITZ_BUTTON_INPUTS.find_all{|x| filter.apply(x, @blitz_button_index)}

      if remaining_blitzes.length > 0
        @complete_blitzes = remaining_blitzes.find_all{|x| x[1][@blitz_button_index+1].nil?}
        @blitz_button_index += 1
        
      else
        @complete_blitzes = nil
      end
    end
    
    # Timer ends with no complete blitz
    if @button_time == 0 || @max_input_time == 0
      # Timer ends with at least one complete blitz
      if @complete_blitzes != nil && @complete_blitzes.length > 0
        actor.action.set_blitz(@complete_blitzes[0][0])
      else
        actor.action.set_failed_blitz
      end
      add_to_battleline(actor)
      end_actor_command_selection()
      end_blitz_button_inputting()
    end
    
  end
  
  #//////////////////////////////////////////////////////////////////////////
  # * Private Methods
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * 
  #--------------------------------------------------------------------------
  def get_current_input()
    if Input.trigger?(Input::A)
      return Input::A
    elsif Input.trigger?(Input::B)
      return Input::B
    elsif Input.trigger?(Input::C)
      return Input::C
    elsif Input.trigger?(Input::X)
      return Input::X
    elsif Input.trigger?(Input::Y)
      return Input::Y
    elsif Input.trigger?(Input::Z)
      return Input::Z
    elsif Input.trigger?(Input::L)
      return Input::L
    elsif Input.trigger?(Input::R)
      return Input::R
    elsif Input.trigger?(Input::LEFT)
      return Input::LEFT
    elsif Input.trigger?(Input::RIGHT)
      return Input::RIGHT
    elsif Input.trigger?(Input::DOWN)
      return Input::DOWN
    elsif Input.trigger?(Input::UP)
      return Input::UP
    end
  end
  private :get_current_input
  
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
    alias battle_commands_strings_bc_blitz battle_commands_strings unless $@
    def battle_commands_strings
      return battle_commands_strings_bc_blitz.merge(
      {
       BATTLECOMMANDS_CONFIG::BC_BLITZ => ["Blitz", "Attacks using special combos"]
      })
    end
    
  end
end


################################################################################
#               EBJB Input Skills Command - EBJB_BCINPUTSKILLS        #   VX   #
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
$imported["EBJB_BCINPUTSKILLS"] = true

#==============================================================================
# ** BATTLECOMMANDS_CONFIG
#------------------------------------------------------------------------------
#  Contains the BattleCommands_Config configuration
#==============================================================================

module EBJB
  
  #==============================================================================
  # ** InputSkill_Command
  #------------------------------------------------------------------------------
  #  Represents an input skill battle command
  #==============================================================================

  class InputSkill_Command < Skill_Command
    
    #//////////////////////////////////////////////////////////////////////////
    # * Attributes
    #//////////////////////////////////////////////////////////////////////////
    
    # Button inputs array
    attr_reader :button_inputs
    # Maximum time allowed for inputs
    attr_reader :button_time
    
    #//////////////////////////////////////////////////////////////////////////
    # * Constructors
    #//////////////////////////////////////////////////////////////////////////
    
    #--------------------------------------------------------------------------
    # * Object Initialization
    #     id : id
    #     button_inputs : Array of button inputs to complete the battle command
    #     button_time :
    #--------------------------------------------------------------------------
    def initialize(skill_id, button_inputs, button_time)
      super(Utilities.generate_battle_command_uid("BC_INPUTSKILLS_"+skill_id.to_s), 
            skill_id)
      @button_inputs = button_inputs
      @button_time = button_time
    end
    
  end
  
  module BATTLECOMMANDS_CONFIG

    #------------------------------------------------------------------------
    # Input Skills Command related 
    #------------------------------------------------------------------------
    
    # Icons used for the Input Icon  
    INPUT_ICONS = {
      Input::DOWN => 9,
      Input::LEFT => 10,
      Input::RIGHT => 12,
      Input::UP => 11,
      Input::A => 1,
      Input::B => 2,
      Input::C => 3,
      Input::X => 4,
      Input::Y => 5,
      Input::Z => 6,
      Input::L => 7,
      Input::R => 8
    }
    
    # Input Skills Button Inputs Settings
    #   syntax: skill_id => array of inputs
    BC_INPUTSKILLS_COMMANDS = [
      InputSkill_Command.new(33, [Input::LEFT,Input::RIGHT,Input::LEFT], 180),
      InputSkill_Command.new(67, [Input::LEFT,Input::DOWN,Input::RIGHT], 240),
      InputSkill_Command.new(69, [Input::LEFT,Input::UP,Input::RIGHT,Input::DOWN], 360),
      InputSkill_Command.new(98, [Input::LEFT,Input::RIGHT,Input::LEFT], 180),
      InputSkill_Command.new(101, [Input::LEFT,Input::UP,Input::RIGHT,Input::DOWN,
                                   Input::A,Input::B,Input::C,Input::X,Input::Y,
                                   Input::Z,Input::L,Input::R], 720)
    ]
    
    #------------------------------------------------------------------------
    # Battle Commands Definitions
    #------------------------------------------------------------------------
    
    # Unique ids used to represent battle commands
    # BATTLE_COMMAND = 10xx
    BC_INPUTSKILLS = Utilities.generate_battle_command_uid("BC_INPUTSKILLS")
    
    # Battle commands data
    #WeaponFilter.new("throw")
    DATA_BATTLE_COMMANDS.push(List_Command.new(BC_INPUTSKILLS, BC_SKILL, UsableItemFilter.new("inputskills")))
    
    # Actor Battle Commands Settings
    #   syntax: actor_id => [LearningBattleCommand.new('type', ...), ...]
    #   Where 'type' is one of the Battle commands above
    CLASS_BATTLE_COMMANDS_LEARNINGS[1].push(LearningBattleCommand.new(BC_INPUTSKILLS))
    
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
  # * Set Failed Input Attack
  #--------------------------------------------------------------------------
  def set_failed_input
    @kind = 0
    @basic = 8
  end
  
  #--------------------------------------------------------------------------
  # * Failed input Attack Determination
  #--------------------------------------------------------------------------
  def failed_input?
    return (@kind == 0 and @basic == 8)
  end
  
  #--------------------------------------------------------------------------
  # * Create Target Array
  #--------------------------------------------------------------------------
  alias make_targets_bc_inputskills make_targets unless $@
  def make_targets
    if failed_input?
      return [battler]
    else
      return make_targets_bc_inputskills
    end
  end
   
  #--------------------------------------------------------------------------
  # * Alias valid?
  #--------------------------------------------------------------------------
  alias valid_bc_inputskills? valid? unless $@
  def valid?
    return true if failed_input?
    return valid_bc_inputskills?
  end
  
end
#==============================================================================
# ** Game_Battle_Commands
#------------------------------------------------------------------------------
#  This class handles the battle commands array. The instance of this class is
# referenced by $game_battle_commands.
#==============================================================================

class Game_Battle_Commands
  include EBJB
  
  #//////////////////////////////////////////////////////////////////////////
  # * Public Methods
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Add existing command
  #     command : command object
  #--------------------------------------------------------------------------
  def add_inputskills_command(command)
    id = command.id
    if (!@data.include?(id))
      @data[id] = command
    end
    return @data[id]
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
  alias apply_bc_inputskills apply unless $@
  def apply(x)
    if x != nil && x.is_a?(RPG::UsableItem)
       
      case mode
        when "inputskills"
          return applyInputSkills(x)
        #when
          #...
        else
          return apply_bc_inputskills(x)
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
  def applyInputSkills(x)
    if BATTLECOMMANDS_CONFIG::BC_INPUTSKILLS_COMMANDS.collect{|y| y.skill_id}.include?(x.id)
      return true
    else
      return false
    end
  end
  private:applyInputSkills
  
end

#==============================================================================
# ** Scene_BattleCommands
#------------------------------------------------------------------------------
#  This class performs the battle commands change screen processing.
#===============================================================================

class Scene_BattleCommands < Scene_Base
  include EBJB
  
  #//////////////////////////////////////////////////////////////////////////
  # * Public Methods
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Alias start
  #--------------------------------------------------------------------------
  alias start_bc_inputskills start unless $@
  def start
    start_bc_inputskills()
    
    @input = false
  end

  #//////////////////////////////////////////////////////////////////////////
  # * Scene input management methods
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Alias update_battle_command_selection
  #--------------------------------------------------------------------------
  alias update_battle_command_selection_bc_inputskills update_battle_command_selection unless $@
  def update_battle_command_selection()
    update_battle_command_selection_bc_inputskills()
    
    if Input.trigger?(Input::RIGHT)
      if @battle_commands_window.selected_battle_command.is_a?(List_Command)
        if @battle_commands_window.selected_battle_command.type == BATTLECOMMANDS_CONFIG::BC_INPUTSKILLS 
          @input = true
        end
      end
    end    
  end
  private :update_battle_command_selection

  #--------------------------------------------------------------------------
  # * Update Skill Command Selection
  #--------------------------------------------------------------------------
  alias update_skill_command_selection_bc_inputskills update_skill_command_selection unless $@
  def update_skill_command_selection()
    if Input.trigger?(Input::C) && @input == true
      # Blocks input skill has an auto battle command because it would break
      # gameplay by switching inputs between the autobattle actor and the current actor
      if @skill_command_window.selected_skill == nil ||
         @autobattle_window.active ||
         (!@autobattle_window.active && !@skill_command_window.enable?(@skill_command_window.selected_skill))
        Sound.play_buzzer
      else
        Sound.play_decision
        command = BATTLECOMMANDS_CONFIG::BC_INPUTSKILLS_COMMANDS.select{|x| x.skill_id == @skill_command_window.selected_skill.id}.first
        $game_battle_commands.add_inputskills_command(command)
        change_battle_command(command)
      end
    else
      update_skill_command_selection_bc_inputskills()
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
  
  #//////////////////////////////////////////////////////////////////////////
  # * Public Methods
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Alias start
  #--------------------------------------------------------------------------
  alias start_bc_inputskills start unless $@
  def start
    start_bc_inputskills
    
    @button_inputting = false
    @input = false
    
    @input_window = Window_InputSkill.new(440, 50, 180, 56, nil)
    @input_window.opacity = 0
    @input_window.active = false
    @input_window.visible = false

  end
  
  #--------------------------------------------------------------------------
  # * Alias terminate
  #--------------------------------------------------------------------------
  alias terminate_bc_inputskills terminate unless $@
  def terminate
    terminate_bc_inputskills
    
    @input_window.dispose if @input_window != nil
  end
  
  #--------------------------------------------------------------------------
  # * Alias update_basic
  #--------------------------------------------------------------------------
  alias update_basic_bc_inputskills update_basic unless $@
  def update_basic(main = false)
    update_basic_bc_inputskills(main)

    @input_window.update
  end
  
  #--------------------------------------------------------------------------
  # * Alias custom_actor_command_active?
  #--------------------------------------------------------------------------
  alias custom_actor_command_active_bc_inputskills? custom_actor_command_active? unless $@
  def custom_actor_command_active?
    if @button_inputting
      return true
    else 
      return custom_actor_command_active_bc_inputskills?
    end
  end
  
  #--------------------------------------------------------------------------
  # * Alias update_actor_command_input
  #--------------------------------------------------------------------------
  alias update_actor_command_input_bc_inputskills update_actor_command_input unless $@
  def update_actor_command_input
    if @button_inputting
      update_button_inputting     # Button inputting (for Blitz Command)
    else
      update_actor_command_input_bc_inputskills
    end
  end
  
  #--------------------------------------------------------------------------
  # * Alias execute_battle_commands
  #--------------------------------------------------------------------------
  alias execute_battle_commands_bc_inputskills execute_battle_commands unless $@
  def execute_battle_commands(actor)
    command = @actor_command_window.selected_command
    
    if (command.is_a?(List_Command) && command.filter != nil && command.filter.mode == "inputskills" ) ||
       command.is_a?(InputSkill_Command)
      @input = true
    end
    
    execute_battle_commands_bc_inputskills(actor)
  end
  
  #--------------------------------------------------------------------------
  # * Execute Battle Actions
  #--------------------------------------------------------------------------
  alias execute_action_bc_inputskills execute_action unless $@
  def execute_action
    if @active_battler.action.failed_input?
      execute_action_failed_input
      @active_battler.action.clear
    else
      execute_action_bc_inputskills
    end
  end
  
  #--------------------------------------------------------------------------
  # * Execute Battle Action: Failed Skill Input
  #--------------------------------------------------------------------------
  def execute_action_failed_input
    @top_help_window.set_text("Incorrect Skill input")
    @top_help_window.visible = true
    @active_battler.stamina_wait = true
    @active_battler.empty_stamina
    execute_basic_action(nil)
    @top_help_window.visible = false
  end
  
  #//////////////////////////////////////////////////////////////////////////
  # * Scene Commands
  #//////////////////////////////////////////////////////////////////////////

  #--------------------------------------------------------------------------
  # * Alias confirm_enemy_selection
  #--------------------------------------------------------------------------
  alias confirm_enemy_selection_bc_inputskills confirm_enemy_selection unless $@
  def confirm_enemy_selection(actor)
    if @input
      start_button_inputting
    else
      confirm_enemy_selection_bc_inputskills(actor)
    end
  end

  #--------------------------------------------------------------------------
  # * Alias confirm_actor_selection
  #--------------------------------------------------------------------------
  alias confirm_actor_selection_bc_inputskills confirm_actor_selection unless $@
  def confirm_actor_selection(actor)
    if @input
      start_button_inputting
    else
      confirm_actor_selection_bc_inputskills(actor)
    end
  end
  
  #--------------------------------------------------------------------------
  # * Alias confirm_no_selection_skill
  #--------------------------------------------------------------------------
  alias confirm_no_selection_skill_bc_inputskills confirm_no_selection_skill unless $@
  def confirm_no_selection_skill(skill)  
    if @input
      start_button_inputting
    else
      confirm_no_selection_skill_bc_inputskills(skill)
    end
  end
  
  #--------------------------------------------------------------------------
  # * Setup everything needed to start listening for button inputs
  #--------------------------------------------------------------------------
  def start_button_inputting
    actor = $game_party.members[@actor_index]
    input_command = BATTLECOMMANDS_CONFIG::BC_INPUTSKILLS_COMMANDS.select{|x| x.skill_id == actor.action.skill.id}.first

    @button_inputting = true
    @button_index = 0
    @skill_input = input_command.button_inputs
    @button_time = input_command.button_time
    @input_window.window_update(input_command)
    @input_window.visible = true
    deactivate_stamina(0)
  end
  
  #--------------------------------------------------------------------------
  # * Reset everything changed when listening for button inputs ends
  #--------------------------------------------------------------------------
  def end_button_inputting
    end_skill_selection()
    end_target_actor_selection(false)
    end_target_enemy_selection(false)
    
    @input = false
    @button_inputting = false
    @button_index = nil
    @skill_input = nil
    @button_time = nil
    @input_window.visible = false
    activate_stamina(0)
  end
  
  #--------------------------------------------------------------------------
  # * Wait until player presses a button. Returns false if doesn't match
  # input string or if time is reduced to 0. Else returns true.
  #--------------------------------------------------------------------------
  def update_button_inputting
    actor = $game_party.members[@actor_index]
    current_input = get_current_input()
    @button_time -= 1
 
    @input_window.update_values(@button_index, @button_time)
            
    if current_input != nil
      if @skill_input[@button_index] == current_input
        @button_index += 1
        if @skill_input[@button_index].nil?
          Sound.play_decision
          add_to_battleline(actor)
          end_actor_command_selection()
          end_button_inputting()
        else
          Sound.play_cursor
        end
      else
        Sound.play_buzzer
        actor.action.set_failed_input
        add_to_battleline(actor)
        end_actor_command_selection()
        end_button_inputting()
      end
    end
    
    # Timer ends with no complete blitz
    if @button_time == 0
      Sound.play_buzzer
      actor.action.set_failed_input
      add_to_battleline(actor)
      end_actor_command_selection()
      end_button_inputting()
    end
    
  end
  
  #//////////////////////////////////////////////////////////////////////////
  # * Private Methods
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * 
  #--------------------------------------------------------------------------
  def get_current_input()
    if Input.trigger?(Input::A)
      return Input::A
    elsif Input.trigger?(Input::B)
      return Input::B
    elsif Input.trigger?(Input::C)
      return Input::C
    elsif Input.trigger?(Input::X)
      return Input::X
    elsif Input.trigger?(Input::Y)
      return Input::Y
    elsif Input.trigger?(Input::Z)
      return Input::Z
    elsif Input.trigger?(Input::L)
      return Input::L
    elsif Input.trigger?(Input::R)
      return Input::R
    elsif Input.trigger?(Input::LEFT)
      return Input::LEFT
    elsif Input.trigger?(Input::RIGHT)
      return Input::RIGHT
    elsif Input.trigger?(Input::DOWN)
      return Input::DOWN
    elsif Input.trigger?(Input::UP)
      return Input::UP
    end
  end
  private :get_current_input
  
end

#==============================================================================
# ** UCInputIcon
#------------------------------------------------------------------------------
#  Represents an input Icon user control on a window
#==============================================================================

class UCInputIcon < UCIcon
  
  #//////////////////////////////////////////////////////////////////////////
  # * Public Methods
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Draw the icon on the window
  #--------------------------------------------------------------------------
  def draw()
    if self.iconIndex != nil
      bitmap = Cache.system("InputIconSet")
      @cIcon.img_bitmap = bitmap
      @cIcon.src_rect = Rect.new(self.iconIndex % 16 * 24, self.iconIndex / 16 * 24, 
                        24, 24)
      @cIcon.draw()
    end
  end
  
end

#==============================================================================
# ** Color
#------------------------------------------------------------------------------
#  Contains the different colors
#==============================================================================

class Color
  
  #//////////////////////////////////////////////////////////////////////////
  # * Public Methods
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Get Input Time Gauge Color 1
  #--------------------------------------------------------------------------
  def self.input_time_gauge_color1
    return text_color(7)
  end
  
  #--------------------------------------------------------------------------
  # * Get Input Time Gauge Color 2
  #--------------------------------------------------------------------------
  def self.input_time_gauge_color2
    return text_color(8)
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
    alias battle_commands_strings_bc_inputskills battle_commands_strings unless $@
    def battle_commands_strings
      return battle_commands_strings_bc_inputskills.merge(
      {
       BATTLECOMMANDS_CONFIG::BC_INPUTSKILLS => ["Input Skills", "Uses a skill with custom inputs"]
      })
    end
    
  end
end

#==============================================================================
# ** Window_InputSkill
#------------------------------------------------------------------------------
#  This window shows the details of a skill
#==============================================================================

class Window_InputSkill < Window_Base
  include EBJB
  
  #//////////////////////////////////////////////////////////////////////////
  # * Attributes
  #//////////////////////////////////////////////////////////////////////////
  
  # UCBar for the time left for the input
  attr_reader :ucBarTimeLeft
  # Icon for the next input of the skill
  attr_reader :ucInput
  # Input Skill Command object of the skill
  attr_accessor :input_command

  #//////////////////////////////////////////////////////////////////////////
  # * Constructors
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Object Initialization
  #     x : window X coordinate
  #     y : window Y coordinate
  #     width : window width
  #     height : window height
  #     input_command : Input Skill Command object
  #     spacing : spacing between stats
  #--------------------------------------------------------------------------
  def initialize(x, y, width, height, input_command, spacing = 10)
    super(x, y, width, height)
    
    @ucInput = UCInputIcon.new(self, Rect.new(0,0,24,24), 0)
    @ucInput.active = active
    @ucInput.visible = visible
    
    @ucBarTimeLeft = UCBar.new(self, Rect.new(48,4,100,WLH-8), 
                              Color.input_time_gauge_color1, Color.input_time_gauge_color2, Color.gauge_back_color, 
                              0, 0, 4, Color.gauge_back_color)
    @ucBarTimeLeft.active = active
    @ucBarTimeLeft.visible = visible
    
    window_update(input_command)
  end

  #//////////////////////////////////////////////////////////////////////////
  # * Public Methods
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Update
  #     members : party members
  #--------------------------------------------------------------------------
  def window_update(input_command)
    if input_command != nil
      @input_command = input_command
      @ucInput.iconIndex = BATTLECOMMANDS_CONFIG::INPUT_ICONS[input_command.button_inputs[0]]
      @ucBarTimeLeft.value = 0
      @ucBarTimeLeft.max_value = input_command.button_time
    end
    refresh()
  end

  #--------------------------------------------------------------------------
  # * Update
  #     members : party members
  #--------------------------------------------------------------------------
  def update_values(button_index, button_time)
    if button_index != nil && button_time != nil
      @ucInput.iconIndex = BATTLECOMMANDS_CONFIG::INPUT_ICONS[input_command.button_inputs[button_index]]
      @ucBarTimeLeft.value = button_time
    end
    refresh()
  end
  
  #--------------------------------------------------------------------------
  # * Refresh
  #--------------------------------------------------------------------------
  def refresh()
    self.contents.clear
    @ucInput.draw()
    @ucBarTimeLeft.draw()
  end
  
end


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


################################################################################
#                     EBJB Morph Command - EBJB_BCMORPH               #   VX   #
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
$imported["EBJB_BCMORPH"] = true

#==============================================================================
# ** BATTLECOMMANDS_CONFIG
#------------------------------------------------------------------------------
#  Contains the BattleCommands_Config configuration
#==============================================================================

module EBJB
  
  #==============================================================================
  # ** Morph_Command
  #------------------------------------------------------------------------------
  #  Represents a morph battle command
  #==============================================================================

  class Morph_Command < Battle_Command
    
    #//////////////////////////////////////////////////////////////////////////
    # * Attributes
    #//////////////////////////////////////////////////////////////////////////
    
    # Skill ID
    attr_reader :skill_id
    # 
    attr_reader :morph_actor_id
    
    #//////////////////////////////////////////////////////////////////////////
    # * Properties
    #//////////////////////////////////////////////////////////////////////////
    
    #--------------------------------------------------------------------------
    # * Get the skill object of the morph battle command
    #--------------------------------------------------------------------------
    def skill()
      return $data_skills[@skill_id]
    end
    
    #--------------------------------------------------------------------------
    # * Get the name of the morph battle command
    #--------------------------------------------------------------------------
    def name()
      return $data_skills[@skill_id].name
    end
    
    #--------------------------------------------------------------------------
    # * Get the description of the morph battle command
    #--------------------------------------------------------------------------
    def description()
      return $data_skills[@skill_id].description
    end
    
    #//////////////////////////////////////////////////////////////////////////
    # * Constructors
    #//////////////////////////////////////////////////////////////////////////
    
    #--------------------------------------------------------------------------
    # * Object Initialization
    #     id : command id
    #     skill_id : Skill ID to get name and description of the battle command
    #     morph_actor_id :
    #--------------------------------------------------------------------------
    def initialize(skill_id, morph_actor_id)
      super(Utilities.generate_battle_command_uid("BC_MORPH_"+skill_id.to_s), 
            BATTLECOMMANDS_CONFIG::BC_MORPH)
      @skill_id = skill_id
      @morph_actor_id = morph_actor_id
    end
    
  end
  
  module BATTLECOMMANDS_CONFIG
       
    #------------------------------------------------------------------------
    # Battle Commands Definitions
    #------------------------------------------------------------------------
    
    # Unique ids used to represent battle commands
    # BATTLE_COMMAND = 10xx
    BC_MORPH = Utilities.generate_battle_command_uid("BC_MORPH")
    BC_REVERT = Utilities.generate_battle_command_uid("BC_REVERT")
    
    # Battle commands data
    DATA_BATTLE_COMMANDS.push(List_Command.new(BC_MORPH, BC_MORPH, UsableItemFilter.new("morph")))
    DATA_BATTLE_COMMANDS.push(Battle_Command.new(BC_REVERT, BC_REVERT))
    
    # Actor Battle Commands Settings
    #   syntax: actor_id => [LearningBattleCommand.new('type', ...), ...]
    #   Where 'type' is one of the Battle commands above
    CLASS_BATTLE_COMMANDS_LEARNINGS[1].push(LearningBattleCommand.new(BC_MORPH))
    CLASS_BATTLE_COMMANDS_LEARNINGS[10] = []
    CLASS_BATTLE_COMMANDS_LEARNINGS[10].push(LearningBattleCommand.new(BC_REVERT))
    
    # Actor Battle Commands Settings
    #   syntax: actor_id => ['type', ...]
    #   Where 'type' is one of the Battle commands above
    ACTOR_BATTLE_COMMANDS[10] = [BC_ATTACK, BC_REVERT, BC_SKILL, BC_GUARD, BC_ITEM]
    
    #------------------------------------------------------------------------
    # Morph Command related 
    #------------------------------------------------------------------------
    
    # Morph Commands Settings
    #   syntax: skill_id => array of inputs
    BC_MORPH_COMMANDS = [
      Morph_Command.new(102, 10)
    ]
    
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
    # Battle Status related
    #------------------------------------------------------------------------
       
    # Y adjusment for the face images in the battle status window 
    #   syntax: Face filename => array for the eight indexes in a face file
    FACE_Y_ADJUST_IMAGES["Evil"] = [0, 0, 0, 0, 0, 0, 26, 0]
    
    #------------------------------------------------------------------------
    # Scene Battle related
    #------------------------------------------------------------------------
    
    # Actor Battler Settings
    #   syntax: actor_id => CustomBattler(width, height, move_speed, ba_show_weapon)
    ACTOR_BATTLER_SETTINGS[10] = CustomBattler.new(32, 32, 5)
    
    #------------------------------------------------------------------------
    # Battle Animations Definitions
    #------------------------------------------------------------------------
    
    # Actor Battle Action Animations definitions
    #   syntax: actor_id => {'type' => animation_id}
    #   Where 'type' is one of the IP modes above
    ACTOR_BA_ANIMS[10] = {
      BA_STAND    => 202, 
      BA_HURT     => 203, 
      BA_MOVE     => 204, 
      BA_ATTACK   => 205,
      BA_HIT_HIGH => 206,
      BA_HIT_MID  => 207,
      BA_HIT_LOW  => 208,
      BA_DEAD     => 209,
      BA_DEFEND   => 210,
      BA_REVIVE   => 211,
      BA_RUN      => 204,
      BA_DODGE    => 212,
      BA_SKILL    => 213,
      BA_ITEM     => 214,
      #BA_STATE   => 214,
      BA_VICTORY  => 215,
      BA_INTRO    => 216
    }
    
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
  # * Public Methods
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Alias is_command_equipped?
  #--------------------------------------------------------------------------
  alias is_command_equipped_bc_morph? is_command_equipped? unless $@
  def is_command_equipped?(obj)
    if (obj.is_a?(RPG::Skill))
      return active_battle_commands.any?{|c| c.is_a?(Morph_Command) && c.skill_id == obj.id} || 
             is_command_equipped_bc_morph?(obj)
    elsif (obj.is_a?(Morph_Command))
      return active_battle_commands.any?{|c| c.id == obj.id} 
    else
      return is_command_equipped_bc_morph?(obj)
    end
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
  # * Set Morph Attack
  #--------------------------------------------------------------------------
  def set_morph(skill_id)
    @kind = 0
    @basic = 11
    @skill_id = skill_id
  end
  
  #--------------------------------------------------------------------------
  # * Set Revert Attack
  #--------------------------------------------------------------------------
  def set_revert
    @kind = 0
    @basic = 12
  end
  
  #--------------------------------------------------------------------------
  # * Morph Attack Determination
  #--------------------------------------------------------------------------
  def morph?
    return (@kind == 0 and @basic == 11)
  end
  
  #--------------------------------------------------------------------------
  # * Revert Attack Determination
  #--------------------------------------------------------------------------
  def revert?
    return (@kind == 0 and @basic == 12)
  end
  
  #--------------------------------------------------------------------------
  # * Get Skill Object
  #--------------------------------------------------------------------------
  alias skill_bc_morph skill unless $@
  def skill
    return morph? ? $data_skills[@skill_id] : skill_bc_morph
  end
  
  #--------------------------------------------------------------------------
  # * Alias determine_action_name
  #--------------------------------------------------------------------------
  alias determine_action_name_bc_morph determine_action_name unless $@
  def determine_action_name()
    action_name = ""
    if self.morph?
      action_name = "Morph"
    elsif self.revert?
      action_name = "Revert"
    else
      action_name = determine_action_name_bc_morph
    end
    
    return action_name
  end
  
  #--------------------------------------------------------------------------
  # * Alias make_targets
  #--------------------------------------------------------------------------
  alias make_targets_bc_morph make_targets unless $@
  def make_targets
    if self.morph?
      return make_obj_targets(skill)
    elsif self.revert?
      return [battler]
    else
      return make_targets_bc_morph
    end
  end
  
  #--------------------------------------------------------------------------
  # * Alias valid?
  #--------------------------------------------------------------------------
  alias valid_bc_morph? valid? unless $@
  def valid?
    return true if morph?
    return true if revert?
    return valid_bc_morph?
  end
  
end
#==============================================================================
# ** Game_Battle_Commands
#------------------------------------------------------------------------------
#  This class handles the battle commands array. The instance of this class is
# referenced by $game_battle_commands.
#==============================================================================

class Game_Battle_Commands
  include EBJB
  
  #//////////////////////////////////////////////////////////////////////////
  # * Public Methods
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Add existing command
  #     command : command object
  #--------------------------------------------------------------------------
  def add_morph_command(command)
    id = command.id
    if (!@data.include?(id))
      @data[id] = command
    end
    return @data[id]
  end
  
end

#==============================================================================
# ** Game_Party
#------------------------------------------------------------------------------
#  This class handles the party. It includes information on amount of gold 
# and items. The instance of this class is referenced by $game_party.
#==============================================================================

class Game_Party < Game_Unit
  
  #--------------------------------------------------------------------------
  # * Replace an Actor
  #     actor_id : actor ID
  #     index :
  #--------------------------------------------------------------------------
  def replace_actor(actor_id, index)
    if index > -1 and index < @actors.size and not @actors.include?(actor_id)
      @actors[index] = actor_id
      $game_player.refresh
    end
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
  alias apply_bc_morph apply unless $@
  def apply(x)
    if x != nil && x.is_a?(RPG::UsableItem)
       
      case mode
        when "morph"
          return applyMorph(x)
        #when
          #...
        else
          return apply_bc_morph(x)
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
  def applyMorph(x)
    if BATTLECOMMANDS_CONFIG::BC_MORPH_COMMANDS.collect{|y| y.skill_id}.include?(x.id)
      return true
    else
      return false
    end
  end
  private:applyMorph
  
end

#==============================================================================
# ** Scene_BattleCommands
#------------------------------------------------------------------------------
#  This class performs the battle commands change screen processing.
#===============================================================================

class Scene_BattleCommands < Scene_Base
  include EBJB
    
  #//////////////////////////////////////////////////////////////////////////
  # * Public Methods
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Alias start
  #--------------------------------------------------------------------------
  alias start_bc_morph start unless $@
  def start
    start_bc_morph()
    
    @morph_command_window = Window_Skill_Command.new(640, 208, 440, 176)
    @morph_command_window.active = false
    @morph_command_window.visible = false
    @morph_command_window.index = -1
    
    @morph_command_window.help_window = @help_window

    @morph_details_window = Window_SkillDetails.new(0,384,640,96,nil)
    @morph_details_window.visible = false
    @morph_command_window.detail_window = @morph_details_window
    
    [@morph_command_window, @morph_details_window].each{
      |w| w.opacity = BATTLESYSTEM_CONFIG::WINDOW_OPACITY;
          w.back_opacity = BATTLESYSTEM_CONFIG::WINDOW_BACK_OPACITY
    }
  end
  
  #--------------------------------------------------------------------------
  # * Alias terminate
  #--------------------------------------------------------------------------
  alias terminate_bc_morph terminate unless $@
  def terminate
    terminate_bc_morph()
    
    @morph_command_window.dispose if @morph_command_window != nil
    @morph_details_window.dispose if @morph_details_window != nil
  end
  
  #--------------------------------------------------------------------------
  # * Alias update
  #--------------------------------------------------------------------------
  alias update_bc_morph update unless $@
  def update
    update_bc_morph()
    
    @morph_command_window.update
    @morph_details_window.update
    if @morph_command_window.active
      update_morph_command_selection
    end
  end
  
  #--------------------------------------------------------------------------
  # * Alias update_window_movement
  #--------------------------------------------------------------------------
  alias update_window_movement_bc_morph update_window_movement unless $@
  def update_window_movement()
    update_window_movement_bc_morph()
    
    # Battle command window position
    if @morph_command_window.active
      if @battle_commands_window.x > 0
        @battle_commands_window.x -= 20
      end
    end
    
    # Morph window position
    if @morph_command_window.active
      @morph_command_window.visible = true
      if @morph_command_window.x > 200
        @morph_command_window.x -= 40
      end
    else
      if @morph_command_window.x < 640
        @morph_command_window.x += 40
      else
        @morph_command_window.visible = false
      end
    end
    
  end
  
  #//////////////////////////////////////////////////////////////////////////
  # * Private Methods
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Alias update_detail_window
  #-------------------------------------------------------------------------- 
  alias update_detail_window_bc_morph update_detail_window unless $@
  def update_detail_window(command)    
    if command.is_a?(Morph_Command)
      @actor_commands_window.detail_window = @morph_details_window
    else
      update_detail_window_bc_morph(command)
    end
  end
  private :update_detail_window
  
  #//////////////////////////////////////////////////////////////////////////
  # * Scene input management methods
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Alias update_battle_command_selection
  #--------------------------------------------------------------------------
  alias update_battle_command_selection_bc_morph update_battle_command_selection unless $@
  def update_battle_command_selection()
    update_battle_command_selection_bc_morph()
    
    if Input.trigger?(Input::RIGHT)
      if @battle_commands_window.selected_battle_command.is_a?(List_Command)
        if @battle_commands_window.selected_battle_command.type == BATTLECOMMANDS_CONFIG::BC_MORPH
          morph_command()
        end
      end
    end    
  end
  private :update_battle_command_selection

  #--------------------------------------------------------------------------
  # * Update Morph Command Selection
  #--------------------------------------------------------------------------
  def update_morph_command_selection()
    if Input.trigger?(Input::B)
      Sound.play_cancel
      cancel_morph_command()
      
    elsif Input.trigger?(Input::C)
      if @morph_command_window.selected_skill == nil ||
         (!@autobattle_window.active && !@morph_command_window.enable?(@morph_command_window.selected_skill))
        Sound.play_buzzer
      else
        Sound.play_decision
        command = BATTLECOMMANDS_CONFIG::BC_MORPH_COMMANDS.select{|x| x.skill_id == @morph_command_window.selected_skill.id}.first
        $game_battle_commands.add_morph_command(command)
        change_battle_command(command)
      end
    end
  end
  private :update_morph_command_selection
  
  #//////////////////////////////////////////////////////////////////////////
  # * Scene Commands
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Change battle command
  #     command : New battle command
  #--------------------------------------------------------------------------
  alias change_battle_command_bc_morph change_battle_command unless $@
  def change_battle_command(command)
    change_battle_command_bc_morph(command)
    
    if @morph_command_window.active
      @morph_command_window.window_update(@actor, @battle_commands_window.selected_battle_command.filter)
    end
  end
  private :change_battle_command
  
  #--------------------------------------------------------------------------
  # * Morph command
  #--------------------------------------------------------------------------
  def morph_command()
    @battle_commands_window.active = false
    @morph_command_window.window_update(@actor, @battle_commands_window.selected_battle_command.filter)
    @morph_command_window.active = true
    @morph_command_window.index = 0
  end
  private :morph_command
  
  #--------------------------------------------------------------------------
  # * Cancel Morph command
  #--------------------------------------------------------------------------
  def cancel_morph_command()
    @battle_commands_window.active = true
    @morph_command_window.active = false
    @morph_command_window.index = -1
    @battle_commands_window.call_update_help()
    @morph_details_window.window_update(nil)
    @morph_details_window.visible = false
  end
  private :cancel_morph_command
  
end

#==============================================================================
# ** Scene_Battle
#------------------------------------------------------------------------------
#   This class performs battle screen processing.
#==============================================================================

class Scene_Battle < Scene_Base
  include EBJB
  
  #//////////////////////////////////////////////////////////////////////////
  # * Public Methods
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Alias start
  #--------------------------------------------------------------------------
  alias start_bc_morph start unless $@
  def start
    start_bc_morph
    
    @morph = false
    @orig_actors = $game_party.members.collect{|x| x.id}
  end
  
  #--------------------------------------------------------------------------
  # * Alias execute_battle_commands
  #--------------------------------------------------------------------------
  alias execute_battle_commands_bc_morph execute_battle_commands unless $@
  def execute_battle_commands(actor)
    command = @actor_command_window.selected_command
    if command.type == BATTLECOMMANDS_CONFIG::BC_MORPH
      if command.is_a?(List_Command)
        Sound.play_decision
        @skill_window.filter = command.filter
        @morph = true
        start_skill_selection(actor)  
      elsif command.is_a?(Morph_Command)
        Sound.play_decision
        @morph = true
        determine_skill(command.skill)
      end
    elsif command.type == BATTLECOMMANDS_CONFIG::BC_REVERT
      Sound.play_decision
      actor.action.set_revert
      add_to_battleline(actor)
      end_actor_command_selection()
    else
      execute_battle_commands_bc_morph(actor)
    end
  end
  
  #--------------------------------------------------------------------------
  # * Confirm Skill
  #     skill : Skill object
  #--------------------------------------------------------------------------
  def determine_skill(skill)   
    if @morph
      if !skill.partners.empty?
        for actor_id in skill.partners
          $game_actors[actor_id].action.set_morph(skill.id)
        end
      else
        $game_party.members[@actor_index].action.set_morph(skill.id)
      end
    else
      if !skill.partners.empty?
        for actor_id in skill.partners
          $game_actors[actor_id].action.set_skill(skill.id)
        end
      else
        $game_party.members[@actor_index].action.set_skill(skill.id)
      end
    end
    
    @skill_window.active = false
    if skill.need_selection?
      if skill.for_opponent?
        start_target_enemy_selection
      else
        start_target_actor_selection
      end
    else
      confirm_no_selection_skill(skill)
    end
  end
  
  #--------------------------------------------------------------------------
  # * Alias execute_action
  #--------------------------------------------------------------------------
  alias execute_action_bc_morph execute_action unless $@
  def execute_action
    if @active_battler.action.morph?
      @morph = false
      execute_action_morph
      @active_battler.action.clear
    elsif @active_battler.action.revert?
      execute_action_revert
      @active_battler.action.clear
    else
      execute_action_bc_morph
    end
  end
  
  #--------------------------------------------------------------------------
  # * Execute Battle Action: Morph
  #--------------------------------------------------------------------------
  def execute_action_morph
    @top_help_window.set_text(@active_battler.action.skill.name)
    @top_help_window.visible = true
    @active_battler.stamina_wait = true
    @active_battler.empty_stamina
    execute_basic_action(nil)
    @top_help_window.visible = false
  end
  
  #--------------------------------------------------------------------------
  # * Execute Battle Action: Revert
  #--------------------------------------------------------------------------
  def execute_action_revert
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
  alias determine_custom_battler_animation_bc_morph determine_custom_battler_animation unless $@
  def determine_custom_battler_animation(battler, obj)
    if battler.action.morph?
      return battler.battle_animation.ani_skills[battler.action.skill_id]
    else
      return determine_custom_battler_animation_bc_morph(battler, obj)
    end
  end
  
  #--------------------------------------------------------------------------
  # * 
  #     obj : 
  #--------------------------------------------------------------------------
  alias do_custom_animation_bc_morph do_custom_animation unless $@
  def do_custom_animation(battler, obj)
    if battler.action.morph?
      battler.battle_animation.do_ani_skill(battler.action.skill_id)
    else
      do_custom_animation_bc_morph(battler, obj)
    end
  end
   
  #--------------------------------------------------------------------------
  # * Update actors objects when one change
  #--------------------------------------------------------------------------
  def update_actor_change
    if @last_actors != $game_party.members
      for actor in $game_party.members - @last_actors
        set_actor_position(actor)
        actor.empty_state_removal_time
        actor.empty_stamina
        if actor.dead?
          actor.battle_animation.ani_start_at_end=true
          actor.battle_animation.do_ani_dead
        else
          actor.battle_animation.do_ani_stand
        end
      end
      @last_actors = $game_party.members
      @status_window.window_update($game_party.members)
    end
  end

  #--------------------------------------------------------------------------
  # * 
  #     obj : 
  #--------------------------------------------------------------------------
  alias do_custom_target_effect_bc_morph do_custom_target_effect unless $@
  def do_custom_target_effect(battler, target, obj)
    if battler.action.morph?
      target.skill_effect(battler, battler.action.skill)
    else
      do_custom_target_effect_bc_morph(battler, target, obj)
    end
  end
  
  #--------------------------------------------------------------------------
  # * 
  #     obj : 
  #--------------------------------------------------------------------------
  alias display_custom_animation_bc_morph display_custom_animation unless $@
  def display_custom_animation(battler, targets)
    if battler.action.morph?
      display_animation(targets, battler.action.skill.animation_id, true)
      
      morph_command = BATTLECOMMANDS_CONFIG::BC_MORPH_COMMANDS.select{|x| x.skill_id == battler.action.skill.id}.first
      for t in targets
        index = t.index
        $game_party.members[index].hidden = true
        current_level = $game_party.members[index].level
        $game_party.replace_actor(morph_command.morph_actor_id, index)
        # Set same level to the morphed actor
        $game_party.members[index].change_level(current_level, false)
        update_actor_change()
        @spriteset.create_actor($game_party.members[index], index)
        $game_party.members[index].hidden = false
      end
    elsif battler.action.revert?
      morph_command = BATTLECOMMANDS_CONFIG::BC_MORPH_COMMANDS.select{|x| x.morph_actor_id == battler.id}.first
      display_animation([battler], morph_command.skill.animation_id, true)

      index = battler.index
      $game_party.members[index].hidden = true
      $game_party.replace_actor(@orig_actors[index], index)
      update_actor_change()
      @spriteset.create_actor($game_party.members[index], index)
      $game_party.members[index].hidden = false
    else
      display_custom_animation_bc_morph(battler, targets)
    end
  end

  #--------------------------------------------------------------------------
  # * Victory Processing
  #--------------------------------------------------------------------------
  alias process_victory_bc_morph process_victory unless $@
  def process_victory
    actor_ids = $game_party.members.collect{|x| x.id}
    if @orig_actors != actor_ids
      for i in 0..@orig_actors.size-1
        if @orig_actors[i] != actor_ids[i]
          morph_command = BATTLECOMMANDS_CONFIG::BC_MORPH_COMMANDS.select{|x| x.morph_actor_id == actor_ids[i]}.first
          display_animation([$game_party.members[i]], morph_command.skill.animation_id, true)

          $game_party.members[i].hidden = true
          $game_party.replace_actor(@orig_actors[i], i)
          update_actor_change()
          @spriteset.create_actor($game_party.members[i], i)
          $game_party.members[i].hidden = false
        end
      end
    end
    process_victory_bc_morph()
  end
  
  #--------------------------------------------------------------------------
  # * End Battle
  #     result : Results (0: win, 1: escape, 2:lose)
  #--------------------------------------------------------------------------
  alias battle_end_bc_morph battle_end unless $@
  def battle_end(result)
    if result != 0
      actor_ids = $game_party.members.collect{|x| x.id}
      if @orig_actors != actor_ids
        for i in 0..@orig_actors.size-1
          if @orig_actors[i] != actor_ids[i]
            $game_party.replace_actor(@orig_actors[i], i)
          end
        end
      end
    end
    battle_end_bc_morph(result)
  end
  
end

#==============================================================================
# ** Spriteset_Battle
#------------------------------------------------------------------------------
#  This class brings together battle screen sprites. It's used within the
# Scene_Battle class.
#==============================================================================

class Spriteset_Battle
  include EBJB
  
  #//////////////////////////////////////////////////////////////////////////
  # * Public Methods
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Create Actor Sprite
  #     actor : 
  #     index : 
  #--------------------------------------------------------------------------
  def create_actor(actor, index)
    if index > -1 and index < @actor_sprites.size
      @actor_sprites[index].dispose
      @actor_sprites[index] = Sprite_Battler.new(@viewport1, actor)
      @actor_sprites[index].update
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
    alias battle_commands_strings_bc_morph battle_commands_strings unless $@
    def battle_commands_strings
      return battle_commands_strings_bc_morph.merge(
      {
       BATTLECOMMANDS_CONFIG::BC_MORPH => ["Morph", "Morph self to unique form"],
       BATTLECOMMANDS_CONFIG::BC_REVERT => ["Revert", "Revert to the old self"]
      })
    end
    
  end
end

#==============================================================================
# ** Window_ActorCommand
#------------------------------------------------------------------------------
#  This window is used to select actor commands, such as "Attack" or "Skill".
#==============================================================================

class Window_ActorCommand < Window_Command
  include EBJB
  
  #//////////////////////////////////////////////////////////////////////////
  # * Public Methods
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Alias update_detail
  #--------------------------------------------------------------------------
  alias update_detail_bc_morph update_detail unless $@
  def update_detail
    update_detail_bc_morph()
    
    if selected_command != nil
      if selected_command.is_a?(Morph_Command)
        @detail_window.window_update(selected_command.skill)
      else
        update_detail_bc_morph()
      end
    else
      update_detail_bc_morph()
    end
  end
  
  #--------------------------------------------------------------------------
  # * Alias is_switchable
  #--------------------------------------------------------------------------
  alias is_switchable_bc_morph is_switchable unless $@
  def is_switchable
    return is_switchable_bc_morph() ||
           (selected_command != nil && 
           (selected_command.is_a?(Morph_Command) && detail_window.is_a?(Window_SkillDetails)))
  end
  
  #//////////////////////////////////////////////////////////////////////////
  # * Private Methods
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Alias create_item
  #--------------------------------------------------------------------------
  alias create_item_bc_morph create_item unless $@
  def create_item(index)
    command = @commands[index]
    rect = item_rect(index, true)
    
    if command.is_a?(Morph_Command)
      control = UCSkill.new(self, command.skill, rect, @actor.calc_mp_cost(command.skill))
    else
      control = create_item_bc_morph(index)
    end

    return control
  end
  private :create_item
  
end

#===============================================================================
# ** Window_AutoBattle_Command
#------------------------------------------------------------------------------
#  This window displays 
#===============================================================================

class Window_AutoBattle_Command < Window_Base
  include EBJB
  
  #//////////////////////////////////////////////////////////////////////////
  # * Private Methods
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Alias create_item
  #--------------------------------------------------------------------------
  alias create_item_bc_morph create_item unless $@
  def create_item(command, actor, rect)
    if command.is_a?(Morph_Command)
      return UCSkill.new(self, command.skill, rect, actor.calc_mp_cost(command.skill))
    else
      return create_item_bc_morph(command, actor, rect)
    end
  end
  private :create_item
  
end


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


################################################################################
#                 EBJB Blue Magic Command - EBJB_BCBLUEMAGIC          #   VX   #
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
$imported["EBJB_BCBLUEMAGIC"] = true

#==============================================================================
# ** BATTLECOMMANDS_CONFIG
#------------------------------------------------------------------------------
#  Contains the BattleCommands_Config configuration
#==============================================================================

module EBJB
  
  module BATTLECOMMANDS_CONFIG
    
    #------------------------------------------------------------------------
    # Blue Magic Command related 
    #------------------------------------------------------------------------
    
    # Unique ids used to represent Blue Magic Learn types
    # BM_TYPE = 10xx
    
    # Learn magic when battler is hit by it
    BM_TYPE_HIT = 1001
    # Learn magic when enemy cast it
    BM_TYPE_CAST = 1002
    # Learn magic when battler analyze the enemy
    BM_TYPE_ANALYZE = 1003
    
    # Array of learning types, combine any type that you want
    BC_BLUE_MAGIC_LEARN_TYPE = [BM_TYPE_HIT, BM_TYPE_CAST, BM_TYPE_ANALYZE]
    
    # Skills ID that are blue magics
    BC_BLUE_MAGIC_SKILLS_ID = (104..105).to_a
    
    #------------------------------------------------------------------------
    # Battle Commands Definitions
    #------------------------------------------------------------------------
    
    # Unique ids used to represent battle commands
    # BATTLE_COMMAND = 10xx
    BC_BLUE_MAGIC = Utilities.generate_battle_command_uid("BC_BLUE_MAGIC")
    BC_ANALYZE = Utilities.generate_battle_command_uid("BC_ANALYZE")
    
    # Battle commands data
    DATA_BATTLE_COMMANDS.push(List_Command.new(BC_BLUE_MAGIC, BC_SKILL, UsableItemFilter.new("bluemagic")))
    DATA_BATTLE_COMMANDS.push(Skill_Command.new(BC_ANALYZE, 91, true))
    
    # Actor Battle Commands Settings
    #   syntax: actor_id => [LearningBattleCommand.new('type', ...), ...]
    #   Where 'type' is one of the Battle commands above
    CLASS_BATTLE_COMMANDS_LEARNINGS[4].push(LearningBattleCommand.new(BC_BLUE_MAGIC))
    CLASS_BATTLE_COMMANDS_LEARNINGS[4].push(LearningBattleCommand.new(BC_ANALYZE))
    
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
  
  #--------------------------------------------------------------------------
  # * Alias skills
  #--------------------------------------------------------------------------
  alias skills_bc_bluemagic skills unless $@
  def skills
    result = skills_bc_bluemagic
    if is_command_equipped?($game_battle_commands[BATTLECOMMANDS_CONFIG::BC_BLUE_MAGIC])
      result.concat($game_party.blue_magic_skills)
    end
    return result
  end
  
  #--------------------------------------------------------------------------
  # * Alias skill_learn?
  #--------------------------------------------------------------------------
  alias skill_learn_bc_bluemagic? skill_learn? unless $@
  def skill_learn?(skill)
    return $game_party.blue_magic_learn?(skill) || skill_learn_bc_bluemagic?(skill)
  end
  
end

#==============================================================================
# ** Game_Battler
#------------------------------------------------------------------------------
#  This class deals with battlers. It's used as a superclass of the Game_Actor
# and Game_Enemy classes.
#==============================================================================

class Game_Battler

  #--------------------------------------------------------------------------
  # * Alias skill_effect
  #--------------------------------------------------------------------------
  alias skill_effect_bc_bluemagic skill_effect unless $@
  def skill_effect(user, skill)
    if BATTLECOMMANDS_CONFIG::BC_BLUE_MAGIC_SKILLS_ID.include?(skill.id)
      if BATTLECOMMANDS_CONFIG::BC_BLUE_MAGIC_LEARN_TYPE.include?(BATTLECOMMANDS_CONFIG::BM_TYPE_CAST)
        $game_party.learn_blue_magic(skill.id)
      end
      
      if BATTLECOMMANDS_CONFIG::BC_BLUE_MAGIC_LEARN_TYPE.include?(BATTLECOMMANDS_CONFIG::BM_TYPE_HIT)
        if self.actor? && !user.actor?
          $game_party.learn_blue_magic(skill.id)
        end     
      end
      
      if BATTLECOMMANDS_CONFIG::BC_BLUE_MAGIC_LEARN_TYPE.include?(BATTLECOMMANDS_CONFIG::BM_TYPE_ANALYZE)
        if !self.actor? && user.actor?
          enemy_skills = self.enemy.actions.collect{|x| $data_skills[x.skill_id] if x.skill?}
          enemy_skills.compact!
          for s in enemy_skills
            if BATTLECOMMANDS_CONFIG::BC_BLUE_MAGIC_SKILLS_ID.include?(s.id)
              $game_party.learn_blue_magic(s.id)
            end
          end
        end     
      end
    end
    
    skill_effect_bc_bluemagic(user, skill)
  end
  
end

#==============================================================================
# ** Game_Party
#------------------------------------------------------------------------------
#  This class handles the party. It includes information on amount of gold 
# and items. The instance of this class is referenced by $game_party.
#==============================================================================

class Game_Party < Game_Unit
  
  #//////////////////////////////////////////////////////////////////////////
  # * Constructors
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  alias initialize_bc_bluemagic initialize unless $@
  def initialize
    initialize_bc_bluemagic
    @blue_magic_skills = []
  end
  
  #//////////////////////////////////////////////////////////////////////////
  # * Public Methods
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Get Blue Magic Skill Object Array
  #--------------------------------------------------------------------------
  def blue_magic_skills
    result = []
    for i in @blue_magic_skills
      result.push($data_skills[i])
    end
    return result
  end
  
  #--------------------------------------------------------------------------
  # * Learn Blue Magic Skill
  #     skill_id : skill ID
  #--------------------------------------------------------------------------
  def learn_blue_magic(skill_id)
    unless blue_magic_learn?($data_skills[skill_id])
      @blue_magic_skills.push(skill_id)
      @blue_magic_skills.sort!
    end
  end
  
  #--------------------------------------------------------------------------
  # * Forget Blue Magic Skill
  #     skill_id : skill ID
  #--------------------------------------------------------------------------
  def forget_blue_magic(skill_id)
    @blue_magic_skills.delete(skill_id)
  end
  
  #--------------------------------------------------------------------------
  # * Determine if Finished Learning Blue Magic Skill
  #     skill : skill
  #--------------------------------------------------------------------------
  def blue_magic_learn?(skill)
    return @blue_magic_skills.include?(skill.id)
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
  alias apply_bc_blue_magic apply unless $@
  def apply(x)
    if x != nil && x.is_a?(RPG::UsableItem)
       
      case mode
        when "bluemagic"
          return applyBlueMagic(x)
        #when
          #...
        else
          return apply_bc_blue_magic(x)
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
  def applyBlueMagic(x)
    if BATTLECOMMANDS_CONFIG::BC_BLUE_MAGIC_SKILLS_ID.include?(x.id)
      return true
    else
      return false
    end
  end
  private:applyBlueMagic
  
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
    alias battle_commands_strings_bc_blue_magic battle_commands_strings unless $@
    def battle_commands_strings
      return battle_commands_strings_bc_blue_magic.merge(
      {
       BATTLECOMMANDS_CONFIG::BC_BLUE_MAGIC => ["Blue Magic", "Uses a monster spell"]
      })
    end
    
  end
end


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


################################################################################
#               EBJB Multi Attack Command - EBJB_BCMULTIATTACK        #   VX   #
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
$imported["EBJB_BCMULTIATTACK"] = true

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
    BC_MULTI_ATTACK = Utilities.generate_battle_command_uid("BC_MULTI_ATTACK")
    
    # Battle commands data
    DATA_BATTLE_COMMANDS.push(Battle_Command.new(BC_MULTI_ATTACK, BC_ATTACK, nil, false, 2))
    
    # Actor Battle Commands Settings
    #   syntax: actor_id => [LearningBattleCommand.new('type', ...), ...]
    #   Where 'type' is one of the Battle commands above
    CLASS_BATTLE_COMMANDS_LEARNINGS[2].push(LearningBattleCommand.new(BC_MULTI_ATTACK))
    
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
  # * Set Multi Attack
  #--------------------------------------------------------------------------
  def set_multi_attack_actions(nbr)
    @multi_actions_kind = 0
    set_multi_actions(nbr)
  end
  
  #--------------------------------------------------------------------------
  # * Multi Attack Determination
  #--------------------------------------------------------------------------
  def multi_attack_actions?
    return (@multi_actions_kind == 0)
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
  alias execute_battle_commands_bc_multi_attack execute_battle_commands unless $@
  def execute_battle_commands(actor)
    command = @actor_command_window.selected_command
    if command.id == BATTLECOMMANDS_CONFIG::BC_MULTI_ATTACK
      actor.set_multi_attack_actions(command.multiple)
    end
    execute_battle_commands_bc_multi_attack(actor)
  end
  
  #--------------------------------------------------------------------------
  # * Alias confirm_enemy_selection
  #--------------------------------------------------------------------------
  alias confirm_enemy_selection_bc_multi_attack confirm_enemy_selection unless $@
  def confirm_enemy_selection(actor)
    if actor.multi_attack_actions? 
      action = actor.action.dup
      actor.add_multi_action(action)
      
      if !actor.multi_actions_completed?
        start_target_enemy_selection
      else
        end_target_enemy_selection(false)
        add_to_battleline(actor)
        end_actor_command_selection()
      end
    else
      confirm_enemy_selection_bc_multi_attack(actor)
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
    alias battle_commands_strings_bc_multi_attack battle_commands_strings unless $@
    def battle_commands_strings
      return battle_commands_strings_bc_multi_attack.merge(
      {
       BATTLECOMMANDS_CONFIG::BC_MULTI_ATTACK => ["Multi Attack", "Attacks multiple enemies at the same time"]
      })
    end
    
  end
end


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


#===============================================================================
# 
# Shanghai Simple Script - Minigame Slot Machine
# Last Date Updated: 2010.05.18
# Level: Normal
# 
# This is a minigame script. It's easy to play. Press Z to stop each individual
# slot and try to line up all three within the five possible combinations.
#===============================================================================
# Instructions
# -----------------------------------------------------------------------------
# To install this script, open up your script editor and copy/paste this script
# to an open slot below ▼ Materials but above ▼ Main. Remember to save.
# 
# Do a script call for
#   $game_variables[1] = slot_machine(x, y)
# 
# x is the length of the slot reel where the longer it is, the more items there
# are and y is the cursor speed. Works with Battle Engine Melody.
#===============================================================================
 
$imported = {} if $imported == nil
$imported["MinigameSlotMachine"] = true

module SSS
  # This is the image file from the system folder used for the slot machine.
  SLOT_MACHINE_SHEET = "MiniGameSlots"
  # These are the sound effects for the slot machine game.
  SLOT_MACHINE_STOP  = RPG::SE.new("Open3", 100, 120)
  SLOT_MACHINE_CLICK = RPG::SE.new("Switch1", 100, 100)
  SLOT_MACHINE_LUCKY = RPG::SE.new("Chime2", 100, 120)
  SLOT_MACHINE_MISS  = RPG::SE.new("Buzzer2", 100, 100)
  # This hash contains data used to refer icons.
  SLOT_ICONS ={
     1 => 214,
     2 => 215,
     3 =>  94,
     4 => 205,
     5 => 203,
     6 => 201,
     7 => 204,
     8 => 200,
  } # Remove this and perish.
module SPRITESET
  #--------------------------------------------------------------------------
  # * Slot Machine Game
  #--------------------------------------------------------------------------
  def slot_machine(possibilities = SSS::SLOT_ICONS.size, speed = 5)
    @slot_possibilities = [possibilities, 3].max
    @slot_speed = [[speed, 1].max, 20].min
    @slot_stops = 0
    @start_ticks = 80
    @stop_ticks = 60
    create_slot_machine_sprites
    create_slot_machine_planes
  end
  #--------------------------------------------------------------------------
  # * Create Slot Machine Sprites
  #--------------------------------------------------------------------------
  def create_slot_machine_sprites
    vp = @viewportC.nil? ? @viewport3 : @viewportC
    @slot_machine_sprite = Sprite_Base.new(vp)
    bitmap1 = Bitmap.new(240, 264)
    bitmap2 = Cache.system(SSS::SLOT_MACHINE_SHEET)
    # Make the Main Body
    rect = Rect.new(0, 0, 240, 240)
    bitmap1.blt(0, 0, bitmap2, rect)
    # Make the Instructions
    unless $game_temp.in_battle
      rect = Rect.new(0, 240, 192, 24)
      bitmap1.blt(24, 240, bitmap2, rect)
    end
    # Apply Sprite
    @slot_machine_sprite.bitmap = bitmap1
    @slot_machine_sprite.x = (Graphics.width - 240) / 2
    @slot_machine_sprite.y = Graphics.height - 368
    # Make Sounds
    @stop_sound = SSS::SLOT_MACHINE_STOP
    @click_sound = SSS::SLOT_MACHINE_CLICK
    @slot_machine_sprite.opacity = 0
  end
  #--------------------------------------------------------------------------
  # * Dispose Slot Machine Sprites
  #--------------------------------------------------------------------------
  def dispose_slot_machine_sprites
    unless @slot_machine_sprite.nil?
      @slot_machine_sprite.bitmap.dispose
      @slot_machine_sprite.dispose
      @slot_machine_sprite = nil
    end
    unless @slot_results_sprite.nil?
      @slot_results_sprite.bitmap.dispose
      @slot_results_sprite.dispose
      @slot_results_sprite = nil
    end
    unless @slot_viewport1.nil?
      @slot_viewport1.dispose
      @slot_viewport1 = nil
      @slot_plane1.bitmap.dispose
      @slot_plane1.dispose
      @slot_plane1 = nil
      @slot_viewport2.dispose
      @slot_viewport2 = nil
      @slot_plane2.bitmap.dispose
      @slot_plane2.dispose
      @slot_plane2 = nil
      @slot_viewport3.dispose
      @slot_viewport3 = nil
      @slot_plane3.bitmap.dispose
      @slot_plane3.dispose
      @slot_plane3 = nil
    end
  end
  #--------------------------------------------------------------------------
  # * Create Slot Machine Planes
  #--------------------------------------------------------------------------
  def create_slot_machine_planes
    # Create Planes
    rect = Rect.new(0, 0, 44, 140)
    rect.x = @slot_machine_sprite.x+48
    rect.y = @slot_machine_sprite.y+52
    vp = @viewportC.nil? ? @viewport3 : @viewportC
    @slot_viewport1 = Viewport.new(rect.clone)
    @slot_viewport1.z = vp.z
    @slot_plane1 = Plane.new(@slot_viewport1)
    rect.x = @slot_machine_sprite.x+98
    rect.y = @slot_machine_sprite.y+52
    @slot_viewport2 = Viewport.new(rect.clone)
    @slot_viewport2.z = vp.z
    @slot_plane2 = Plane.new(@slot_viewport2)
    rect.x = @slot_machine_sprite.x+148
    rect.y = @slot_machine_sprite.y+52
    @slot_viewport3 = Viewport.new(rect.clone)
    @slot_viewport3.z = vp.z
    @slot_plane3 = Plane.new(@slot_viewport3)
    bitmap0 = Cache.system("IconSet")
    # Make Plane Bitmap 1
    bitmap1 = Bitmap.new(48, @slot_possibilities * 48)
    @slot_array1 = []
    n = 1
    @slot_possibilities.times do
      @slot_array1.insert(rand(@slot_array1.size+1), n)
      n += 1
    end
    for id in @slot_array1
      icon_index = SSS::SLOT_ICONS[id]
      rect1 = Rect.new(-2, (@slot_array1.index(id)) * 48 - 4, 48, 48)
      rect2 = Rect.new(icon_index % 16 * 24, icon_index / 16 * 24, 24, 24)
      bitmap1.stretch_blt(rect1, bitmap0, rect2) 
      @slot_plane1.bitmap = bitmap1
    end
    # Make Plane Bitmap 2
    bitmap2 = Bitmap.new(48, @slot_possibilities * 48)
    @slot_array2 = []
    n = 1
    @slot_possibilities.times do
      @slot_array2.insert(rand(@slot_array2.size+1), n)
      n += 1
    end
    for id in @slot_array2
      icon_index = SSS::SLOT_ICONS[id]
      rect1 = Rect.new(-2, (@slot_array2.index(id)) * 48 - 4, 48, 48)
      rect2 = Rect.new(icon_index % 16 * 24, icon_index / 16 * 24, 24, 24)
      bitmap2.stretch_blt(rect1, bitmap0, rect2) 
      @slot_plane2.bitmap = bitmap2
    end
    # Make Plane Bitmap 3
    bitmap3 = Bitmap.new(48, @slot_possibilities * 48)
    @slot_array3 = []
    n = 1
    @slot_possibilities.times do
      @slot_array3.insert(rand(@slot_array3.size+1), n)
      n += 1
    end
    for id in @slot_array3
      icon_index = SSS::SLOT_ICONS[id]
      rect1 = Rect.new(-2, (@slot_array3.index(id)) * 48 - 4, 48, 48)
      rect2 = Rect.new(icon_index % 16 * 24, icon_index / 16 * 24, 24, 24)
      bitmap3.stretch_blt(rect1, bitmap0, rect2) 
      @slot_plane3.bitmap = bitmap3
    end
    @slot_plane1.opacity = 0
    @slot_plane2.opacity = 0
    @slot_plane3.opacity = 0
  end
  #--------------------------------------------------------------------------
  # * Update Slot Machine
  #--------------------------------------------------------------------------
  def update_slot_machine
    case @start_ticks
    when 61..80
      slot_speed = 0
      @slot_machine_sprite.opacity += 16
      @slot_plane1.opacity += 16
      @slot_plane2.opacity += 16
      @slot_plane3.opacity += 16
    when 41..60
      slot_speed = [@slot_speed / 4, 1].max
    when 21..40
      slot_speed = [@slot_speed / 2, 1].max
    when 1..20
      slot_speed = [@slot_speed * 3 / 4, 1].max
    when 0
      slot_speed = @slot_speed
    end
    @slot_machine_sprite.update
    @start_ticks -= 1 if @start_ticks > 0
    @slot_plane1.oy -= slot_speed if @slot_stops < 1
    @slot_plane2.oy -= slot_speed if @slot_stops < 2
    @slot_plane3.oy -= slot_speed if @slot_stops < 3
    @sound_ticks = 24 if @sound_ticks.nil? or @sound_ticks <= 0
    @sound_ticks -= slot_speed
    @click_sound.play if @sound_ticks <= 0 and @slot_stops < 3
    stop_slot if @start_ticks <= 0 and Input.trigger?(Input::C)
    slot_correction
  end
  #--------------------------------------------------------------------------
  # * Stop Slot
  #--------------------------------------------------------------------------
  def stop_slot
    return if @slot_stops == 3
    @stop_sound.play
    @slot_stops += 1
    bitmap = Cache.system(SSS::SLOT_MACHINE_SHEET)
    rect = Rect.new(192, 240, 48, 48)
    case @slot_stops
    when 1
      @slot_machine_sprite.bitmap.blt(46, 193, bitmap, rect)
    when 2
      @slot_machine_sprite.bitmap.blt(96, 193, bitmap, rect)
    when 3
      @slot_machine_sprite.bitmap.blt(146, 193, bitmap, rect)
    end
  end
  #--------------------------------------------------------------------------
  # * Slot Correction
  #--------------------------------------------------------------------------
  def slot_correction
    if @slot_stops >= 1 and @slot_plane1.oy % 48 != 0
      case @slot_plane1.oy % 48
      when 39..47; value = [5, @slot_speed].min
      when 29..38; value = [4, @slot_speed].min
      when 19..28; value = [3, @slot_speed].min
      when  9..18; value = [2, @slot_speed].min
      else; value = 1
      end
      @slot_plane1.oy -= value
    end
    if @slot_stops >= 2 and @slot_plane2.oy % 48 != 0
      case @slot_plane2.oy % 48
      when 39..47; value = [5, @slot_speed].min
      when 29..38; value = [4, @slot_speed].min
      when 19..28; value = [3, @slot_speed].min
      when  9..18; value = [2, @slot_speed].min
      else; value = 1
      end
      @slot_plane2.oy -= value
    end
    if @slot_stops >= 3 and @slot_plane3.oy % 48 != 0
      case @slot_plane3.oy % 48
      when 39..47; value = [5, @slot_speed].min
      when 29..38; value = [4, @slot_speed].min
      when 19..28; value = [3, @slot_speed].min
      when  9..18; value = [2, @slot_speed].min
      else; value = 1
      end
      @slot_plane3.oy -= value
    end
  end
  #--------------------------------------------------------------------------
  # * Slot Machine Stopped
  #--------------------------------------------------------------------------
  def slot_machine_stopped
    return false if @slot_stops < 3
    return false unless @slot_plane1.oy % 48 == 0
    return false unless @slot_plane2.oy % 48 == 0
    return false unless @slot_plane3.oy % 48 == 0
    @stop_ticks -= 1
    return false unless @stop_ticks < 0
    return true
  end
  #--------------------------------------------------------------------------
  # * Finish Slot Machine
  #--------------------------------------------------------------------------
  def finish_slot_machine
    results = slot_machine_results
    # Create Victory Image
    vp = @viewportC.nil? ? @viewport3 : @viewportC
    @slot_results_sprite = Sprite_Base.new(vp)
    bitmap1 = Bitmap.new(96, 24)
    bitmap2 = Cache.system(SSS::SLOT_MACHINE_SHEET)
    if results > 0
      SSS::SLOT_MACHINE_LUCKY.play
      rect = Rect.new(92, 264, 96, 24)
    end
    if results <= 0
      SSS::SLOT_MACHINE_MISS.play
      rect = Rect.new(0, 264, 96, 24)
    end
    bitmap1.blt(0, 0, bitmap2, rect)
    @slot_results_sprite.bitmap = bitmap1
    @slot_results_sprite.ox = 48
    @slot_results_sprite.oy = 24
    @slot_results_sprite.x = Graphics.width/2
    @slot_results_sprite.y = Graphics.height/2
    @slot_results_sprite.zoom_x = 2.0
    @slot_results_sprite.zoom_y = 2.0
    # Fade out Slot Machine
    loop do
      @slot_machine_sprite.opacity -= 16
      @slot_plane1.opacity -= 16
      @slot_plane2.opacity -= 16
      @slot_plane3.opacity -= 16
      @slot_machine_sprite.update
      @slot_results_sprite.y -= 1
      @slot_results_sprite.update
      $scene.update_basic
      break if @slot_machine_sprite.opacity < 1
    end
    loop do
      @slot_results_sprite.opacity -= 8
      @slot_results_sprite.update
      $scene.update_basic
      break if @slot_results_sprite.opacity < 1
    end
    dispose_slot_machine_sprites
    return results
  end
  #--------------------------------------------------------------------------
  # * Slot Machine Results
  #--------------------------------------------------------------------------
  def slot_machine_results
    results = [0]
    sa = []
    # Calculate Slot Positions for Slot 1
    top_slot = @slot_array1[@slot_plane1.oy / 48 % @slot_possibilities]
    mid_slot = @slot_array1[(@slot_plane1.oy + 48) / 48 % @slot_possibilities]
    low_slot = @slot_array1[(@slot_plane1.oy + 96) / 48 % @slot_possibilities]
    sa.push(top_slot, mid_slot, low_slot)
    # Calculate Slot Positions for Slot 2
    top_slot = @slot_array2[@slot_plane2.oy / 48 % @slot_possibilities]
    mid_slot = @slot_array2[(@slot_plane2.oy + 48) / 48 % @slot_possibilities]
    low_slot = @slot_array2[(@slot_plane2.oy + 96) / 48 % @slot_possibilities]
    sa.push(top_slot, mid_slot, low_slot)
    # Calculate Slot Positions for Slot 3
    top_slot = @slot_array3[@slot_plane3.oy / 48 % @slot_possibilities]
    mid_slot = @slot_array3[(@slot_plane3.oy + 48) / 48 % @slot_possibilities]
    low_slot = @slot_array3[(@slot_plane3.oy + 96) / 48 % @slot_possibilities]
    sa.push(top_slot, mid_slot, low_slot)
    # Push matches to results
    for i in 1..@slot_possibilities
      results.push(i) if sa[0] == i and sa[0] == sa[3] and sa[0] == sa[6]
      results.push(i) if sa[0] == i and sa[0] == sa[4] and sa[0] == sa[8]
      results.push(i) if sa[1] == i and sa[1] == sa[4] and sa[1] == sa[7]
      results.push(i) if sa[2] == i and sa[2] == sa[4] and sa[2] == sa[6]
      results.push(i) if sa[2] == i and sa[2] == sa[5] and sa[2] == sa[8]
    end
    return results.max
  end
end
end

#==============================================================================
# ** Game_Interpreter
#==============================================================================
 
class Game_Interpreter
  #--------------------------------------------------------------------------
  # * Slot Machine Game
  #--------------------------------------------------------------------------
  def slot_machine(possibilities = SSS::SLOT_ICONS.size, speed = 5)
    return 0 unless $scene.is_a?(Scene_Map) or $scene.is_a?(Scene_Battle)
    return $scene.slot_machine(possibilities, speed)
  end
end
 
#==============================================================================
# ** Spriteset_Map
#==============================================================================
 
class Spriteset_Map
  include SSS::SPRITESET
  #--------------------------------------------------------------------------
  # * Dispose
  #--------------------------------------------------------------------------
  alias dispose_sss_spriteset_map_slots dispose unless $@
  def dispose
    dispose_sss_spriteset_map_slots
    dispose_slot_machine_sprites
  end
end
 
#==============================================================================
# ** Spriteset_Battle
#==============================================================================
 
class Spriteset_Battle
  include SSS::SPRITESET
  #--------------------------------------------------------------------------
  # * Dispose
  #--------------------------------------------------------------------------
  alias dispose_sss_spriteset_battle_slots dispose unless $@
  def dispose
    dispose_sss_spriteset_battle_slots
    dispose_slot_machine_sprites
  end
end
 
#==============================================================================
# ** Scene_Map
#==============================================================================
 
class Scene_Map < Scene_Base
  #--------------------------------------------------------------------------
  # * Public Instance Variables
  #--------------------------------------------------------------------------
  attr_accessor :spriteset
  #--------------------------------------------------------------------------
  # * Slot Machine
  #--------------------------------------------------------------------------
  def slot_machine(possibilities = SSS::SLOT_ICONS.size, speed = 5)
    @spriteset.slot_machine(possibilities, speed)
    loop do
      update_basic
      @spriteset.update_slot_machine
      break if @spriteset.slot_machine_stopped
    end
    return @spriteset.finish_slot_machine
  end
end
 
#==============================================================================
# ** Scene_Battle
#==============================================================================
 
class Scene_Battle < Scene_Base
  #--------------------------------------------------------------------------
  # * Public Instance Variables
  #--------------------------------------------------------------------------
  attr_accessor :spriteset
  #--------------------------------------------------------------------------
  # * Slot Machine
  #--------------------------------------------------------------------------
  def slot_machine(possibilities = SSS::SLOT_ICONS.size, speed = 5)
    @spriteset.slot_machine(possibilities, speed)
    loop do
      update_basic
      @spriteset.update_slot_machine
      break if @spriteset.slot_machine_stopped
    end
    return @spriteset.finish_slot_machine
  end
end

#===============================================================================
# 
# END OF FILE
# 
#===============================================================================

################################################################################
#                EBJB Slot Machine Command - EBJB_BCSLOTMACHINE       #   VX   #
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
$imported["EBJB_BCSLOTMACHINE"] = true

#==============================================================================
# ** BATTLECOMMANDS_CONFIG
#------------------------------------------------------------------------------
#  Contains the BattleCommands_Config configuration
#==============================================================================

module EBJB
  
  module BATTLECOMMANDS_CONFIG
    
    #------------------------------------------------------------------------
    # Slot Machine Command related 
    #------------------------------------------------------------------------
    
    # Skills ID that are slot machine skills (depends on SSS::SLOT_ICONS)
    BC_SLOT_MACHINE_SKILLS ={
      1 => 111,
      2 => 112,
      3 => 113
    }
    
    #------------------------------------------------------------------------
    # Battle Commands Definitions
    #------------------------------------------------------------------------
    
    # Unique ids used to represent battle commands
    # BATTLE_COMMAND = 10xx
    BC_SLOT_MACHINE = Utilities.generate_battle_command_uid("BC_SLOT_MACHINE")
    
    # Battle commands data
    DATA_BATTLE_COMMANDS.push(Battle_Command.new(BC_SLOT_MACHINE, BC_SLOT_MACHINE))
    
    # Actor Battle Commands Settings
    #   syntax: actor_id => [LearningBattleCommand.new('type', ...), ...]
    #   Where 'type' is one of the Battle commands above
    CLASS_BATTLE_COMMANDS_LEARNINGS[1].push(LearningBattleCommand.new(BC_SLOT_MACHINE))
    
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
  # * Set Slot Machine Attack
  #--------------------------------------------------------------------------
  def set_slot_machine(skill_id)
    @kind = 0
    @basic = 18
    @skill_id = skill_id
  end
  
  #--------------------------------------------------------------------------
  # * Set Failed Slot Machine Attack
  #--------------------------------------------------------------------------
  def set_failed_slot_machine
    @kind = 0
    @basic = 19
  end
  
  #--------------------------------------------------------------------------
  # * Slot Machine Attack Determination
  #--------------------------------------------------------------------------
  def slot_machine?
    return (@kind == 0 and @basic == 18)
  end
  
  #--------------------------------------------------------------------------
  # * Failed Slot Machine Attack Determination
  #--------------------------------------------------------------------------
  def failed_slot_machine?
    return (@kind == 0 and @basic == 19)
  end

  #--------------------------------------------------------------------------
  # * Get Skill Object
  #--------------------------------------------------------------------------
  alias skill_bc_slot_machine skill unless $@
  def skill
    return slot_machine? ? $data_skills[@skill_id] : skill_bc_slot_machine
  end
  
  #--------------------------------------------------------------------------
  # * Alias make_targets
  #--------------------------------------------------------------------------
  alias make_targets_bc_slot_machine make_targets unless $@
  def make_targets
    if slot_machine?
      return make_obj_targets(skill)
    elsif failed_slot_machine?
      return [battler]
    else
      return make_targets_bc_slot_machine
    end
  end
  
  #--------------------------------------------------------------------------
  # * Alias determine_action_name
  #--------------------------------------------------------------------------
  alias determine_action_name_bc_slot_machine determine_action_name unless $@
  def determine_action_name()
    action_name = ""
    if self.slot_machine?
      action_name = "Slot Machine"
    else
      action_name = determine_action_name_bc_slot_machine
    end
    
    return action_name
  end
  
  #--------------------------------------------------------------------------
  # * Alias valid?
  #--------------------------------------------------------------------------
  alias valid_bc_slot_machine? valid? unless $@
  def valid?
    return true if slot_machine?
    return true if failed_slot_machine?
    return valid_bc_slot_machine?
  end
  
end
#==============================================================================
# ** Scene_Battle
#------------------------------------------------------------------------------
#   This class performs battle screen processing.
#==============================================================================

class Scene_Battle < Scene_Base
  include EBJB
  
  #//////////////////////////////////////////////////////////////////////////
  # * Public Methods
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Alias start
  #--------------------------------------------------------------------------
  alias start_bc_slot_machine start unless $@
  def start
    start_bc_slot_machine
    
    @slot_machine_inputting = false
  end
  
  #--------------------------------------------------------------------------
  # * Alias custom_actor_command_active?
  #--------------------------------------------------------------------------
  alias custom_actor_command_active_bc_slot_machine? custom_actor_command_active? unless $@
  def custom_actor_command_active?
    if @slot_machine_inputting
      return true
    else 
      return custom_actor_command_active_bc_slot_machine?
    end
  end
  
  #--------------------------------------------------------------------------
  # * Alias execute_battle_commands
  #--------------------------------------------------------------------------
  alias execute_battle_commands_bc_slot_machine execute_battle_commands unless $@
  def execute_battle_commands(actor)
    command = @actor_command_window.selected_command
    if command.type == BATTLECOMMANDS_CONFIG::BC_SLOT_MACHINE
      Sound.play_decision
      skill_id = determine_slot_machine_skill(actor)
      if skill_id == nil
        actor.action.set_failed_slot_machine
      else
        actor.action.set_slot_machine(skill_id)
      end
      add_to_battleline(actor)
      end_actor_command_selection()
    else
      execute_battle_commands_bc_slot_machine(actor)
    end
  end
  
  #--------------------------------------------------------------------------
  # * Alias execute_action
  #--------------------------------------------------------------------------
  alias execute_action_bc_slot_machine execute_action unless $@
  def execute_action
    if @active_battler.action.slot_machine?
      execute_action_skill
      @active_battler.action.clear
    elsif @active_battler.action.failed_slot_machine?
      execute_action_failed_slot_machine
      @active_battler.action.clear
    else
      execute_action_bc_slot_machine
    end
  end
  
  #--------------------------------------------------------------------------
  # * Execute Battle Action: Failed Slot Machine
  #--------------------------------------------------------------------------
  def execute_action_failed_slot_machine
    @top_help_window.set_text("Bad luck")
    @top_help_window.visible = true
    @active_battler.stamina_wait = true
    @active_battler.empty_stamina
    execute_basic_action(nil)
    @top_help_window.visible = false
  end
  
  #--------------------------------------------------------------------------
  # * 
  #--------------------------------------------------------------------------
  def start_slot_machine_inputting
    actor = $game_party.members[@actor_index]
    actor.white_flash = true
    @targeting_window.active = false
    @slot_machine_inputting = true
    deactivate_stamina(0)
  end
  
  #--------------------------------------------------------------------------
  # * 
  #--------------------------------------------------------------------------
  def end_slot_machine_inputting
    for actor in $game_party.members
      actor.white_flash = false
    end

    @slot_machine_inputting = false
    activate_stamina(0)
  end
  
  #--------------------------------------------------------------------------
  # * 
  #--------------------------------------------------------------------------
  def determine_slot_machine_skill(battler)
    skill_id = nil
    
    start_slot_machine_inputting
    # Run Slot Machine and get the results
    result = slot_machine(BATTLECOMMANDS_CONFIG::BC_SLOT_MACHINE_SKILLS.size)
    end_slot_machine_inputting

    # Determines the skill ID from the results
    if result != 0
      skill_id = BATTLECOMMANDS_CONFIG::BC_SLOT_MACHINE_SKILLS[result]
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
    alias battle_commands_strings_bc_slot_machine battle_commands_strings unless $@
    def battle_commands_strings
      return battle_commands_strings_bc_slot_machine.merge(
      {
       BATTLECOMMANDS_CONFIG::BC_SLOT_MACHINE => ["Slot Machine", "Uses a magical slot machine"]
      })
    end
    
  end
end


