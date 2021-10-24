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
  alias start_bc_throw start unless $@
  def start
    start_bc_throw()
    
    @throw_command_window = Window_Throw_Command.new(640, 208, 440, 176)
    @throw_command_window.active = false
    @throw_command_window.visible = false
    @throw_command_window.index = -1
    
    @throw_command_window.help_window = @help_window
    
    @equip_details_window = Window_EquipDetails.new(0,384,640,96,nil)
    @equip_details_window.visible = false    
    @throw_command_window.detail_window = @equip_details_window
    
    [@throw_command_window, @equip_details_window].each{
      |w| w.opacity = BATTLESYSTEM_CONFIG::WINDOW_OPACITY;
          w.back_opacity = BATTLESYSTEM_CONFIG::WINDOW_BACK_OPACITY
    }
  end
  
  #--------------------------------------------------------------------------
  # * Alias terminate
  #--------------------------------------------------------------------------
  alias terminate_bc_throw terminate unless $@
  def terminate
    terminate_bc_throw()
    
    @throw_command_window.dispose if @throw_command_window != nil
    @equip_details_window.dispose if @equip_details_window != nil
  end
  
  #--------------------------------------------------------------------------
  # * Alias update
  #--------------------------------------------------------------------------
  alias update_bc_throw update unless $@
  def update
    update_bc_throw()
    
    @throw_command_window.update
    @equip_details_window.update
    if @throw_command_window.active
      update_throw_command_selection
    end
  end
  
  #--------------------------------------------------------------------------
  # * Alias update_window_movement
  #--------------------------------------------------------------------------
  alias update_window_movement_bc_throw update_window_movement unless $@
  def update_window_movement()
    update_window_movement_bc_throw()
    
    # Battle command window position
    if @throw_command_window.active
      if @battle_commands_window.x > 0
        @battle_commands_window.x -= 20
      end
    end
    
    # Throw window position
    if @throw_command_window.active
      @throw_command_window.visible = true
      if @throw_command_window.x > 200
        @throw_command_window.x -= 40
      end
    else
      if @throw_command_window.x < 640
        @throw_command_window.x += 40
      else
        @throw_command_window.visible = false
      end
    end
    
  end
  
  #//////////////////////////////////////////////////////////////////////////
  # * Private Methods
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Alias update_detail_window
  #-------------------------------------------------------------------------- 
  alias update_detail_window_bc_throw update_detail_window unless $@
  def update_detail_window(command)    
    if command.is_a?(Throw_Command)
      @actor_commands_window.detail_window = @equip_details_window
    else
      update_detail_window_bc_throw(command)
    end
  end
  private :update_detail_window
  
  #//////////////////////////////////////////////////////////////////////////
  # * Scene input management methods
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Alias update_battle_command_selection
  #--------------------------------------------------------------------------
  alias update_battle_command_selection_bc_throw update_battle_command_selection unless $@
  def update_battle_command_selection()
    update_battle_command_selection_bc_throw()
    
    if Input.trigger?(Input::RIGHT)
      if @battle_commands_window.selected_battle_command.is_a?(List_Command)
        if @battle_commands_window.selected_battle_command.type == BATTLECOMMANDS_CONFIG::BC_THROW
          throw_command()
        end
      end
    end    
  end
  private :update_battle_command_selection
  
  #--------------------------------------------------------------------------
  # * Update Throw Command Selection
  #--------------------------------------------------------------------------
  def update_throw_command_selection()
    if Input.trigger?(Input::B)
      Sound.play_cancel
      cancel_throw_command()
      
    elsif Input.trigger?(Input::C)
      if @throw_command_window.selected_item == nil ||
         (!@autobattle_window.active && !@throw_command_window.enable?(@throw_command_window.selected_item))
        Sound.play_buzzer
      else
        Sound.play_decision
        command = $game_battle_commands.add_throw_command(@throw_command_window.selected_item)
        change_battle_command(command)
      end
    end
  end
  private :update_throw_command_selection
  
  #//////////////////////////////////////////////////////////////////////////
  # * Scene Commands
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Change battle command
  #     command : New battle command
  #--------------------------------------------------------------------------
  alias change_battle_command_bc_throw change_battle_command unless $@
  def change_battle_command(command)
    change_battle_command_bc_throw(command)
    
    if @throw_command_window.active
      @throw_command_window.window_update(@actor, $game_party.items, @battle_commands_window.selected_battle_command.filter)
    end
  end
  private :change_battle_command
  
  #--------------------------------------------------------------------------
  # * Throw command
  #--------------------------------------------------------------------------
  def throw_command()
    @battle_commands_window.active = false
    @throw_command_window.window_update(@actor, $game_party.items, @battle_commands_window.selected_battle_command.filter)
    @throw_command_window.active = true
    @throw_command_window.index = 0
  end
  private :throw_command
  
  #--------------------------------------------------------------------------
  # * Cancel Throw command
  #--------------------------------------------------------------------------
  def cancel_throw_command()
    @battle_commands_window.active = true
    @throw_command_window.active = false
    @throw_command_window.index = -1
    @battle_commands_window.call_update_help()
    @equip_details_window.window_update(nil)
    @equip_details_window.visible = false
  end
  private :cancel_throw_command
  
end
