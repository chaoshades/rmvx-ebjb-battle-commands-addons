#==============================================================================
# ** Scene_BattleCommands
#------------------------------------------------------------------------------
#  This class performs the battle commands change screen processing.
#===============================================================================

class Scene_BattleCommands < Scene_Base
  include EBJB
    
  #//////////////////////////////////////////////////////////////////////////
  # * Public Methods
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Alias start
  #--------------------------------------------------------------------------
  alias start_bc_morph start unless $@
  def start
    start_bc_morph()
    
    @morph_command_window = Window_Skill_Command.new(640, 208, 440, 176)
    @morph_command_window.active = false
    @morph_command_window.visible = false
    @morph_command_window.index = -1
    
    @morph_command_window.help_window = @help_window

    @morph_details_window = Window_SkillDetails.new(0,384,640,96,nil)
    @morph_details_window.visible = false
    @morph_command_window.detail_window = @morph_details_window
    
    [@morph_command_window, @morph_details_window].each{
      |w| w.opacity = BATTLESYSTEM_CONFIG::WINDOW_OPACITY;
          w.back_opacity = BATTLESYSTEM_CONFIG::WINDOW_BACK_OPACITY
    }
  end
  
  #--------------------------------------------------------------------------
  # * Alias terminate
  #--------------------------------------------------------------------------
  alias terminate_bc_morph terminate unless $@
  def terminate
    terminate_bc_morph()
    
    @morph_command_window.dispose if @morph_command_window != nil
    @morph_details_window.dispose if @morph_details_window != nil
  end
  
  #--------------------------------------------------------------------------
  # * Alias update
  #--------------------------------------------------------------------------
  alias update_bc_morph update unless $@
  def update
    update_bc_morph()
    
    @morph_command_window.update
    @morph_details_window.update
    if @morph_command_window.active
      update_morph_command_selection
    end
  end
  
  #--------------------------------------------------------------------------
  # * Alias update_window_movement
  #--------------------------------------------------------------------------
  alias update_window_movement_bc_morph update_window_movement unless $@
  def update_window_movement()
    update_window_movement_bc_morph()
    
    # Battle command window position
    if @morph_command_window.active
      if @battle_commands_window.x > 0
        @battle_commands_window.x -= 20
      end
    end
    
    # Morph window position
    if @morph_command_window.active
      @morph_command_window.visible = true
      if @morph_command_window.x > 200
        @morph_command_window.x -= 40
      end
    else
      if @morph_command_window.x < 640
        @morph_command_window.x += 40
      else
        @morph_command_window.visible = false
      end
    end
    
  end
  
  #//////////////////////////////////////////////////////////////////////////
  # * Private Methods
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Alias update_detail_window
  #-------------------------------------------------------------------------- 
  alias update_detail_window_bc_morph update_detail_window unless $@
  def update_detail_window(command)    
    if command.is_a?(Morph_Command)
      @actor_commands_window.detail_window = @morph_details_window
    else
      update_detail_window_bc_morph(command)
    end
  end
  private :update_detail_window
  
  #//////////////////////////////////////////////////////////////////////////
  # * Scene input management methods
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Alias update_battle_command_selection
  #--------------------------------------------------------------------------
  alias update_battle_command_selection_bc_morph update_battle_command_selection unless $@
  def update_battle_command_selection()
    update_battle_command_selection_bc_morph()
    
    if Input.trigger?(Input::RIGHT)
      if @battle_commands_window.selected_battle_command.is_a?(List_Command)
        if @battle_commands_window.selected_battle_command.type == BATTLECOMMANDS_CONFIG::BC_MORPH
          morph_command()
        end
      end
    end    
  end
  private :update_battle_command_selection

  #--------------------------------------------------------------------------
  # * Update Morph Command Selection
  #--------------------------------------------------------------------------
  def update_morph_command_selection()
    if Input.trigger?(Input::B)
      Sound.play_cancel
      cancel_morph_command()
      
    elsif Input.trigger?(Input::C)
      if @morph_command_window.selected_skill == nil ||
         (!@autobattle_window.active && !@morph_command_window.enable?(@morph_command_window.selected_skill))
        Sound.play_buzzer
      else
        Sound.play_decision
        command = BATTLECOMMANDS_CONFIG::BC_MORPH_COMMANDS.select{|x| x.skill_id == @morph_command_window.selected_skill.id}.first
        $game_battle_commands.add_morph_command(command)
        change_battle_command(command)
      end
    end
  end
  private :update_morph_command_selection
  
  #//////////////////////////////////////////////////////////////////////////
  # * Scene Commands
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Change battle command
  #     command : New battle command
  #--------------------------------------------------------------------------
  alias change_battle_command_bc_morph change_battle_command unless $@
  def change_battle_command(command)
    change_battle_command_bc_morph(command)
    
    if @morph_command_window.active
      @morph_command_window.window_update(@actor, @battle_commands_window.selected_battle_command.filter)
    end
  end
  private :change_battle_command
  
  #--------------------------------------------------------------------------
  # * Morph command
  #--------------------------------------------------------------------------
  def morph_command()
    @battle_commands_window.active = false
    @morph_command_window.window_update(@actor, @battle_commands_window.selected_battle_command.filter)
    @morph_command_window.active = true
    @morph_command_window.index = 0
  end
  private :morph_command
  
  #--------------------------------------------------------------------------
  # * Cancel Morph command
  #--------------------------------------------------------------------------
  def cancel_morph_command()
    @battle_commands_window.active = true
    @morph_command_window.active = false
    @morph_command_window.index = -1
    @battle_commands_window.call_update_help()
    @morph_details_window.window_update(nil)
    @morph_details_window.visible = false
  end
  private :cancel_morph_command
  
end
