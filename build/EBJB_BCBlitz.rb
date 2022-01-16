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

