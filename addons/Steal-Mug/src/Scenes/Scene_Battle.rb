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
  alias execute_battle_commands_bc_steal execute_battle_commands unless $@
  def execute_battle_commands(actor)
    command = @actor_command_window.selected_command
    if command.type == BATTLECOMMANDS_CONFIG::BC_STEAL
      Sound.play_decision
      actor.action.set_steal
      start_target_enemy_selection
    elsif command.type == BATTLECOMMANDS_CONFIG::BC_MUG
      Sound.play_decision
      actor.action.set_mug
      start_target_enemy_selection
    else
      execute_battle_commands_bc_steal(actor)
    end
  end
  
  #--------------------------------------------------------------------------
  # * Alias execute_action
  #--------------------------------------------------------------------------
  alias execute_action_bc_steal execute_action unless $@
  def execute_action
    if @active_battler.action.steal? || @active_battler.action.mug? 
      execute_action_steal
      @active_battler.action.clear
    else
      execute_action_bc_steal
    end
  end
  
  #--------------------------------------------------------------------------
  # * Execute Battle Action: Steal
  #--------------------------------------------------------------------------
  def execute_action_steal
    @top_help_window.set_text(@active_battler.action.determine_action_name)
    @top_help_window.visible = true
    @active_battler.stamina_wait = true
    @active_battler.empty_stamina
    execute_basic_action(nil)
    @top_help_window.visible = false
  end
  
  #--------------------------------------------------------------------------
  # * 
  #     obj : 
  #--------------------------------------------------------------------------
  alias determine_custom_battler_animation_bc_steal determine_custom_battler_animation unless $@
  def determine_custom_battler_animation(battler, obj)
    if battler.action.steal? || @active_battler.action.mug? 
      return CustomAnim.new(nil, BATTLESYSTEM_CONFIG::MOVE_TARGET)
    else
      return determine_custom_battler_animation_bc_steal(battler, obj)
    end
  end
  
  #--------------------------------------------------------------------------
  # * 
  #     obj : 
  #--------------------------------------------------------------------------
  alias do_custom_animation_bc_steal do_custom_animation unless $@
  def do_custom_animation(battler, obj)
    if battler.action.steal?
      battler.battle_animation.do_ani_steal
    elsif battler.action.mug?
      battler.battle_animation.do_ani_mug
    else
      do_custom_animation_bc_steal(battler, obj)
    end
  end

  #--------------------------------------------------------------------------
  # * 
  #     obj : 
  #--------------------------------------------------------------------------
  alias do_custom_target_effect_bc_steal do_custom_target_effect unless $@
  def do_custom_target_effect(battler, target, obj)
    if battler.action.steal?
      do_steal_target_effect(battler, target)
    elsif battler.action.mug?
      do_steal_target_effect(battler, target)
      target.attack_effect(battler)
    else
      do_custom_target_effect_bc_steal(battler, target, obj)
    end
  end
  
  #--------------------------------------------------------------------------
  # * 
  #     obj : 
  #--------------------------------------------------------------------------
  def do_steal_target_effect(battler, target)
    steal_items = target.steal_items
    if steal_items == nil || steal_items.length == 0
      @top_help_window.set_text(Vocab::no_steal_text)
    else
      # Determine steal ratio with bonus
      ratio = 1
      if BATTLECOMMANDS_CONFIG::BC_STEAL_AGILITY_BASED
        ratio = [target.agi, 1].max / [battler.agi, 1].max.to_f
      end
      ratio -= battler.total_steal_rate_bonus.to_f / 100

      # Takes randomly one item in the list
      index = rand(steal_items.length)

      # Determines if the item is successfully stolen
      stolen_item = nil
      denom = (steal_items[index].denominator * ratio).ceil
      if denom <= 1 || rand(denom) == 0
        stolen_item = steal_items[index]
      end
      
      if stolen_item == nil
        @top_help_window.set_text(Vocab::failed_steal_text)
      else
        $game_party.gain_item(stolen_item.item, 1)
        if (BATTLECOMMANDS_CONFIG::BC_STEAL_ONLY_ONCE)
          target.steal_items.clear
        else
          target.steal_items.delete(stolen_item)
        end
        message = sprintf(Vocab::success_steal_text, stolen_item.item.name)
        @top_help_window.set_text(message)
      end
    end
  end
  
  #--------------------------------------------------------------------------
  # * 
  #     obj : 
  #--------------------------------------------------------------------------
  alias display_custom_animation_bc_steal display_custom_animation unless $@
  def display_custom_animation(battler, targets)
    if battler.action.mug?
      display_attack_animation(targets, false)
    else
      display_custom_animation_bc_steal(battler, targets)
    end
  end
  
end
