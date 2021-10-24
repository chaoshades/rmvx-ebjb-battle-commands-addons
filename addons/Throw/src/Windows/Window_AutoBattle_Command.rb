#===============================================================================
# ** Window_AutoBattle_Command
#------------------------------------------------------------------------------
#  This window displays 
#===============================================================================

class Window_AutoBattle_Command < Window_Base
  include EBJB
  
  #//////////////////////////////////////////////////////////////////////////
  # * Private Methods
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Alias create_item
  #--------------------------------------------------------------------------
  alias create_item_bc_throw create_item unless $@
  def create_item(command, actor, rect)   
    if command.is_a?(Throw_Command)
      control = UCItem.new(self, command.item, rect)
      control.active = $game_party.item_can_throw?(command.item)
      return control
    else
      return create_item_bc_throw(command, actor, rect)
    end
  end
  private :create_item
  
end
