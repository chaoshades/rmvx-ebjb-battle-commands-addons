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
  alias start_bc_throw start unless $@
  def start
    start_bc_throw
    
    @throw_window = Window_BattleThrow.new(0, 480, 298, 176, nil)
    @throw_window.active = false
    @throw_window.help_window = @bot_help_window
    
    [@throw_window].each{
      |w| w.opacity = BATTLESYSTEM_CONFIG::WINDOW_OPACITY;
          w.back_opacity = BATTLESYSTEM_CONFIG::WINDOW_BACK_OPACITY
    }
  end
  
  #--------------------------------------------------------------------------
  # * Alias terminate
  #--------------------------------------------------------------------------
  alias terminate_bc_throw terminate unless $@
  def terminate
    terminate_bc_throw
    
    @throw_window.dispose if @throw_window != nil
  end
  
  #--------------------------------------------------------------------------
  # * Alias update_basic
  #--------------------------------------------------------------------------
  alias update_basic_bc_throw update_basic unless $@
  def update_basic(main = false)
    update_basic_bc_throw(main)

    @throw_window.update
  end
  
  #--------------------------------------------------------------------------
  # * Alias update_window_movement
  #--------------------------------------------------------------------------
  alias update_window_movement_bc_throw update_window_movement unless $@
  def update_window_movement()
    update_window_movement_bc_throw
    
    # Throw window position
    if @throw_window.active
      @throw_window.visible = true
      if @throw_window.y > 288+16
        @throw_window.y -= 16
      end
    else
      if @throw_window.y < 480
        @throw_window.y += 16
      else
        @throw_window.visible = false
      end
    end
  end
  
  #--------------------------------------------------------------------------
  # * Alias custom_actor_command_active?
  #--------------------------------------------------------------------------
  alias custom_actor_command_active_bc_throw? custom_actor_command_active? unless $@
  def custom_actor_command_active?
    if @throw_window.active
      return true
    else 
      return custom_actor_command_active_bc_throw?
    end
  end
  
  #--------------------------------------------------------------------------
  # * Alias update_custom_actor_command_input 
  #--------------------------------------------------------------------------
  alias update_custom_actor_command_input_bc_throw update_custom_actor_command_input unless $@
  def update_custom_actor_command_input
    if @throw_window.active
      update_throw_selection    # Select throwable weapon
    else
      update_custom_actor_command_input_bc_throw
    end
  end
  
  #--------------------------------------------------------------------------
  # * Alias execute_battle_commands
  #--------------------------------------------------------------------------
  alias execute_battle_commands_bc_throw execute_battle_commands unless $@
  def execute_battle_commands(actor)
    command = @actor_command_window.selected_command
    if command.type == BATTLECOMMANDS_CONFIG::BC_THROW
      if command.is_a?(List_Command)
        Sound.play_decision
        #@throw_window.filter = command.filter
        start_throw_selection
      elsif command.is_a?(Throw_Command)
        Sound.play_decision
        @actor_command_window.active = false
        determine_throw(command.item)
      end
    else
      execute_battle_commands_bc_throw(actor)
    end
  end
  
  #--------------------------------------------------------------------------
  # * Alias execute_action
  #--------------------------------------------------------------------------
  alias execute_action_bc_throw execute_action unless $@
  def execute_action
    if @active_battler.action.throw?
      execute_action_throw
      @active_battler.action.clear
    else
      execute_action_bc_throw
    end
  end
  
  #--------------------------------------------------------------------------
  # * Execute Battle Action: Throw
  #--------------------------------------------------------------------------
  def execute_action_throw
    weapon = @active_battler.action.throw_weapon
    @top_help_window.set_text(@active_battler.action.determine_action_name)
    @top_help_window.visible = true
    $game_party.lose_item(weapon, 1)
    @active_battler.stamina_wait = true
    @active_battler.empty_stamina
    execute_basic_action(nil)
    @top_help_window.visible = false
  end
  
  #--------------------------------------------------------------------------
  # * 
  #     obj : 
  #--------------------------------------------------------------------------
  alias determine_custom_battler_animation_bc_throw determine_custom_battler_animation unless $@
  def determine_custom_battler_animation(battler, obj)
    if battler.action.throw?
      return battler.battle_animation.ani_throw_weapons[battler.action.weapon_id]
      #return CustomAnim.new(nil, BATTLESYSTEM_CONFIG::MOVE_STEPS)
    else
      return determine_custom_battler_animation_bc_throw(battler, obj)
    end
  end

  #--------------------------------------------------------------------------
  # * 
  #     obj : 
  #--------------------------------------------------------------------------
  alias do_custom_target_effect_bc_throw do_custom_target_effect unless $@
  def do_custom_target_effect(battler, target, obj)
    if battler.action.throw?
      temp = battler.clone
      temp.atk = (battler.action.throw_weapon.atk * (BATTLECOMMANDS_CONFIG::BC_THROW_BONUS_DMG_RATE / 100.0))
      target.attack_effect(temp)
    else
      do_custom_target_effect_bc_throw(battler, target, obj)
    end
  end
  
  #--------------------------------------------------------------------------
  # * 
  #     obj : 
  #--------------------------------------------------------------------------
  alias do_custom_animation_bc_throw do_custom_animation unless $@
  def do_custom_animation(battler, obj)
    if battler.action.throw?
      battler.battle_animation.do_ani_throw(battler.action.weapon_id)
    else
      do_custom_animation_bc_throw(battler, obj)
    end
  end
  
  #--------------------------------------------------------------------------
  # * 
  #     obj : 
  #--------------------------------------------------------------------------
  alias display_custom_animation_bc_throw display_custom_animation unless $@
  def display_custom_animation(battler, targets)
    if battler.action.throw?
      display_animation(targets, battler.action.throw_weapon.animation_id, false)
    else
      display_custom_animation_bc_throw(battler, targets)
    end
  end
  
  #--------------------------------------------------------------------------
  # * Confirm Throw
  #     weapon : weapon object
  #--------------------------------------------------------------------------
  def determine_throw(weapon)
    actor = $game_party.members[@actor_index]
    actor.action.set_throw(weapon.id)
    @throw_window.active = false
    start_target_enemy_selection
  end
  
  #//////////////////////////////////////////////////////////////////////////
  # * Scene Commands
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Update Throw Selection
  #--------------------------------------------------------------------------
  def update_throw_selection   
    actor = $game_party.members[@actor_index]
    if (not actor.ready_for_action?) and (not actor.inputable?)
      end_throw_selection()
      return
    end
    
    @throw_window.call_update_help()

    if Input.trigger?(Input::B)
      Sound.play_cancel
      end_throw_selection
    elsif Input.trigger?(Input::C)
      weapon = @throw_window.selected_weapon
      if weapon != nil
        Sound.play_decision
        @targeting_window = @throw_window
        determine_throw(weapon)
      else
        Sound.play_buzzer
      end
    end
  end
  
  #--------------------------------------------------------------------------
  # * Start Throw Selection
  #--------------------------------------------------------------------------
  def start_throw_selection
    @throw_window.index = 0
    @throw_window.window_update($game_party.items)
    @throw_window.active = true
    @throw_window.call_update_help()
    @actor_command_window.active = false
    deactivate_stamina(0)
  end
 
  #--------------------------------------------------------------------------
  # * End Throw Selection
  #--------------------------------------------------------------------------
  def end_throw_selection
    @throw_window.active = false
    @actor_command_window.active = true
    activate_stamina(0)
  end
  
end
