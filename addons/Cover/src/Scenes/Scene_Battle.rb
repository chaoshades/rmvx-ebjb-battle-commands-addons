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
  alias execute_battle_commands_bc_cover execute_battle_commands unless $@
  def execute_battle_commands(actor)
    command = @actor_command_window.selected_command
    if command.type == BATTLECOMMANDS_CONFIG::BC_COVER
      Sound.play_decision
      actor.action.set_cover
      start_target_actor_selection
    else
      execute_battle_commands_bc_cover(actor)
    end
  end
  
  #--------------------------------------------------------------------------
  # * Alias execute_action
  #--------------------------------------------------------------------------
  alias execute_action_bc_cover execute_action unless $@
  def execute_action
    if @active_battler.action.cover? 
      execute_action_cover
      @active_battler.action.clear
    else
      execute_action_bc_cover
    end
  end
  
  #--------------------------------------------------------------------------
  # * Execute Battle Action: Cover
  #--------------------------------------------------------------------------
  def execute_action_cover
    @top_help_window.set_text(@active_battler.action.determine_action_name)
    @top_help_window.visible = true
    @active_battler.stamina_wait = true
    @active_battler.empty_stamina
    
    $game_party.members.each do |ally|
      ally.protector = nil if ally.protected? && ally.protector == @active_battler
    end
    
    target = @active_battler.action.target_index
    $game_party.members[target].protector = @active_battler
    
    @top_help_window.visible = false
  end
  
end
