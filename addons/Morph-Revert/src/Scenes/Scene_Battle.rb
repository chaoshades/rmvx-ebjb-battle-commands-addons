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
  alias start_bc_morph start unless $@
  def start
    start_bc_morph
    
    @morph = false
    @orig_actors = $game_party.members.collect{|x| x.id}
  end
  
  #--------------------------------------------------------------------------
  # * Alias execute_battle_commands
  #--------------------------------------------------------------------------
  alias execute_battle_commands_bc_morph execute_battle_commands unless $@
  def execute_battle_commands(actor)
    command = @actor_command_window.selected_command
    if command.type == BATTLECOMMANDS_CONFIG::BC_MORPH
      if command.is_a?(List_Command)
        Sound.play_decision
        @skill_window.filter = command.filter
        @morph = true
        start_skill_selection(actor)  
      elsif command.is_a?(Morph_Command)
        Sound.play_decision
        @morph = true
        determine_skill(command.skill)
      end
    elsif command.type == BATTLECOMMANDS_CONFIG::BC_REVERT
      Sound.play_decision
      actor.action.set_revert
      add_to_battleline(actor)
      end_actor_command_selection()
    else
      execute_battle_commands_bc_morph(actor)
    end
  end
  
  #--------------------------------------------------------------------------
  # * Confirm Skill
  #     skill : Skill object
  #--------------------------------------------------------------------------
  def determine_skill(skill)   
    if @morph
      if !skill.partners.empty?
        for actor_id in skill.partners
          $game_actors[actor_id].action.set_morph(skill.id)
        end
      else
        $game_party.members[@actor_index].action.set_morph(skill.id)
      end
    else
      if !skill.partners.empty?
        for actor_id in skill.partners
          $game_actors[actor_id].action.set_skill(skill.id)
        end
      else
        $game_party.members[@actor_index].action.set_skill(skill.id)
      end
    end
    
    @skill_window.active = false
    if skill.need_selection?
      if skill.for_opponent?
        start_target_enemy_selection
      else
        start_target_actor_selection
      end
    else
      confirm_no_selection_skill(skill)
    end
  end
  
  #--------------------------------------------------------------------------
  # * Alias execute_action
  #--------------------------------------------------------------------------
  alias execute_action_bc_morph execute_action unless $@
  def execute_action
    if @active_battler.action.morph?
      @morph = false
      execute_action_morph
      @active_battler.action.clear
    elsif @active_battler.action.revert?
      execute_action_revert
      @active_battler.action.clear
    else
      execute_action_bc_morph
    end
  end
  
  #--------------------------------------------------------------------------
  # * Execute Battle Action: Morph
  #--------------------------------------------------------------------------
  def execute_action_morph
    @top_help_window.set_text(@active_battler.action.skill.name)
    @top_help_window.visible = true
    @active_battler.stamina_wait = true
    @active_battler.empty_stamina
    execute_basic_action(nil)
    @top_help_window.visible = false
  end
  
  #--------------------------------------------------------------------------
  # * Execute Battle Action: Revert
  #--------------------------------------------------------------------------
  def execute_action_revert
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
  alias determine_custom_battler_animation_bc_morph determine_custom_battler_animation unless $@
  def determine_custom_battler_animation(battler, obj)
    if battler.action.morph?
      return battler.battle_animation.ani_skills[battler.action.skill_id]
    else
      return determine_custom_battler_animation_bc_morph(battler, obj)
    end
  end
  
  #--------------------------------------------------------------------------
  # * 
  #     obj : 
  #--------------------------------------------------------------------------
  alias do_custom_animation_bc_morph do_custom_animation unless $@
  def do_custom_animation(battler, obj)
    if battler.action.morph?
      battler.battle_animation.do_ani_skill(battler.action.skill_id)
    else
      do_custom_animation_bc_morph(battler, obj)
    end
  end
   
  #--------------------------------------------------------------------------
  # * Update actors objects when one change
  #--------------------------------------------------------------------------
  def update_actor_change
    if @last_actors != $game_party.members
      for actor in $game_party.members - @last_actors
        set_actor_position(actor)
        actor.empty_state_removal_time
        actor.empty_stamina
        if actor.dead?
          actor.battle_animation.ani_start_at_end=true
          actor.battle_animation.do_ani_dead
        else
          actor.battle_animation.do_ani_stand
        end
      end
      @last_actors = $game_party.members
      @status_window.window_update($game_party.members)
    end
  end

  #--------------------------------------------------------------------------
  # * 
  #     obj : 
  #--------------------------------------------------------------------------
  alias do_custom_target_effect_bc_morph do_custom_target_effect unless $@
  def do_custom_target_effect(battler, target, obj)
    if battler.action.morph?
      target.skill_effect(battler, battler.action.skill)
    else
      do_custom_target_effect_bc_morph(battler, target, obj)
    end
  end
  
  #--------------------------------------------------------------------------
  # * 
  #     obj : 
  #--------------------------------------------------------------------------
  alias display_custom_animation_bc_morph display_custom_animation unless $@
  def display_custom_animation(battler, targets)
    if battler.action.morph?
      display_animation(targets, battler.action.skill.animation_id, true)
      
      morph_command = BATTLECOMMANDS_CONFIG::BC_MORPH_COMMANDS.select{|x| x.skill_id == battler.action.skill.id}.first
      for t in targets
        index = t.index
        $game_party.members[index].hidden = true
        current_level = $game_party.members[index].level
        $game_party.replace_actor(morph_command.morph_actor_id, index)
        # Set same level to the morphed actor
        $game_party.members[index].change_level(current_level, false)
        update_actor_change()
        @spriteset.create_actor($game_party.members[index], index)
        $game_party.members[index].hidden = false
      end
    elsif battler.action.revert?
      morph_command = BATTLECOMMANDS_CONFIG::BC_MORPH_COMMANDS.select{|x| x.morph_actor_id == battler.id}.first
      display_animation([battler], morph_command.skill.animation_id, true)

      index = battler.index
      $game_party.members[index].hidden = true
      $game_party.replace_actor(@orig_actors[index], index)
      update_actor_change()
      @spriteset.create_actor($game_party.members[index], index)
      $game_party.members[index].hidden = false
    else
      display_custom_animation_bc_morph(battler, targets)
    end
  end

  #--------------------------------------------------------------------------
  # * Victory Processing
  #--------------------------------------------------------------------------
  alias process_victory_bc_morph process_victory unless $@
  def process_victory
    actor_ids = $game_party.members.collect{|x| x.id}
    if @orig_actors != actor_ids
      for i in 0..@orig_actors.size-1
        if @orig_actors[i] != actor_ids[i]
          morph_command = BATTLECOMMANDS_CONFIG::BC_MORPH_COMMANDS.select{|x| x.morph_actor_id == actor_ids[i]}.first
          display_animation([$game_party.members[i]], morph_command.skill.animation_id, true)

          $game_party.members[i].hidden = true
          $game_party.replace_actor(@orig_actors[i], i)
          update_actor_change()
          @spriteset.create_actor($game_party.members[i], i)
          $game_party.members[i].hidden = false
        end
      end
    end
    process_victory_bc_morph()
  end
  
  #--------------------------------------------------------------------------
  # * End Battle
  #     result : Results (0: win, 1: escape, 2:lose)
  #--------------------------------------------------------------------------
  alias battle_end_bc_morph battle_end unless $@
  def battle_end(result)
    if result != 0
      actor_ids = $game_party.members.collect{|x| x.id}
      if @orig_actors != actor_ids
        for i in 0..@orig_actors.size-1
          if @orig_actors[i] != actor_ids[i]
            $game_party.replace_actor(@orig_actors[i], i)
          end
        end
      end
    end
    battle_end_bc_morph(result)
  end
  
end
