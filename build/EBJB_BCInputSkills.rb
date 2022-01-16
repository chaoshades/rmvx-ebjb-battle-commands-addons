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

