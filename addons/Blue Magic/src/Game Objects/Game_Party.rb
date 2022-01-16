#==============================================================================
# ** Game_Party
#------------------------------------------------------------------------------
#  This class handles the party. It includes information on amount of gold 
# and items. The instance of this class is referenced by $game_party.
#==============================================================================

class Game_Party < Game_Unit
  
  #//////////////////////////////////////////////////////////////////////////
  # * Constructors
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  alias initialize_bc_bluemagic initialize unless $@
  def initialize
    initialize_bc_bluemagic
    @blue_magic_skills = []
  end
  
  #//////////////////////////////////////////////////////////////////////////
  # * Public Methods
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Get Blue Magic Skill Object Array
  #--------------------------------------------------------------------------
  def blue_magic_skills
    result = []
    for i in @blue_magic_skills
      result.push($data_skills[i])
    end
    return result
  end
  
  #--------------------------------------------------------------------------
  # * Learn Blue Magic Skill
  #     skill_id : skill ID
  #--------------------------------------------------------------------------
  def learn_blue_magic(skill_id)
    unless blue_magic_learn?($data_skills[skill_id])
      @blue_magic_skills.push(skill_id)
      @blue_magic_skills.sort!
    end
  end
  
  #--------------------------------------------------------------------------
  # * Forget Blue Magic Skill
  #     skill_id : skill ID
  #--------------------------------------------------------------------------
  def forget_blue_magic(skill_id)
    @blue_magic_skills.delete(skill_id)
  end
  
  #--------------------------------------------------------------------------
  # * Determine if Finished Learning Blue Magic Skill
  #     skill : skill
  #--------------------------------------------------------------------------
  def blue_magic_learn?(skill)
    return @blue_magic_skills.include?(skill.id)
  end
  
end
