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
