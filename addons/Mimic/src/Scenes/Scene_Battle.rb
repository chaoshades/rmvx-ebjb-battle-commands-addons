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
