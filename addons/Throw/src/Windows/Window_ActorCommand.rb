#==============================================================================
# ** Window_ActorCommand
#------------------------------------------------------------------------------
#  This window is used to select actor commands, such as "Attack" or "Skill".
#==============================================================================

class Window_ActorCommand < Window_Command
  include EBJB
  
  #//////////////////////////////////////////////////////////////////////////
  # * Public Methods
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Alias update_detail
  #--------------------------------------------------------------------------
  alias update_detail_bc_throw update_detail unless $@
  def update_detail
    update_detail_bc_throw()
    
    if selected_command != nil
      if selected_command.is_a?(Throw_Command)
        @detail_window.window_update(selected_command.item)
      else
        update_detail_bc_throw()
      end
    else
      update_detail_bc_throw()
    end
  end
  
  #--------------------------------------------------------------------------
  # * Alias is_switchable
  #--------------------------------------------------------------------------
  alias is_switchable_bc_throw is_switchable unless $@
  def is_switchable
    return is_switchable_bc_throw() ||
           (selected_command != nil && 
           (selected_command.is_a?(Throw_Command) && detail_window.is_a?(Window_EquipDetails)))
  end
  
  #//////////////////////////////////////////////////////////////////////////
  # * Private Methods
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Alias create_item
  #--------------------------------------------------------------------------
  alias create_item_bc_throw create_item unless $@
  def create_item(index)
    command = @commands[index]
    rect = item_rect(index, true)
    
    if command.is_a?(Throw_Command)
      control = UCItem.new(self, command.item, rect)
      control.active = $game_party.item_can_throw?(command.item)
    else
      control = create_item_bc_throw(index)
    end

    return control
  end
  private :create_item
  
end
