-- The bow has two variants: without arrows or with arrows.
-- This is necessary to allow it to have different icons in both cases.
-- Therefore, the silver bow is implemented as another item (bow_silver),
-- and calls code from this bow.
-- It could be simpler if it was possible to change the icon of items dynamically.

-- Max addendum: I'm going to try to have fire arrows and warp arrows not as different items,
-- but as variables possession_fire_arrows and possession_warp_arrows, and just have
-- entities that would be effected in each case check when they're fit. Then a separate
-- bow_damage will allow the arrows to become more powerful independently.


local item = ...
local game = item:get_game()

function item:on_created()

  item:set_savegame_variable("possession_bow")
  item:set_amount_savegame_variable("amount_bow")
  item:set_assignable(true)
end
function item:on_started()
  item:set_max_amount(100)
end

-- set to item slot 1
function item:on_obtained()
  game:set_value("bow_damage", 1)
  self:add_amount(20)
end


-- Using the bow.
-- This function can also be called by the silver bow.
function item:on_using()

  -- item is the normal bow, self is the normal or the silver one.

  local map = game:get_map()
  local hero = map:get_hero()

  if self:get_amount() == 0 then
    sol.audio.play_sound("no")
    self:set_finished()
  else
    hero:set_animation("bow")

    sol.timer.start(map, 290, function()
    sol.audio.play_sound("bow")
      self:remove_amount(1)
      self:set_finished()


       local x, y = hero:get_center_position()
       local _, _, layer = hero:get_position()
       local arrow = map:create_custom_entity({
         x = x,
         y = y,
         layer = layer,
         width = 16,
         height = 16,
         direction = hero:get_direction(),
         model = "arrow",
       })


      arrow:set_force(self:get_force())
      arrow:set_sprite_id(self:get_arrow_sprite_id())
      arrow:go()

    end)
  end
end


function item:get_force()

  return 2
end


-- Set the sprite for the arrow entity

function item:get_arrow_sprite_id()
     return "entities/arrow"

end

---------------------------------------------------------------------------------------------

--
-- Initialize the metatable of appropriate entities to work with custom arrows.
local function initialize_meta()

  -- Add Lua arrow properties to enemies.
  local enemy_meta = sol.main.get_metatable("enemy")
  if enemy_meta.get_arrow_reaction ~= nil then
    -- Already done.
    return
  end

  enemy_meta.arrow_reaction = "force"
  enemy_meta.arrow_reaction_sprite = {}
  function enemy_meta:get_arrow_reaction(sprite)

    if sprite ~= nil and self.arrow_reaction_sprite[sprite] ~= nil then
      return self.arrow_reaction_sprite[sprite]
    end

    if self.arrow_reaction == "force" then
      -- Replace by the current force value.
      local game = self:get_game()
      if game:has_item("bow_silver") then
        return game:get_item("bow_silver"):get_force()
      end
      return game:get_item("bow"):get_force()
    end

    return self.arrow_reaction
  end

  function enemy_meta:set_arrow_reaction(reaction, sprite)

    self.arrow_reaction = reaction
  end

  function enemy_meta:set_arrow_reaction_sprite(sprite, reaction)

    self.arrow_reaction_sprite[sprite] = reaction
  end

  -- Change the default enemy:set_invincible() to also
  -- take into account arrows.
  local previous_set_invincible = enemy_meta.set_invincible
  function enemy_meta:set_invincible()
    previous_set_invincible(self)
    self:set_arrow_reaction("ignored")
  end
  local previous_set_invincible_sprite = enemy_meta.set_invincible_sprite
  function enemy_meta:set_invincible_sprite(sprite)
    previous_set_invincible_sprite(self, sprite)
    self:set_arrow_reaction_sprite(sprite, "ignored")
  end
end

function game:get_arrow_force()

  if game:has_item("bow_silver") then
    return game:get_item("bow_silver"):get_force()
  end
  return game:get_item("bow"):get_force()
end

initialize_meta()

--]]