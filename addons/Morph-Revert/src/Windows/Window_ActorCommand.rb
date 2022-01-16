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
  alias update_detail_bc_morph update_detail unless $@
  def update_detail
    update_detail_bc_morph()
    
    if selected_command != nil
      if selected_command.is_a?(Morph_Command)
        @detail_window.window_update(selected_command.skill)
      else
        update_detail_bc_morph()
      end
    else
      update_detail_bc_morph()
    end
  end
  
  #--------------------------------------------------------------------------
  # * Alias is_switchable
  #--------------------------------------------------------------------------
  alias is_switchable_bc_morph is_switchable unless $@
  def is_switchable
    return is_switchable_bc_morph() ||
           (selected_command != nil && 
           (selected_command.is_a?(Morph_Command) && detail_window.is_a?(Window_SkillDetails)))
  end
  
  #//////////////////////////////////////////////////////////////////////////
  # * Private Methods
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Alias create_item
  #--------------------------------------------------------------------------
  alias create_item_bc_morph create_item unless $@
  def create_item(index)
    command = @commands[index]
    rect = item_rect(index, true)
    
    if command.is_a?(Morph_Command)
      control = UCSkill.new(self, command.skill, rect, @actor.calc_mp_cost(command.skill))
    else
      control = create_item_bc_morph(index)
    end

    return control
  end
  private :create_item
  
end
