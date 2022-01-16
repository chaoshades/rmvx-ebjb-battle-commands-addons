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
