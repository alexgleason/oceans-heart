local item = ...
local game = item:get_game()

function item:on_started()
  item:set_savegame_variable("possession_ghost_orchid")
  item:set_amount_savegame_variable("amount_ghost_orchid")
end

function item:on_obtained()
  local amounts = {1, 3, 5}
  local amount = amounts[variant]
  if amount == nil then
    error("Invalid variant '" .. variant .. "' for item")
  end
  self:add_amount(amount)

end

-- Event called when a pickable treasure representing this item
-- is created on the map.
-- You can set a particular movement here if you don't like the default one.
function item:on_pickable_created(pickable)


end