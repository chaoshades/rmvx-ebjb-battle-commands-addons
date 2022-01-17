#===============================================================================
# 
# Shanghai Simple Script - Minigame Slot Machine
# Last Date Updated: 2010.05.18
# Level: Normal
# 
# This is a minigame script. It's easy to play. Press Z to stop each individual
# slot and try to line up all three within the five possible combinations.
#===============================================================================
# Instructions
# -----------------------------------------------------------------------------
# To install this script, open up your script editor and copy/paste this script
# to an open slot below ▼ Materials but above ▼ Main. Remember to save.
# 
# Do a script call for
#   $game_variables[1] = slot_machine(x, y)
# 
# x is the length of the slot reel where the longer it is, the more items there
# are and y is the cursor speed. Works with Battle Engine Melody.
#===============================================================================
 
$imported = {} if $imported == nil
$imported["MinigameSlotMachine"] = true

module SSS
  # This is the image file from the system folder used for the slot machine.
  SLOT_MACHINE_SHEET = "MiniGameSlots"
  # These are the sound effects for the slot machine game.
  SLOT_MACHINE_STOP  = RPG::SE.new("Open3", 100, 120)
  SLOT_MACHINE_CLICK = RPG::SE.new("Switch1", 100, 100)
  SLOT_MACHINE_LUCKY = RPG::SE.new("Chime2", 100, 120)
  SLOT_MACHINE_MISS  = RPG::SE.new("Buzzer2", 100, 100)
  # This hash contains data used to refer icons.
  SLOT_ICONS ={
     1 => 214,
     2 => 215,
     3 =>  94,
     4 => 205,
     5 => 203,
     6 => 201,
     7 => 204,
     8 => 200,
  } # Remove this and perish.
module SPRITESET
  #--------------------------------------------------------------------------
  # * Slot Machine Game
  #--------------------------------------------------------------------------
  def slot_machine(possibilities = SSS::SLOT_ICONS.size, speed = 5)
    @slot_possibilities = [possibilities, 3].max
    @slot_speed = [[speed, 1].max, 20].min
    @slot_stops = 0
    @start_ticks = 80
    @stop_ticks = 60
    create_slot_machine_sprites
    create_slot_machine_planes
  end
  #--------------------------------------------------------------------------
  # * Create Slot Machine Sprites
  #--------------------------------------------------------------------------
  def create_slot_machine_sprites
    vp = @viewportC.nil? ? @viewport3 : @viewportC
    @slot_machine_sprite = Sprite_Base.new(vp)
    bitmap1 = Bitmap.new(240, 264)
    bitmap2 = Cache.system(SSS::SLOT_MACHINE_SHEET)
    # Make the Main Body
    rect = Rect.new(0, 0, 240, 240)
    bitmap1.blt(0, 0, bitmap2, rect)
    # Make the Instructions
    unless $game_temp.in_battle
      rect = Rect.new(0, 240, 192, 24)
      bitmap1.blt(24, 240, bitmap2, rect)
    end
    # Apply Sprite
    @slot_machine_sprite.bitmap = bitmap1
    @slot_machine_sprite.x = (Graphics.width - 240) / 2
    @slot_machine_sprite.y = Graphics.height - 368
    # Make Sounds
    @stop_sound = SSS::SLOT_MACHINE_STOP
    @click_sound = SSS::SLOT_MACHINE_CLICK
    @slot_machine_sprite.opacity = 0
  end
  #--------------------------------------------------------------------------
  # * Dispose Slot Machine Sprites
  #--------------------------------------------------------------------------
  def dispose_slot_machine_sprites
    unless @slot_machine_sprite.nil?
      @slot_machine_sprite.bitmap.dispose
      @slot_machine_sprite.dispose
      @slot_machine_sprite = nil
    end
    unless @slot_results_sprite.nil?
      @slot_results_sprite.bitmap.dispose
      @slot_results_sprite.dispose
      @slot_results_sprite = nil
    end
    unless @slot_viewport1.nil?
      @slot_viewport1.dispose
      @slot_viewport1 = nil
      @slot_plane1.bitmap.dispose
      @slot_plane1.dispose
      @slot_plane1 = nil
      @slot_viewport2.dispose
      @slot_viewport2 = nil
      @slot_plane2.bitmap.dispose
      @slot_plane2.dispose
      @slot_plane2 = nil
      @slot_viewport3.dispose
      @slot_viewport3 = nil
      @slot_plane3.bitmap.dispose
      @slot_plane3.dispose
      @slot_plane3 = nil
    end
  end
  #--------------------------------------------------------------------------
  # * Create Slot Machine Planes
  #--------------------------------------------------------------------------
  def create_slot_machine_planes
    # Create Planes
    rect = Rect.new(0, 0, 44, 140)
    rect.x = @slot_machine_sprite.x+48
    rect.y = @slot_machine_sprite.y+52
    vp = @viewportC.nil? ? @viewport3 : @viewportC
    @slot_viewport1 = Viewport.new(rect.clone)
    @slot_viewport1.z = vp.z
    @slot_plane1 = Plane.new(@slot_viewport1)
    rect.x = @slot_machine_sprite.x+98
    rect.y = @slot_machine_sprite.y+52
    @slot_viewport2 = Viewport.new(rect.clone)
    @slot_viewport2.z = vp.z
    @slot_plane2 = Plane.new(@slot_viewport2)
    rect.x = @slot_machine_sprite.x+148
    rect.y = @slot_machine_sprite.y+52
    @slot_viewport3 = Viewport.new(rect.clone)
    @slot_viewport3.z = vp.z
    @slot_plane3 = Plane.new(@slot_viewport3)
    bitmap0 = Cache.system("IconSet")
    # Make Plane Bitmap 1
    bitmap1 = Bitmap.new(48, @slot_possibilities * 48)
    @slot_array1 = []
    n = 1
    @slot_possibilities.times do
      @slot_array1.insert(rand(@slot_array1.size+1), n)
      n += 1
    end
    for id in @slot_array1
      icon_index = SSS::SLOT_ICONS[id]
      rect1 = Rect.new(-2, (@slot_array1.index(id)) * 48 - 4, 48, 48)
      rect2 = Rect.new(icon_index % 16 * 24, icon_index / 16 * 24, 24, 24)
      bitmap1.stretch_blt(rect1, bitmap0, rect2) 
      @slot_plane1.bitmap = bitmap1
    end
    # Make Plane Bitmap 2
    bitmap2 = Bitmap.new(48, @slot_possibilities * 48)
    @slot_array2 = []
    n = 1
    @slot_possibilities.times do
      @slot_array2.insert(rand(@slot_array2.size+1), n)
      n += 1
    end
    for id in @slot_array2
      icon_index = SSS::SLOT_ICONS[id]
      rect1 = Rect.new(-2, (@slot_array2.index(id)) * 48 - 4, 48, 48)
      rect2 = Rect.new(icon_index % 16 * 24, icon_index / 16 * 24, 24, 24)
      bitmap2.stretch_blt(rect1, bitmap0, rect2) 
      @slot_plane2.bitmap = bitmap2
    end
    # Make Plane Bitmap 3
    bitmap3 = Bitmap.new(48, @slot_possibilities * 48)
    @slot_array3 = []
    n = 1
    @slot_possibilities.times do
      @slot_array3.insert(rand(@slot_array3.size+1), n)
      n += 1
    end
    for id in @slot_array3
      icon_index = SSS::SLOT_ICONS[id]
      rect1 = Rect.new(-2, (@slot_array3.index(id)) * 48 - 4, 48, 48)
      rect2 = Rect.new(icon_index % 16 * 24, icon_index / 16 * 24, 24, 24)
      bitmap3.stretch_blt(rect1, bitmap0, rect2) 
      @slot_plane3.bitmap = bitmap3
    end
    @slot_plane1.opacity = 0
    @slot_plane2.opacity = 0
    @slot_plane3.opacity = 0
  end
  #--------------------------------------------------------------------------
  # * Update Slot Machine
  #--------------------------------------------------------------------------
  def update_slot_machine
    case @start_ticks
    when 61..80
      slot_speed = 0
      @slot_machine_sprite.opacity += 16
      @slot_plane1.opacity += 16
      @slot_plane2.opacity += 16
      @slot_plane3.opacity += 16
    when 41..60
      slot_speed = [@slot_speed / 4, 1].max
    when 21..40
      slot_speed = [@slot_speed / 2, 1].max
    when 1..20
      slot_speed = [@slot_speed * 3 / 4, 1].max
    when 0
      slot_speed = @slot_speed
    end
    @slot_machine_sprite.update
    @start_ticks -= 1 if @start_ticks > 0
    @slot_plane1.oy -= slot_speed if @slot_stops < 1
    @slot_plane2.oy -= slot_speed if @slot_stops < 2
    @slot_plane3.oy -= slot_speed if @slot_stops < 3
    @sound_ticks = 24 if @sound_ticks.nil? or @sound_ticks <= 0
    @sound_ticks -= slot_speed
    @click_sound.play if @sound_ticks <= 0 and @slot_stops < 3
    stop_slot if @start_ticks <= 0 and Input.trigger?(Input::C)
    slot_correction
  end
  #--------------------------------------------------------------------------
  # * Stop Slot
  #--------------------------------------------------------------------------
  def stop_slot
    return if @slot_stops == 3
    @stop_sound.play
    @slot_stops += 1
    bitmap = Cache.system(SSS::SLOT_MACHINE_SHEET)
    rect = Rect.new(192, 240, 48, 48)
    case @slot_stops
    when 1
      @slot_machine_sprite.bitmap.blt(46, 193, bitmap, rect)
    when 2
      @slot_machine_sprite.bitmap.blt(96, 193, bitmap, rect)
    when 3
      @slot_machine_sprite.bitmap.blt(146, 193, bitmap, rect)
    end
  end
  #--------------------------------------------------------------------------
  # * Slot Correction
  #--------------------------------------------------------------------------
  def slot_correction
    if @slot_stops >= 1 and @slot_plane1.oy % 48 != 0
      case @slot_plane1.oy % 48
      when 39..47; value = [5, @slot_speed].min
      when 29..38; value = [4, @slot_speed].min
      when 19..28; value = [3, @slot_speed].min
      when  9..18; value = [2, @slot_speed].min
      else; value = 1
      end
      @slot_plane1.oy -= value
    end
    if @slot_stops >= 2 and @slot_plane2.oy % 48 != 0
      case @slot_plane2.oy % 48
      when 39..47; value = [5, @slot_speed].min
      when 29..38; value = [4, @slot_speed].min
      when 19..28; value = [3, @slot_speed].min
      when  9..18; value = [2, @slot_speed].min
      else; value = 1
      end
      @slot_plane2.oy -= value
    end
    if @slot_stops >= 3 and @slot_plane3.oy % 48 != 0
      case @slot_plane3.oy % 48
      when 39..47; value = [5, @slot_speed].min
      when 29..38; value = [4, @slot_speed].min
      when 19..28; value = [3, @slot_speed].min
      when  9..18; value = [2, @slot_speed].min
      else; value = 1
      end
      @slot_plane3.oy -= value
    end
  end
  #--------------------------------------------------------------------------
  # * Slot Machine Stopped
  #--------------------------------------------------------------------------
  def slot_machine_stopped
    return false if @slot_stops < 3
    return false unless @slot_plane1.oy % 48 == 0
    return false unless @slot_plane2.oy % 48 == 0
    return false unless @slot_plane3.oy % 48 == 0
    @stop_ticks -= 1
    return false unless @stop_ticks < 0
    return true
  end
  #--------------------------------------------------------------------------
  # * Finish Slot Machine
  #--------------------------------------------------------------------------
  def finish_slot_machine
    results = slot_machine_results
    # Create Victory Image
    vp = @viewportC.nil? ? @viewport3 : @viewportC
    @slot_results_sprite = Sprite_Base.new(vp)
    bitmap1 = Bitmap.new(96, 24)
    bitmap2 = Cache.system(SSS::SLOT_MACHINE_SHEET)
    if results > 0
      SSS::SLOT_MACHINE_LUCKY.play
      rect = Rect.new(92, 264, 96, 24)
    end
    if results <= 0
      SSS::SLOT_MACHINE_MISS.play
      rect = Rect.new(0, 264, 96, 24)
    end
    bitmap1.blt(0, 0, bitmap2, rect)
    @slot_results_sprite.bitmap = bitmap1
    @slot_results_sprite.ox = 48
    @slot_results_sprite.oy = 24
    @slot_results_sprite.x = Graphics.width/2
    @slot_results_sprite.y = Graphics.height/2
    @slot_results_sprite.zoom_x = 2.0
    @slot_results_sprite.zoom_y = 2.0
    # Fade out Slot Machine
    loop do
      @slot_machine_sprite.opacity -= 16
      @slot_plane1.opacity -= 16
      @slot_plane2.opacity -= 16
      @slot_plane3.opacity -= 16
      @slot_machine_sprite.update
      @slot_results_sprite.y -= 1
      @slot_results_sprite.update
      $scene.update_basic
      break if @slot_machine_sprite.opacity < 1
    end
    loop do
      @slot_results_sprite.opacity -= 8
      @slot_results_sprite.update
      $scene.update_basic
      break if @slot_results_sprite.opacity < 1
    end
    dispose_slot_machine_sprites
    return results
  end
  #--------------------------------------------------------------------------
  # * Slot Machine Results
  #--------------------------------------------------------------------------
  def slot_machine_results
    results = [0]
    sa = []
    # Calculate Slot Positions for Slot 1
    top_slot = @slot_array1[@slot_plane1.oy / 48 % @slot_possibilities]
    mid_slot = @slot_array1[(@slot_plane1.oy + 48) / 48 % @slot_possibilities]
    low_slot = @slot_array1[(@slot_plane1.oy + 96) / 48 % @slot_possibilities]
    sa.push(top_slot, mid_slot, low_slot)
    # Calculate Slot Positions for Slot 2
    top_slot = @slot_array2[@slot_plane2.oy / 48 % @slot_possibilities]
    mid_slot = @slot_array2[(@slot_plane2.oy + 48) / 48 % @slot_possibilities]
    low_slot = @slot_array2[(@slot_plane2.oy + 96) / 48 % @slot_possibilities]
    sa.push(top_slot, mid_slot, low_slot)
    # Calculate Slot Positions for Slot 3
    top_slot = @slot_array3[@slot_plane3.oy / 48 % @slot_possibilities]
    mid_slot = @slot_array3[(@slot_plane3.oy + 48) / 48 % @slot_possibilities]
    low_slot = @slot_array3[(@slot_plane3.oy + 96) / 48 % @slot_possibilities]
    sa.push(top_slot, mid_slot, low_slot)
    # Push matches to results
    for i in 1..@slot_possibilities
      results.push(i) if sa[0] == i and sa[0] == sa[3] and sa[0] == sa[6]
      results.push(i) if sa[0] == i and sa[0] == sa[4] and sa[0] == sa[8]
      results.push(i) if sa[1] == i and sa[1] == sa[4] and sa[1] == sa[7]
      results.push(i) if sa[2] == i and sa[2] == sa[4] and sa[2] == sa[6]
      results.push(i) if sa[2] == i and sa[2] == sa[5] and sa[2] == sa[8]
    end
    return results.max
  end
end
end

#==============================================================================
# ** Game_Interpreter
#==============================================================================
 
class Game_Interpreter
  #--------------------------------------------------------------------------
  # * Slot Machine Game
  #--------------------------------------------------------------------------
  def slot_machine(possibilities = SSS::SLOT_ICONS.size, speed = 5)
    return 0 unless $scene.is_a?(Scene_Map) or $scene.is_a?(Scene_Battle)
    return $scene.slot_machine(possibilities, speed)
  end
end
 
#==============================================================================
# ** Spriteset_Map
#==============================================================================
 
class Spriteset_Map
  include SSS::SPRITESET
  #--------------------------------------------------------------------------
  # * Dispose
  #--------------------------------------------------------------------------
  alias dispose_sss_spriteset_map_slots dispose unless $@
  def dispose
    dispose_sss_spriteset_map_slots
    dispose_slot_machine_sprites
  end
end
 
#==============================================================================
# ** Spriteset_Battle
#==============================================================================
 
class Spriteset_Battle
  include SSS::SPRITESET
  #--------------------------------------------------------------------------
  # * Dispose
  #--------------------------------------------------------------------------
  alias dispose_sss_spriteset_battle_slots dispose unless $@
  def dispose
    dispose_sss_spriteset_battle_slots
    dispose_slot_machine_sprites
  end
end
 
#==============================================================================
# ** Scene_Map
#==============================================================================
 
class Scene_Map < Scene_Base
  #--------------------------------------------------------------------------
  # * Public Instance Variables
  #--------------------------------------------------------------------------
  attr_accessor :spriteset
  #--------------------------------------------------------------------------
  # * Slot Machine
  #--------------------------------------------------------------------------
  def slot_machine(possibilities = SSS::SLOT_ICONS.size, speed = 5)
    @spriteset.slot_machine(possibilities, speed)
    loop do
      update_basic
      @spriteset.update_slot_machine
      break if @spriteset.slot_machine_stopped
    end
    return @spriteset.finish_slot_machine
  end
end
 
#==============================================================================
# ** Scene_Battle
#==============================================================================
 
class Scene_Battle < Scene_Base
  #--------------------------------------------------------------------------
  # * Public Instance Variables
  #--------------------------------------------------------------------------
  attr_accessor :spriteset
  #--------------------------------------------------------------------------
  # * Slot Machine
  #--------------------------------------------------------------------------
  def slot_machine(possibilities = SSS::SLOT_ICONS.size, speed = 5)
    @spriteset.slot_machine(possibilities, speed)
    loop do
      update_basic
      @spriteset.update_slot_machine
      break if @spriteset.slot_machine_stopped
    end
    return @spriteset.finish_slot_machine
  end
end

#===============================================================================
# 
# END OF FILE
# 
#===============================================================================
