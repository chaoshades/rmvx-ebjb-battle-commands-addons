#==============================================================================
# ** Game_Battler
#------------------------------------------------------------------------------
#  This class deals with battlers. It's used as a superclass of the Game_Actor
# and Game_Enemy classes.
#==============================================================================

class Game_Battler

  #--------------------------------------------------------------------------
  # * Alias skill_effect
  #--------------------------------------------------------------------------
  alias skill_effect_bc_bluemagic skill_effect unless $@
  def skill_effect(user, skill)
    if BATTLECOMMANDS_CONFIG::BC_BLUE_MAGIC_SKILLS_ID.include?(skill.id)
      if BATTLECOMMANDS_CONFIG::BC_BLUE_MAGIC_LEARN_TYPE.include?(BATTLECOMMANDS_CONFIG::BM_TYPE_CAST)
        $game_party.learn_blue_magic(skill.id)
      end
      
      if BATTLECOMMANDS_CONFIG::BC_BLUE_MAGIC_LEARN_TYPE.include?(BATTLECOMMANDS_CONFIG::BM_TYPE_HIT)
        if self.actor? && !user.actor?
          $game_party.learn_blue_magic(skill.id)
        end     
      end
      
      if BATTLECOMMANDS_CONFIG::BC_BLUE_MAGIC_LEARN_TYPE.include?(BATTLECOMMANDS_CONFIG::BM_TYPE_ANALYZE)
        if !self.actor? && user.actor?
          enemy_skills = self.enemy.actions.collect{|x| $data_skills[x.skill_id] if x.skill?}
          enemy_skills.compact!
          for s in enemy_skills
            if BATTLECOMMANDS_CONFIG::BC_BLUE_MAGIC_SKILLS_ID.include?(s.id)
              $game_party.learn_blue_magic(s.id)
            end
          end
        end     
      end
    end
    
    skill_effect_bc_bluemagic(user, skill)
  end
  
end
