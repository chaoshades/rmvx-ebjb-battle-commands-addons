#===============================================================================
# ** RPG::Area Addon
#------------------------------------------------------------------------------
#  Addon functions 
#===============================================================================

class RPG::Area
  include EBJB
  
  #//////////////////////////////////////////////////////////////////////////
  # * Properties
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Get 
  #--------------------------------------------------------------------------
  # GET
  def terrain
    return BATTLECOMMANDS_CONFIG::BC_NATURE_TERRAIN_AREAS[self.id]
  end
  
end
