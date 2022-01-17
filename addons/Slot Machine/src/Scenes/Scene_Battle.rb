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
