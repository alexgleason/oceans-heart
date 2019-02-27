-- Lua script of map Yarrowmouth/interiors/nina.
-- This script is executed every time the hero enters this map.

-- Feel free to modify the code below.
-- You can add more events and remove the ones you don't need.

-- See the Solarus Lua API documentation:
-- http://www.solarus-games.org/doc/latest

local map = ...
local game = map:get_game()

-- Event called at initialization time, as soon as this map becomes is loaded.
function map:on_started()

  -- You can initialize the movement and sprites of various
  -- map entities here.
end





function nina:on_interaction()
  --first conversation
  if game:get_value("nina_dialog_counter") == nil then
    game:start_dialog("_yarrowmouth.npcs.nina.1", function(answer)
      if answer == 3 then
        game:start_dialog("_yarrowmouth.npcs.nina.2", function()
          game:set_value("quest_yarrow_parley", 0) --quest log, started quest
          game:set_value("nina_dialog_counter", 1)
          game:set_value("going_to_meet_carlov_pirates", true)
        end)

      elseif answer == 4 then
        game:start_dialog("_yarrowmouth.npcs.nina.3")
      end
    end)

  elseif game:get_value("nina_dialog_counter") == 1 then
    game:start_dialog("_yarrowmouth.npcs.nina.4") --says you're supposed to meet at seaweed rock

  elseif game:get_value("nina_dialog_counter") == 2 then
    game:start_dialog("_yarrowmouth.npcs.nina.5", function()  --go to ballast harbor to finish them
      game:set_value("quest_yarrow_parley", 3) --quest log
      game:set_value("nina_dialog_counter", 3)
    end)

  elseif game:get_value("nina_dialog_counter") == 3 then
    game:start_dialog("_yarrowmouth.npcs.nina.6") --directions of ballast

  elseif game:get_value("nina_dialog_counter") == 4 then
    game:start_dialog("_yarrowmouth.npcs.nina.7", function() --successful mission
      game:set_value("quest_yarrow_parley", 5) --quest log, finshed quest
      game:add_money(120)
      game:set_value("nina_dialog_counter", 5)
    end)

  elseif game:get_value("nina_dialog_counter") == 5 then
    game:start_dialog("_yarrowmouth.npcs.nina.8") --thanks for helping

  end

end