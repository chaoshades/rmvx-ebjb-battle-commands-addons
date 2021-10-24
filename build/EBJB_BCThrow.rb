################################################################################
#                    EBJB Throw Command - EBJB_BCTHROW                #   VX   #
#                          Last Update: 2012/10/28                    ##########
#                          Author : ChaosHades                                 #
#     Source :                                                                 #
#     http://www.google.com                                                    #
#------------------------------------------------------------------------------#
#  Description of the script                                                   #
#==============================================================================#
#                         ** Instructions For Usage **                         #
#  There are settings that can be configured in the BattleCommands_Config      #
#  class. For more info on what and how to adjust these settings, see the      #
#  documentation  in the class.                                                #
#==============================================================================#
#                                ** Examples **                                #
#  See the documentation in each classes.                                      #
#==============================================================================#
#                           ** Installation Notes **                           #
#  Copy this script in the Materials section                                   #
#==============================================================================#
#                             ** Compatibility **                              #
#  Works With: Script Names, ...                                               #
#  Alias: Class - method, ...                                                  #
#  Overwrites: Class - method, ...                                             #
################################################################################

$imported = {} if $imported == nil
$imported["EBJB_BCTHROW"] = true

#==============================================================================
# ** BATTLECOMMANDS_CONFIG
#------------------------------------------------------------------------------
#  Contains the BattleCommands_Config configuration
#==============================================================================

module EBJB

  #==============================================================================
  # ** Throw_Command
  #------------------------------------------------------------------------------
  #  Represents a throwable weapon battle command
  #==============================================================================

  class Throw_Command < Battle_Command
    
    #//////////////////////////////////////////////////////////////////////////
    # * Attributes
    #//////////////////////////////////////////////////////////////////////////
    
    # Item ID
    attr_reader :item_id
    
    #//////////////////////////////////////////////////////////////////////////
    # * Properties
    #//////////////////////////////////////////////////////////////////////////
    
    #--------------------------------------------------------------------------
    # * Get the item object of the item battle command
    #--------------------------------------------------------------------------
    def item()
      return $data_weapons[@item_id]
    end
    
    #--------------------------------------------------------------------------
    # * Get the name of the item battle command
    #--------------------------------------------------------------------------
    def name()
      return $data_weapons[@item_id].name
    end
    
    #--------------------------------------------------------------------------
    # * Get the description of the item battle command
    #--------------------------------------------------------------------------
    def description()
      return $data_weapons[@item_id].description
    end
    
    #//////////////////////////////////////////////////////////////////////////
    # * Constructors
    #//////////////////////////////////////////////////////////////////////////
    
    #--------------------------------------------------------------------------
    # * Object Initialization
    #     id : id
    #     item_id : Item ID to get name and description of the battle command
    #     type :
    #--------------------------------------------------------------------------
    def initialize(id, item_id)
      super(id, BATTLECOMMANDS_CONFIG::BC_THROW)
      @item_id = item_id
    end
    
  end
    
  module BATTLECOMMANDS_CONFIG
  
    # Icons used for the Elemental Resistance Graph and the Elements icons list
    #0 = None           5 = Bow   (no)    10 = Ice    (105) 15 = Holy     (110) 
    #1 = Melee    (no)  6 = Whip  (no)    11 = Thunder(106) 16 = Darkness (111)
    #2 = Percing  (no)  7 = Mind  (no)    12 = Water  (107)
    #3 = Slashing (no)  8 = Absorb (no)   13 = Earth  (108)  
    #4 = Blow  (no)     9 = Fire   (104)  14 = Wind   (109)   
    ELEMENT_ICONS = [0,0,0,0,0,0,0,0,0,104,105,106,107,108,109,110,111]
    
    # Icons used for the Bonus stat in the Bonus icons list
    #0 = Two Handed (50)             2 = Prevent Critical (52) 
    #1 = Critical Bonus  (119)       3 = Half MP Cost (133) 
    BONUS_ICONS = [50,119,52,133]
    
    #------------------------------------------------------------------------
    # Item/Skill Details Window related
    #------------------------------------------------------------------------
    
    # Number of icons to show at the same time
    SW_LIST_MAX_ICONS = 4
    # Timeout in seconds before switching icons
    SW_LIST_ICONS_TIMEOUT = 1

    # Pattern used to show the value of the Recovery effect
    REC_PATTERN = "%d%%+%d"
    # Sign for plus state set
    STATES_PLUS_SIGN = "+"
    # Sign for minus state set
    STATES_MINUS_SIGN = "-"
    
    #------------------------------------------------------------------------
    # Throw Command related 
    #------------------------------------------------------------------------
    
    # Items ID that can be thrown
    BC_THROW_ITEMS_ID = [1,2,3,6,9,10,12,13,14,16,20,21,23,27,29,30,32,33]
    
    # Throw bonus damage rate (applied to weapon)
    BC_THROW_BONUS_DMG_RATE = 250
    
    #------------------------------------------------------------------------
    # Battle Commands Definitions
    #------------------------------------------------------------------------
    
    # Unique ids used to represent battle commands
    # BATTLE_COMMAND = 10xx
    BC_THROW = Utilities.generate_battle_command_uid("BC_THROW")
    
    # Battle commands data
    #WeaponFilter.new("throw")
    DATA_BATTLE_COMMANDS.push(List_Command.new(BC_THROW, BC_THROW))
    
    # Actor Battle Commands Settings
    #   syntax: actor_id => [LearningBattleCommand.new('type', ...), ...]
    #   Where 'type' is one of the Battle commands above
    CLASS_BATTLE_COMMANDS_LEARNINGS[1].push(LearningBattleCommand.new(BC_THROW))
    
  end
end

#==============================================================================
# ** BATTLESYSTEM_CONFIG
#------------------------------------------------------------------------------
#  Contains the BattleSystem_Config configuration
#==============================================================================

module EBJB
  
  module BATTLESYSTEM_CONFIG
    
    #------------------------------------------------------------------------
    # Battle Animations Definitions
    #------------------------------------------------------------------------
    
    # Unique ids used to represent Battle actions
    # BATTLE_ACTION = 10xx
    # 
    BA_THROW   = Utilities.generate_battle_action_uid("BA_THROW")
    
    # Actor Battle Action Animations definitions
    #   syntax: actor_id => {'type' => animation_id}
    #   Where 'type' is one of the IP modes above
    ACTOR_BA_ANIMS[1][BA_THROW] = 196

    # Actor Battler Settings
    #   syntax: actor_id => CustomBattler(width, height, move_speed, ba_show_weapon)
    ACTOR_BATTLER_SETTINGS[1].ba_show_weapon.push(BA_THROW)
    
    # Actor Weapon Animations definitions
    #   syntax: actor_id => {weapon_id => CustomAnim(animation_id, 'type'), ...}
    #   Where 'type' is one of the movement types above
    ACTOR_THROW_WEAPON_ANIMS = {
      1 => {1 => CustomAnim.new(nil, MOVE_STEPS, 0, 197),
            2 => CustomAnim.new(nil, MOVE_STEPS, 0, 197),
            3 => CustomAnim.new(nil, MOVE_STEPS, 0, 198)},
    }
    ACTOR_THROW_WEAPON_ANIMS.default = Hash.new(CustomAnim.new(nil, MOVE_STEPS))
    
  end
end

#===============================================================================
# ** RPG::Actor Addon
#------------------------------------------------------------------------------
#  Addon functions 
#===============================================================================

class RPG::Actor
  include EBJB
  
  #//////////////////////////////////////////////////////////////////////////
  # * Properties
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Get custom animation for throwable weapon
  #     weapon_id : weapon ID
  #--------------------------------------------------------------------------
  # GET
  def ani_throw_weapons(weapon_id=nil)
    if weapon_id == nil
      return BATTLESYSTEM_CONFIG::ACTOR_THROW_WEAPON_ANIMS[self.id]
    else
      return BATTLESYSTEM_CONFIG::ACTOR_THROW_WEAPON_ANIMS[self.id][weapon_id]
    end
  end
  
end

#==============================================================================
# ** Game_Actor
#------------------------------------------------------------------------------
#  This class handles actors. It's used within the Game_Actors class
# ($game_actors) and referenced by the Game_Party class ($game_party).
#==============================================================================

class Game_Actor < Game_Battler
  include EBJB
  
  #//////////////////////////////////////////////////////////////////////////
  # * Constructors
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Alias initialize
  #--------------------------------------------------------------------------
  alias setup_bc_throw setup unless $@
  def setup(actor_id)
    setup_bc_throw(actor_id)
    actor = $data_actors[actor_id]

    @battle_animation.ani_throw_weapons = actor.ani_throw_weapons
  end
  
  #//////////////////////////////////////////////////////////////////////////
  # * Public Methods
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Alias is_command_equipped?
  #--------------------------------------------------------------------------
  alias is_command_equipped_bc_throw? is_command_equipped? unless $@
  def is_command_equipped?(obj)
    if (obj.is_a?(RPG::Weapon))
      return active_battle_commands.any?{|c| c.is_a?(Throw_Command) && c.item_id == obj.id} || 
             is_command_equipped_bc_throw?(obj)
    elsif (obj.is_a?(Throw_Command))
      return active_battle_commands.any?{|c| c.id == obj.id} 
    else
      return is_command_equipped_bc_throw?(obj)
    end
  end
  
  #--------------------------------------------------------------------------
  # * Create Battle Action (for automatic battle)
  #--------------------------------------------------------------------------
  def make_autobattle_action
    @action.clear
    return unless movable?
    action = Game_BattleAction.new(self)
    
    command = self.autobattle_command
    if command.is_a?(Skill_Command)
      if command.is_custom
        action.forcing = true
      end
      if self.skill_can_use?(command.skill) || command.is_custom
        action.set_skill(command.skill.id)
      end
    elsif command.is_a?(Item_Command)
      if $game_party.item_can_use?(command.item)
        action.set_item(command.item.id)
      end
    elsif command.is_a?(Throw_Command)
      action.set_throw(command.item.id)
    else
      case command.type
      when BATTLECOMMANDS_CONFIG::BC_ATTACK 
        action.set_attack
      when BATTLECOMMANDS_CONFIG::BC_GUARD
        action.set_guard
      end
    end
    
    action.evaluate
    
    #Keeps action if it has been evaluated, else don't do anything
    if action.value > 0
      @action = action
    end
  end
  
end

#==============================================================================
# ** Game_BattleAction
#------------------------------------------------------------------------------
#  This class handles battle actions. This class is used within the
# Game_Battler class.
#==============================================================================

class Game_BattleAction
  
  #//////////////////////////////////////////////////////////////////////////
  # * Attributes
  #//////////////////////////////////////////////////////////////////////////
  
  # weapon ID
  attr_accessor :weapon_id
  
  #//////////////////////////////////////////////////////////////////////////
  # * Public Methods
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Set Throw Attack
  #--------------------------------------------------------------------------
  def set_throw(weapon_id)
    @kind = 0
    @basic = 5
    @weapon_id = weapon_id
  end
  
  #--------------------------------------------------------------------------
  # * Throw Attack Determination
  #--------------------------------------------------------------------------
  def throw?
    return (@kind == 0 and @basic == 5)
  end
  
  #--------------------------------------------------------------------------
  # * Get Throw Object
  #--------------------------------------------------------------------------
  def throw_weapon
    return throw? ? $data_weapons[@weapon_id] : nil
  end
  
  #--------------------------------------------------------------------------
  # * Alias determine_action_name
  #--------------------------------------------------------------------------
  alias determine_action_name_bc_throw determine_action_name unless $@
  def determine_action_name()
    action_name = ""
    if self.throw?
      action_name = "Throw"
    else
      action_name = determine_action_name_bc_throw
    end
    
    return action_name
  end
  
  #--------------------------------------------------------------------------
  # * Alias make_targets
  #--------------------------------------------------------------------------
  alias make_targets_bc_throw make_targets unless $@
  def make_targets
    if throw?
      return make_attack_targets
    else
      return make_targets_bc_throw
    end
  end
  
  #--------------------------------------------------------------------------
  # * Alias valid?
  #--------------------------------------------------------------------------
  alias valid_bc_throw? valid? unless $@
  def valid?
    return true if throw?
    return valid_bc_throw?
  end
  
end

#==============================================================================
# ** Game_Battle_Commands
#------------------------------------------------------------------------------
#  This class handles the battle commands array. The instance of this class is
# referenced by $game_battle_commands.
#==============================================================================

class Game_Battle_Commands
  include EBJB
  
  #//////////////////////////////////////////////////////////////////////////
  # * Public Methods
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Add new Item command
  #     item : item object
  #--------------------------------------------------------------------------
  def add_throw_command(item)
    id = Utilities.generate_battle_command_uid("BC_THROW_"+item.id.to_s)
    if (!@data.include?(id))
      @data[id] = Throw_Command.new(id, item.id)
    end
    return @data[id]
  end
  
end

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
#==============================================================================
# ** Game_Projectile
#------------------------------------------------------------------------------
#  This class deals with projectiles in battle.
#==============================================================================

class Game_Projectile
  include EBJB
  
  #//////////////////////////////////////////////////////////////////////////
  # * Attributes
  #//////////////////////////////////////////////////////////////////////////
  
  # weapon ID
  attr_reader   :weapon_id
  
  #//////////////////////////////////////////////////////////////////////////
  # * Constructors
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Alias initialize
  #--------------------------------------------------------------------------
  alias initialize_bc_throw initialize unless $@
  def initialize(battler, animation_id)
    initialize_bc_throw(battler, animation_id)
    
    if battler.action.throw?
      @battle_animation.ba_show_weapon.push(BATTLESYSTEM_CONFIG::BA_MOVE)
      @weapon_id = battler.action.weapon_id
    end
  end
  
end

#==============================================================================
# ** Sprite_Projectile
#------------------------------------------------------------------------------
#  This sprite is used to display projectiles. It observes a instance of the
# Game_Projectile class and automatically changes sprite conditions.
#==============================================================================

class Sprite_Projectile < Sprite_BattleAnimBase
  include EBJB
      
  #//////////////////////////////////////////////////////////////////////////
  # * Public Methods
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Overrides the loop animation animation for weapon (contents are defined by the subclasses)
  #--------------------------------------------------------------------------
  def override_loop_animation_weapon
    if @projectile.weapon_id != nil && @projectile.weapon_id > 0
      weapon = $data_weapons[@projectile.weapon_id]
    end
    return weapon
  end

end

#==============================================================================
# ** Scene_BattleCommands
#------------------------------------------------------------------------------
#  This class performs the battle commands change screen processing.
#===============================================================================

class Scene_BattleCommands < Scene_Base
  include EBJB
  
  #//////////////////////////////////////////////////////////////////////////
  # * Public Methods
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Alias start
  #--------------------------------------------------------------------------
  alias start_bc_throw start unless $@
  def start
    start_bc_throw()
    
    @throw_command_window = Window_Throw_Command.new(640, 208, 440, 176)
    @throw_command_window.active = false
    @throw_command_window.visible = false
    @throw_command_window.index = -1
    
    @throw_command_window.help_window = @help_window
    
    @equip_details_window = Window_EquipDetails.new(0,384,640,96,nil)
    @equip_details_window.visible = false    
    @throw_command_window.detail_window = @equip_details_window
    
    [@throw_command_window, @equip_details_window].each{
      |w| w.opacity = BATTLESYSTEM_CONFIG::WINDOW_OPACITY;
          w.back_opacity = BATTLESYSTEM_CONFIG::WINDOW_BACK_OPACITY
    }
  end
  
  #--------------------------------------------------------------------------
  # * Alias terminate
  #--------------------------------------------------------------------------
  alias terminate_bc_throw terminate unless $@
  def terminate
    terminate_bc_throw()
    
    @throw_command_window.dispose if @throw_command_window != nil
    @equip_details_window.dispose if @equip_details_window != nil
  end
  
  #--------------------------------------------------------------------------
  # * Alias update
  #--------------------------------------------------------------------------
  alias update_bc_throw update unless $@
  def update
    update_bc_throw()
    
    @throw_command_window.update
    @equip_details_window.update
    if @throw_command_window.active
      update_throw_command_selection
    end
  end
  
  #--------------------------------------------------------------------------
  # * Alias update_window_movement
  #--------------------------------------------------------------------------
  alias update_window_movement_bc_throw update_window_movement unless $@
  def update_window_movement()
    update_window_movement_bc_throw()
    
    # Battle command window position
    if @throw_command_window.active
      if @battle_commands_window.x > 0
        @battle_commands_window.x -= 20
      end
    end
    
    # Throw window position
    if @throw_command_window.active
      @throw_command_window.visible = true
      if @throw_command_window.x > 200
        @throw_command_window.x -= 40
      end
    else
      if @throw_command_window.x < 640
        @throw_command_window.x += 40
      else
        @throw_command_window.visible = false
      end
    end
    
  end
  
  #//////////////////////////////////////////////////////////////////////////
  # * Private Methods
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Alias update_detail_window
  #-------------------------------------------------------------------------- 
  alias update_detail_window_bc_throw update_detail_window unless $@
  def update_detail_window(command)    
    if command.is_a?(Throw_Command)
      @actor_commands_window.detail_window = @equip_details_window
    else
      update_detail_window_bc_throw(command)
    end
  end
  private :update_detail_window
  
  #//////////////////////////////////////////////////////////////////////////
  # * Scene input management methods
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Alias update_battle_command_selection
  #--------------------------------------------------------------------------
  alias update_battle_command_selection_bc_throw update_battle_command_selection unless $@
  def update_battle_command_selection()
    update_battle_command_selection_bc_throw()
    
    if Input.trigger?(Input::RIGHT)
      if @battle_commands_window.selected_battle_command.is_a?(List_Command)
        if @battle_commands_window.selected_battle_command.type == BATTLECOMMANDS_CONFIG::BC_THROW
          throw_command()
        end
      end
    end    
  end
  private :update_battle_command_selection
  
  #--------------------------------------------------------------------------
  # * Update Throw Command Selection
  #--------------------------------------------------------------------------
  def update_throw_command_selection()
    if Input.trigger?(Input::B)
      Sound.play_cancel
      cancel_throw_command()
      
    elsif Input.trigger?(Input::C)
      if @throw_command_window.selected_item == nil ||
         (!@autobattle_window.active && !@throw_command_window.enable?(@throw_command_window.selected_item))
        Sound.play_buzzer
      else
        Sound.play_decision
        command = $game_battle_commands.add_throw_command(@throw_command_window.selected_item)
        change_battle_command(command)
      end
    end
  end
  private :update_throw_command_selection
  
  #//////////////////////////////////////////////////////////////////////////
  # * Scene Commands
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Change battle command
  #     command : New battle command
  #--------------------------------------------------------------------------
  alias change_battle_command_bc_throw change_battle_command unless $@
  def change_battle_command(command)
    change_battle_command_bc_throw(command)
    
    if @throw_command_window.active
      @throw_command_window.window_update(@actor, $game_party.items, @battle_commands_window.selected_battle_command.filter)
    end
  end
  private :change_battle_command
  
  #--------------------------------------------------------------------------
  # * Throw command
  #--------------------------------------------------------------------------
  def throw_command()
    @battle_commands_window.active = false
    @throw_command_window.window_update(@actor, $game_party.items, @battle_commands_window.selected_battle_command.filter)
    @throw_command_window.active = true
    @throw_command_window.index = 0
  end
  private :throw_command
  
  #--------------------------------------------------------------------------
  # * Cancel Throw command
  #--------------------------------------------------------------------------
  def cancel_throw_command()
    @battle_commands_window.active = true
    @throw_command_window.active = false
    @throw_command_window.index = -1
    @battle_commands_window.call_update_help()
    @equip_details_window.window_update(nil)
    @equip_details_window.visible = false
  end
  private :cancel_throw_command
  
end

#==============================================================================
# ** Scene_Battle
#------------------------------------------------------------------------------
#   This class performs battle screen processing.
#==============================================================================

class Scene_Battle < Scene_Base
  include EBJB
  
  #//////////////////////////////////////////////////////////////////////////
  # * Public Methods
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Alias start
  #--------------------------------------------------------------------------
  alias start_bc_throw start unless $@
  def start
    start_bc_throw
    
    @throw_window = Window_BattleThrow.new(0, 480, 298, 176, nil)
    @throw_window.active = false
    @throw_window.help_window = @bot_help_window
    
    [@throw_window].each{
      |w| w.opacity = BATTLESYSTEM_CONFIG::WINDOW_OPACITY;
          w.back_opacity = BATTLESYSTEM_CONFIG::WINDOW_BACK_OPACITY
    }
  end
  
  #--------------------------------------------------------------------------
  # * Alias terminate
  #--------------------------------------------------------------------------
  alias terminate_bc_throw terminate unless $@
  def terminate
    terminate_bc_throw
    
    @throw_window.dispose if @throw_window != nil
  end
  
  #--------------------------------------------------------------------------
  # * Alias update_basic
  #--------------------------------------------------------------------------
  alias update_basic_bc_throw update_basic unless $@
  def update_basic(main = false)
    update_basic_bc_throw(main)

    @throw_window.update
  end
  
  #--------------------------------------------------------------------------
  # * Alias update_window_movement
  #--------------------------------------------------------------------------
  alias update_window_movement_bc_throw update_window_movement unless $@
  def update_window_movement()
    update_window_movement_bc_throw
    
    # Throw window position
    if @throw_window.active
      @throw_window.visible = true
      if @throw_window.y > 288+16
        @throw_window.y -= 16
      end
    else
      if @throw_window.y < 480
        @throw_window.y += 16
      else
        @throw_window.visible = false
      end
    end
  end
  
  #--------------------------------------------------------------------------
  # * Alias custom_actor_command_active?
  #--------------------------------------------------------------------------
  alias custom_actor_command_active_bc_throw? custom_actor_command_active? unless $@
  def custom_actor_command_active?
    if @throw_window.active
      return true
    else 
      return custom_actor_command_active_bc_throw?
    end
  end
  
  #--------------------------------------------------------------------------
  # * Alias update_custom_actor_command_input 
  #--------------------------------------------------------------------------
  alias update_custom_actor_command_input_bc_throw update_custom_actor_command_input unless $@
  def update_custom_actor_command_input
    if @throw_window.active
      update_throw_selection    # Select throwable weapon
    else
      update_custom_actor_command_input_bc_throw
    end
  end
  
  #--------------------------------------------------------------------------
  # * Alias execute_battle_commands
  #--------------------------------------------------------------------------
  alias execute_battle_commands_bc_throw execute_battle_commands unless $@
  def execute_battle_commands(actor)
    command = @actor_command_window.selected_command
    if command.type == BATTLECOMMANDS_CONFIG::BC_THROW
      if command.is_a?(List_Command)
        Sound.play_decision
        #@throw_window.filter = command.filter
        start_throw_selection
      elsif command.is_a?(Throw_Command)
        Sound.play_decision
        @actor_command_window.active = false
        determine_throw(command.item)
      end
    else
      execute_battle_commands_bc_throw(actor)
    end
  end
  
  #--------------------------------------------------------------------------
  # * Alias execute_action
  #--------------------------------------------------------------------------
  alias execute_action_bc_throw execute_action unless $@
  def execute_action
    if @active_battler.action.throw?
      execute_action_throw
      @active_battler.action.clear
    else
      execute_action_bc_throw
    end
  end
  
  #--------------------------------------------------------------------------
  # * Execute Battle Action: Throw
  #--------------------------------------------------------------------------
  def execute_action_throw
    weapon = @active_battler.action.throw_weapon
    @top_help_window.set_text(@active_battler.action.determine_action_name)
    @top_help_window.visible = true
    $game_party.lose_item(weapon, 1)
    @active_battler.stamina_wait = true
    @active_battler.empty_stamina
    execute_basic_action(nil)
    @top_help_window.visible = false
  end
  
  #--------------------------------------------------------------------------
  # * 
  #     obj : 
  #--------------------------------------------------------------------------
  alias determine_custom_battler_animation_bc_throw determine_custom_battler_animation unless $@
  def determine_custom_battler_animation(battler, obj)
    if battler.action.throw?
      return battler.battle_animation.ani_throw_weapons[battler.action.weapon_id]
      #return CustomAnim.new(nil, BATTLESYSTEM_CONFIG::MOVE_STEPS)
    else
      return determine_custom_battler_animation_bc_throw(battler, obj)
    end
  end

  #--------------------------------------------------------------------------
  # * 
  #     obj : 
  #--------------------------------------------------------------------------
  alias do_custom_target_effect_bc_throw do_custom_target_effect unless $@
  def do_custom_target_effect(battler, target, obj)
    if battler.action.throw?
      temp = battler.clone
      temp.atk = (battler.action.throw_weapon.atk * (BATTLECOMMANDS_CONFIG::BC_THROW_BONUS_DMG_RATE / 100.0))
      target.attack_effect(temp)
    else
      do_custom_target_effect_bc_throw(battler, target, obj)
    end
  end
  
  #--------------------------------------------------------------------------
  # * 
  #     obj : 
  #--------------------------------------------------------------------------
  alias do_custom_animation_bc_throw do_custom_animation unless $@
  def do_custom_animation(battler, obj)
    if battler.action.throw?
      battler.battle_animation.do_ani_throw(battler.action.weapon_id)
    else
      do_custom_animation_bc_throw(battler, obj)
    end
  end
  
  #--------------------------------------------------------------------------
  # * 
  #     obj : 
  #--------------------------------------------------------------------------
  alias display_custom_animation_bc_throw display_custom_animation unless $@
  def display_custom_animation(battler, targets)
    if battler.action.throw?
      display_animation(targets, battler.action.throw_weapon.animation_id, false)
    else
      display_custom_animation_bc_throw(battler, targets)
    end
  end
  
  #--------------------------------------------------------------------------
  # * Confirm Throw
  #     weapon : weapon object
  #--------------------------------------------------------------------------
  def determine_throw(weapon)
    actor = $game_party.members[@actor_index]
    actor.action.set_throw(weapon.id)
    @throw_window.active = false
    start_target_enemy_selection
  end
  
  #//////////////////////////////////////////////////////////////////////////
  # * Scene Commands
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Update Throw Selection
  #--------------------------------------------------------------------------
  def update_throw_selection   
    actor = $game_party.members[@actor_index]
    if (not actor.ready_for_action?) and (not actor.inputable?)
      end_throw_selection()
      return
    end
    
    @throw_window.call_update_help()

    if Input.trigger?(Input::B)
      Sound.play_cancel
      end_throw_selection
    elsif Input.trigger?(Input::C)
      weapon = @throw_window.selected_weapon
      if weapon != nil
        Sound.play_decision
        @targeting_window = @throw_window
        determine_throw(weapon)
      else
        Sound.play_buzzer
      end
    end
  end
  
  #--------------------------------------------------------------------------
  # * Start Throw Selection
  #--------------------------------------------------------------------------
  def start_throw_selection
    @throw_window.index = 0
    @throw_window.window_update($game_party.items)
    @throw_window.active = true
    @throw_window.call_update_help()
    @actor_command_window.active = false
    deactivate_stamina(0)
  end
 
  #--------------------------------------------------------------------------
  # * End Throw Selection
  #--------------------------------------------------------------------------
  def end_throw_selection
    @throw_window.active = false
    @actor_command_window.active = true
    activate_stamina(0)
  end
  
end

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
      control.active = $game_party.item_can_use?(command.item)
    else
      control = create_item_bc_throw(index)
    end

    return control
  end
  private :create_item
  
end

#==============================================================================
# ** Window_Throw_Command
#------------------------------------------------------------------------------
#  This window displays a list of throwable items for the item screen, etc.
#==============================================================================

class Window_Throw_Command < Window_Selectable
  include EBJB
  
  #//////////////////////////////////////////////////////////////////////////
  # * Attributes
  #//////////////////////////////////////////////////////////////////////////
  
  # Array of UCItem for every item in the inventory
  attr_reader :ucItemsList

  #//////////////////////////////////////////////////////////////////////////
  # * Properties
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Get the current item
  #--------------------------------------------------------------------------
  # GET
  def selected_item
    return (self.index < 0 ? nil : @data[self.index])
  end
  
  #//////////////////////////////////////////////////////////////////////////
  # * Constructors
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Object Initialization
  #     x : window x-coordinate
  #     y : window y-coordinate
  #     width : window width
  #     height : window height
  #     actor : actor object
  #     items : items list
  #     filter : filter object
  #--------------------------------------------------------------------------
  def initialize(x, y, width, height, actor=nil, items=nil, filter=nil)
    super(x, y, width, height)
    @column_max = 2
    @ucItemsList = []
    window_update(actor, items, filter)
    self.index = 0
  end
  
  #//////////////////////////////////////////////////////////////////////////
  # * Public Methods
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Update
  #     actor : actor object
  #     items : items list
  #     filter : filter object
  #--------------------------------------------------------------------------
  def window_update(actor, items, filter)
    @data = []
    if actor != nil && items != nil 
      @actor = actor

      if filter != nil
        temp_items = items.find_all{|x| filter.apply(x)}
      else
        temp_items = items
      end

      for item in temp_items
        if item != nil && (filter != nil || include?(item))
          @data.push(item)
        end
      end
      @item_max = @data.size
      create_contents()
      @ucItemsList.clear()
      for i in 0..@item_max-1
        @ucItemsList.push(create_item(i))
      end
    end
    refresh()
  end
  
  #--------------------------------------------------------------------------
  # * Refresh
  #--------------------------------------------------------------------------
  def refresh()
    self.contents.clear
    @ucItemsList.each() { |ucItem| ucItem.draw() }
  end
  
  #--------------------------------------------------------------------------
  # * Update Help Text
  #--------------------------------------------------------------------------
  def update_help
#~     if @help_window.is_a?(Window_Help)
#~       @help_window.set_text(item == nil ? "" : item.description)
#~     else
      if selected_item != nil
        @help_window.window_update(selected_item.description)
      else
        @help_window.window_update("")
      end
#~     end
  end
  
  #--------------------------------------------------------------------------
  # * Update Detail Window
  #--------------------------------------------------------------------------
  def update_detail
    if selected_item != nil
      @detail_window.window_update(selected_item)
    else
      @detail_window.window_update(nil)
    end
  end
  
  #--------------------------------------------------------------------------
  # * Determine if help/detail window can be switched
  #--------------------------------------------------------------------------
  def is_switchable
    return selected_item != nil && selected_item.is_a?(RPG::Weapon)
  end
  
  #--------------------------------------------------------------------------
  # * Whether or not to display in enabled state
  #     item : item object
  #--------------------------------------------------------------------------
  def enable?(item)
    return !@actor.is_command_equipped?(item)
  end
  
  #//////////////////////////////////////////////////////////////////////////
  # * Private Methods
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Whether or not to include in item list
  #     item : item
  #--------------------------------------------------------------------------
  def include?(item)
    return item.is_a?(RPG::Weapon) && BATTLECOMMANDS_CONFIG::BC_THROW_ITEMS_ID.include?(item.id)
  end
  private :include?
  
  #--------------------------------------------------------------------------
  # * Create an item for SkillsList
  #     index : item index
  #--------------------------------------------------------------------------
  def create_item(index)
    item = @data[index]
    rect = item_rect(index, true)
    
    ucItem = UCItem.new(self, item, rect)
    ucItem.active = enable?(item)
                              
    return ucItem
  end
  private :create_item
  
end

#==============================================================================
# ** Window_BattleThrow
#------------------------------------------------------------------------------
#  This window displays a list of usable throwable weapons during battle.
#==============================================================================

class Window_BattleThrow < Window_Selectable
  include EBJB
  
  #//////////////////////////////////////////////////////////////////////////
  # * Attributes
  #//////////////////////////////////////////////////////////////////////////
  
  # Array of CLabel for every throwable weapons
  attr_reader :cWeaponsList
  
  #//////////////////////////////////////////////////////////////////////////
  # * Properties
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Get the current weapon
  #--------------------------------------------------------------------------
  # GET
  def selected_weapon
    return (self.index < 0 ? nil : @data[self.index])
  end
  
  #//////////////////////////////////////////////////////////////////////////
  # * Constructors
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Object Initialization
  #     x : window x-coordinate
  #     y : window y-coordinate
  #     width : window width
  #     height : window height
  #     actor : actor object
  #--------------------------------------------------------------------------
  def initialize(x, y, width, height, items)
    super(x, y, width, height)
    @column_max = 1
    @cWeaponsList = []
    window_update(items)
    self.index = 0
  end
  
  #//////////////////////////////////////////////////////////////////////////
  # * Public Methods
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Update
  #     items : items list
  #--------------------------------------------------------------------------
  def window_update(items)
    @data = []
    if items != nil
      for item in items
        next unless include?(item)
        if item != nil
          @data.push(item)
        end
      end
      @item_max = @data.size
      create_contents()
      @cWeaponsList.clear()
      for i in 0..@item_max-1
        @cWeaponsList.push(create_item(i))
      end
    end
    refresh()
  end
  
  #--------------------------------------------------------------------------
  # * Refresh
  #--------------------------------------------------------------------------
  def refresh()
    self.contents.clear
    @cWeaponsList.each() { |cWeapon| cWeapon.draw() }
  end
  
  #--------------------------------------------------------------------------
  # * Update Help Text
  #--------------------------------------------------------------------------
  def update_help
    if @help_window.is_a?(Window_Help)
      @help_window.set_text(selected_weapon == nil ? "" : selected_weapon.description)
#~     else
#~       if selected_weapon != nil
#~         @help_window.window_update(selected_weapon.description)
#~       else
#~         @help_window.window_update("")
#~       end
    end
  end
  
  #--------------------------------------------------------------------------
  # * Update Detail Window
  #--------------------------------------------------------------------------
  def update_detail
    if selected_weapon != nil
      @detail_window.window_update(selected_weapon)
    else
      @detail_window.window_update(nil)
    end
  end
  
  #//////////////////////////////////////////////////////////////////////////
  # * Private Methods
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Whether or not to include in item list
  #     item : item
  #--------------------------------------------------------------------------
  def include?(item)
    return item.is_a?(RPG::Weapon) && BATTLECOMMANDS_CONFIG::BC_THROW_ITEMS_ID.include?(item.id)
  end
  private :include?
  
  #--------------------------------------------------------------------------
  # * Create an item for WeaponsList
  #     index : item index
  #--------------------------------------------------------------------------
  def create_item(index)
    weapon = @data[index]
    rect = item_rect(index, true)
    
    cWeapon = UCItem.new(self, weapon, rect)
  
    return cWeapon
  end
  private :create_item
  
end

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
      return UCItem.new(self, command.item, rect)
    else
      return create_item_bc_throw(command, actor, rect)
    end
  end
  private :create_item
  
end

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

#==============================================================================
# ** Vocab
#------------------------------------------------------------------------------
#  This module defines terms and messages. It defines some data as constant
# variables. Terms in the database are obtained from $data_system.
#==============================================================================

module Vocab
  
  #//////////////////////////////////////////////////////////////////////////
  # * Stats Parameters related
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Get ATK Label
  #--------------------------------------------------------------------------
  def self.atk_label
    return self.atk
  end
  
  #--------------------------------------------------------------------------
  # * Get DEF Label
  #--------------------------------------------------------------------------
  def self.def_label
    return self.def
  end
  
  #--------------------------------------------------------------------------
  # * Get SPI Label
  #--------------------------------------------------------------------------
  def self.spi_label
    return self.spi
  end
  
  #--------------------------------------------------------------------------
  # * Get AGI Label
  #--------------------------------------------------------------------------
  def self.agi_label
    return self.agi
  end
  
  #--------------------------------------------------------------------------
  # * Get EVA Label
  #--------------------------------------------------------------------------
  def self.eva_label
    return "EVA"
  end
  
  #--------------------------------------------------------------------------
  # * Get HIT Label
  #--------------------------------------------------------------------------
  def self.hit_label
    return "HIT"
  end
  
  #--------------------------------------------------------------------------
  # * Get CRI Label
  #--------------------------------------------------------------------------
  def self.cri_label
    return "CRI"
  end
  
  #//////////////////////////////////////////////////////////////////////////
  # * Details Window related
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Get Label to show for the Stats
  #--------------------------------------------------------------------------
  def self.stats_label
    return "STATS"
  end

  #--------------------------------------------------------------------------
  # * Get Label to show for the Bonus list
  #--------------------------------------------------------------------------
  def self.bonus_label
    return "BONUS"
  end
    
  class << self
  include EBJB
    #//////////////////////////////////////////////////////////////////////////
    # * Public Methods
    #//////////////////////////////////////////////////////////////////////////
    
    #//////////////////////////////////////////////////////////////////////////
    # Battle Commands related
    #//////////////////////////////////////////////////////////////////////////
    
    #--------------------------------------------------------------------------
    # * Get Strings to show for every battle command (name + description)
    #--------------------------------------------------------------------------
    alias battle_commands_strings_bc_throw battle_commands_strings unless $@
    def battle_commands_strings
      return battle_commands_strings_bc_throw.merge(
      {
       BATTLECOMMANDS_CONFIG::BC_THROW => ["Throw", "Attacks by throwing a weapon to a target"]
      })
    end
    
  end
end

