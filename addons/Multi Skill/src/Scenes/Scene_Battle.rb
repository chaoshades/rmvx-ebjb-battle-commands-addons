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
