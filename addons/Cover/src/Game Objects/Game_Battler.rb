#==============================================================================
# ** Game_Battler
#------------------------------------------------------------------------------
#  This class deals with battlers. It's used as a superclass of the Game_Actor
# and Game_Enemy classes.
#==============================================================================

class Game_Battler
  
  #//////////////////////////////////////////////////////////////////////////
  # * Attributes
  #//////////////////////////////////////////////////////////////////////////
  
  # 
  attr_accessor :protecting
  # Keeps reference to the protector
  attr_accessor :protector
  
  #//////////////////////////////////////////////////////////////////////////
  # * Properties
  #//////////////////////////////////////////////////////////////////////////
  
  def protected?
    return !@protector.nil?
  end
  
  #//////////////////////////////////////////////////////////////////////////
  # * Constructor
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Alias initialize
  #--------------------------------------------------------------------------
  alias initialize_bc_cover initialize unless $@
  def initialize
    @protector = nil
    @protecting = false
    initialize_bc_cover
  end
  
  #//////////////////////////////////////////////////////////////////////////
  # * Public Methods
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Alias make_attack_damage_value
  #--------------------------------------------------------------------------
  alias make_attack_damage_value_bc_cover make_attack_damage_value unless $@
  def make_attack_damage_value(attacker, effect = nil)
    make_attack_damage_value_bc_cover(attacker)
    if protected? && (!@protector.movable? || !@protector.exist?)
      @protector = nil
    end
    
    if protected? && BATTLECOMMANDS_CONFIG::PROTECT_PHYSICAL && 
       !$game_party.members.include?(attacker)
      @hp_damage *= ((100 - BATTLECOMMANDS_CONFIG::DAMAGE_EFFECT) / 100)
      @protector.protecting = true
      @protector.attack_effect(attacker)
    end
    if @protecting
      @hp_damage *= (BATTLECOMMANDS_CONFIG::DAMAGE_EFFECT / 100)
      @protecting = false
    end
  end
  
  #--------------------------------------------------------------------------
  # * Alias make_obj_damage_value
  #--------------------------------------------------------------------------
  alias make_obj_damage_value_bc_cover make_obj_damage_value unless $@
  def make_obj_damage_value(user, obj)
    make_obj_damage_value_bc_cover(user, obj)
    if protected? && (!@protector.movable? || !@protector.exist?)
      @protector = nil
    end
    
    if protected? && BATTLECOMMANDS_CONFIG::PROTECT_SKILLS && 
       !$game_party.members.include?(user)
      @hp_damage *= ((100 - BATTLECOMMANDS_CONFIG::DAMAGE_EFFECT) / 100)
      @mp_damage *= ((100 - BATTLECOMMANDS_CONFIG::DAMAGE_EFFECT) / 100)
      @protector.protecting = true
      @protector.skill_effect(user, obj)
    end
    if @protecting
      @hp_damage *= (BATTLECOMMANDS_CONFIG::DAMAGE_EFFECT / 100)
      @mp_damage *= (BATTLECOMMANDS_CONFIG::DAMAGE_EFFECT / 100)
      @protecting = false
    end
  end
  
end
