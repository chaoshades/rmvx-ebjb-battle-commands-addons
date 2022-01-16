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
