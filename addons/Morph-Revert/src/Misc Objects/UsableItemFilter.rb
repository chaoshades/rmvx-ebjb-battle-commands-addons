#==============================================================================
# ** UsableItemFilter
#------------------------------------------------------------------------------
#  Represents a UsableItem filter
#==============================================================================

class UsableItemFilter < Filter
  include EBJB
  
  #//////////////////////////////////////////////////////////////////////////
  # * Public Methods
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Alias apply
  #--------------------------------------------------------------------------
  alias apply_bc_morph apply unless $@
  def apply(x)
    if x != nil && x.is_a?(RPG::UsableItem)
       
      case mode
        when "morph"
          return applyMorph(x)
        #when
          #...
        else
          return apply_bc_morph(x)
      end
      
    else
      return nil
    end
  end
  
  #//////////////////////////////////////////////////////////////////////////
  # * Private Methods
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Apply method (using the id property)
  #     x : object to filter
  #--------------------------------------------------------------------------
  def applyMorph(x)
    if BATTLECOMMANDS_CONFIG::BC_MORPH_COMMANDS.collect{|y| y.skill_id}.include?(x.id)
      return true
    else
      return false
    end
  end
  private:applyMorph
  
end
