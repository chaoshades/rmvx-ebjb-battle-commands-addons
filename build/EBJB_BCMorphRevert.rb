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

