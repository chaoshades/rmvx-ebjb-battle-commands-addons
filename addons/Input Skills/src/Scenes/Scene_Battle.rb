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
    
    @input_window = Window_InputSkill.new(440, 40, 180, 56, nil)
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
