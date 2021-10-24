#==============================================================================
# ** Game_BattleAnimation
#------------------------------------------------------------------------------
#  This class deals with the battles animations in battle. It is referenced by
# the Game_Battler and Game_Projectile classes.
#==============================================================================

class Game_BattleAnimation
  include EBJB
  
  #//////////////////////////////////////////////////////////////////////////
  # * Attributes
  #//////////////////////////////////////////////////////////////////////////

  # Array of Weapon Animations definitions
  attr_accessor :ani_throw_weapons
  
  #//////////////////////////////////////////////////////////////////////////
  # * Properties
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Checks if animation action is Throwing
  #--------------------------------------------------------------------------
  def is_throwing?
    return @animation_action == BATTLESYSTEM_CONFIG::BA_THROW
  end
  
  #//////////////////////////////////////////////////////////////////////////
  # * Constructors
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Alias initialize
  #--------------------------------------------------------------------------
  alias initialize_bc_throw initialize unless $@
  def initialize
    initialize_bc_throw
  
    @ani_throw_weapons = nil
  end
  
  #//////////////////////////////////////////////////////////////////////////
  # * Public Methods
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Do Throw animation
  #--------------------------------------------------------------------------
  def do_ani_throw(weapon_id=0)
    @animation_loop = false
    set_action_ani(BATTLESYSTEM_CONFIG::BA_THROW, weapon_id)
  end
  
  #--------------------------------------------------------------------------
  # * Alias do_next_battle_animation
  #--------------------------------------------------------------------------
  alias do_next_battle_animation_bc_throw do_next_battle_animation unless $@
  def do_next_battle_animation
    do_next_battle_animation_bc_throw
        
    case @animation_action
    when BATTLESYSTEM_CONFIG::BA_THROW
      do_ani_stand
    end
  end
  
  #--------------------------------------------------------------------------
  # * Sets animation action and animation id (can vary depending of the obj_id) 
  #   for this action
  #     action : battle action
  #     obj_id : weapon/skill/item ID
  #--------------------------------------------------------------------------
  def set_action_ani(action, obj_id=0)
    @animation_action = action
    #if not self.is_a?(Game_Enemy)
      if obj_id > 0
        case action
        when BATTLESYSTEM_CONFIG::BA_ATTACK
          if @ani_weapons[obj_id] != nil
            anim_id = @ani_weapons[obj_id].animation_id
          end
        when BATTLESYSTEM_CONFIG::BA_SKILL
          if @ani_skills[obj_id] != nil
            anim_id = @ani_skills[obj_id].animation_id
          end
        when BATTLESYSTEM_CONFIG::BA_ITEM
          if @ani_items[obj_id] != nil
            anim_id = @ani_items[obj_id].animation_id
          end
        when BATTLESYSTEM_CONFIG::BA_THROW
          if @ani_throw_weapons[obj_id] != nil
            anim_id = @ani_throw_weapons[obj_id].animation_id
          end
        end

        # If no animation id was found, use default action
        if anim_id == nil
          anim_id = @ani_actions[action]
        end
      else
        anim_id = @ani_actions[action]
      end
    #end
    if anim_id != nil
      @animation_id = anim_id
    end
  end
  
end