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
  alias execute_battle_commands_bc_jump execute_battle_commands unless $@
  def execute_battle_commands(actor)
    command = @actor_command_window.selected_command
    if command.type == BATTLECOMMANDS_CONFIG::BC_JUMP
      Sound.play_decision
      actor.action.set_jump
      start_target_enemy_selection
    else
      execute_battle_commands_bc_jump(actor)
    end
  end
  
  #--------------------------------------------------------------------------
  # * Alias execute_action
  #--------------------------------------------------------------------------
  alias execute_action_bc_jump execute_action unless $@
  def execute_action
    if @active_battler.action.jump?

      if @active_battler.battle_animation.is_jumping?
        execute_action_land
        @active_battler.action.clear
      else
        execute_action_jump
      end
    else
      execute_action_bc_jump
    end
  end
  
  #--------------------------------------------------------------------------
  # * 
  #--------------------------------------------------------------------------
  alias battler_update_stamina_bc_jump battler_update_stamina unless $@
  def battler_update_stamina(battler)
    if battler.battle_animation.is_jumping?
      battler.increase_stamina
    else
      battler_update_stamina_bc_jump(battler)
    end
  end
  
  #--------------------------------------------------------------------------
  # * Alias make_auto_action
  #--------------------------------------------------------------------------
  alias make_auto_action_bc_jump make_auto_action unless $@
  def make_auto_action(battler)
    action_made = make_auto_action_bc_jump(battler)
    if !action_made && battler.battle_animation.is_jumping?
      return true
    end
    return action_made
  end
  
  #--------------------------------------------------------------------------
  # * Execute Battle Action: Jump
  #--------------------------------------------------------------------------
  def execute_action_jump
    @top_help_window.set_text(@active_battler.action.determine_action_name)
    @top_help_window.visible = true
    @active_battler.stamina_wait = true
    @active_battler.empty_stamina
    @active_battler.hidden = true
    @active_battler.battle_animation.do_ani_jump
    @top_help_window.visible = false
  end
  
  #--------------------------------------------------------------------------
  # * Execute Battle Action: Land
  #--------------------------------------------------------------------------
  def execute_action_land
    @active_battler.stamina_wait = true
    @active_battler.empty_stamina
    execute_basic_action(nil)
    @active_battler.hidden = false
  end
  
  #--------------------------------------------------------------------------
  # * 
  #     obj : 
  #--------------------------------------------------------------------------
  alias determine_custom_battler_animation_bc_jump determine_custom_battler_animation unless $@
  def determine_custom_battler_animation(battler, obj)
    if battler.action.jump?
      return CustomAnim.new(nil, BATTLESYSTEM_CONFIG::MOVE_TARGET_INSTANT)
    else
      return determine_custom_battler_animation_bc_jump(battler, obj)
    end
  end
#~   
#~   #--------------------------------------------------------------------------
#~   # * 
#~   #     obj : 
#~   #--------------------------------------------------------------------------
#~   def determine_custom_action_times(battler, obj)
#~     return 1
#~   end
  
  #--------------------------------------------------------------------------
  # * 
  #     obj : 
  #--------------------------------------------------------------------------
  alias do_custom_animation_bc_jump do_custom_animation unless $@
  def do_custom_animation(battler, obj)
    if battler.action.jump?
      battler.battle_animation.do_ani_land
    else
      do_custom_animation_bc_jump(battler, obj)
    end
  end

  #--------------------------------------------------------------------------
  # * 
  #     obj : 
  #--------------------------------------------------------------------------
  alias do_custom_target_effect_bc_jump do_custom_target_effect unless $@
  def do_custom_target_effect(battler, target, obj)
    if battler.action.jump?
      temp = battler.clone
      temp.atk += (temp.atk * (BATTLECOMMANDS_CONFIG::BC_JUMP_BONUS_DMG_RATE / 100.0))
      target.attack_effect(temp)
    else
      do_custom_target_effect_bc_jump(battler, target, obj)
    end
  end
  
  #--------------------------------------------------------------------------
  # * 
  #     obj : 
  #--------------------------------------------------------------------------
  alias display_custom_animation_bc_jump display_custom_animation unless $@
  def display_custom_animation(battler, targets)
    if battler.action.jump?
      display_attack_animation(targets, false)
    else
      display_custom_animation_bc_jump(battler, targets)
    end
  end
  
end
