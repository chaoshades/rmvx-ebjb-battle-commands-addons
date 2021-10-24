#==============================================================================
# ** WeaponFilter
#------------------------------------------------------------------------------
#  Represents a Weapon filter
#==============================================================================

class WeaponFilter < Filter
  include EBJB
  
  #//////////////////////////////////////////////////////////////////////////
  # * Public Methods
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Alias apply
  #--------------------------------------------------------------------------
  alias apply_bc_throw apply unless $@  
  def apply(x)
    if x != nil && x.is_a?(RPG::Weapon)
       
      case mode
        when "throw"
          return applyThrow(x)
        #when
          #...
        else
          return apply_bc_throw(x)
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
  def applyThrow(x)
    if BATTLECOMMANDS_CONFIG::BC_THROW_ITEMS_ID.include?(x.id)
      return true
    else
      return false
    end
  end
  private:applyThrow
  
end
