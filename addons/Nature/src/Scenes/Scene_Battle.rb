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
  alias execute_battle_commands_bc_nature execute_battle_commands unless $@
  def execute_battle_commands(actor)
    command = @actor_command_window.selected_command
    if command.type == BATTLECOMMANDS_CONFIG::BC_NATURE
      Sound.play_decision
      skill_id = determine_nature_skill(actor)
      if skill_id == nil
        actor.action.set_failed_nature
      else
        actor.action.set_nature(skill_id)
      end
      add_to_battleline(actor)
      end_actor_command_selection()
    else
      execute_battle_commands_bc_nature(actor)
    end
  end
  
  #--------------------------------------------------------------------------
  # * Alias execute_action
  #--------------------------------------------------------------------------
  alias execute_action_bc_nature execute_action unless $@
  def execute_action
    if @active_battler.action.nature?
      execute_action_skill
      @active_battler.action.clear
    elsif @active_battler.action.failed_nature?
      execute_action_failed_nature
      @active_battler.action.clear
    else
      execute_action_bc_nature
    end
  end
  
  #--------------------------------------------------------------------------
  # * Execute Battle Action: Failed Nature
  #--------------------------------------------------------------------------
  def execute_action_failed_nature
    @top_help_window.set_text("No response")
    @top_help_window.visible = true
    @active_battler.stamina_wait = true
    @active_battler.empty_stamina
    execute_basic_action(nil)
    @top_help_window.visible = false
  end
  
  #--------------------------------------------------------------------------
  # * 
  #--------------------------------------------------------------------------
  def determine_nature_skill(battler)
    skill_id = nil
    
    # Finds the current area
    current_area = nil
    areas = $data_areas.values
    i = 0
    while current_area == nil && i < areas.size
      if $game_player.in_area?(areas[i])
        current_area = areas[i]
      end
      i += 1
    end
    
    # Determines the skill ID randomly depending on probabilities
    if current_area != nil
      available_skills = BATTLECOMMANDS_CONFIG::BC_NATURE_TERRAIN_SKILLS[current_area.terrain]
      
      # Determine terrain skill ratio with bonus
      ratio = 1
      ratio -= battler.total_nature_rate_bonus.to_f / 100
      
      # Takes randomly one skill in the list
      index = rand(available_skills.length)

      # Determines if the skill is successfully casted
      denom = (available_skills[index].denominator * ratio).ceil
      if denom <= 1 || rand(denom) == 0
        skill_id = available_skills[index].skill_id
      end
    end
    
    return skill_id
  end
  
end
