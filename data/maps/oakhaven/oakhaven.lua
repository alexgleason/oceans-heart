-- Lua script of map oakhaven/oakhaven.
-- This script is executed every time the hero enters this map.

-- Feel free to modify the code below.
-- You can add more events and remove the ones you don't need.

-- See the Solarus Lua API documentation:
-- http://www.solarus-games.org/doc/latest

local map = ...
local game = map:get_game()
local hero = map:get_hero()

-- Event called at initialization time, as soon as this map becomes is loaded.
function map:on_started()
  if game:get_value("hazel_is_here") == true then cervio:set_enabled(false) end
  if game:get_value("salamander_heartache_storehouse_door_open") ~= nil then bar_storehouse_door:set_enabled(false) end
  if game:get_value("oakhaven_aubrey_unlocked") == true then
    aubrey_door_npc:set_enabled(false)
    aubrey_door:set_enabled(false)
  end


end



--NPCS---------------------

function grover:on_interaction()
  if game:get_value("grover_counter") == nil then
    game:start_dialog("_oakhaven.npcs.market.grover.1")
    game:set_value("grover_counter", 1)
  elseif game:get_value("grover_counter") == 1 then
    game:start_dialog("_oakhaven.npcs.market.grover.2")
  elseif game:get_value("grover_counter") == 2 then
    game:start_dialog("_oakhaven.npcs.market.grover.3")
  elseif game:get_value("grover_counter") == 3 then
    game:start_dialog("_oakhaven.npcs.market.grover.4")
  end
end

function palace_guard:on_interaction()
  local _, hero_x, _ = hero:get_position()
  if hero_x < 376 then
    game:start_dialog("_oakhaven.npcs.guards.town.palace_displacement")
    palace_guard:get_sprite():set_direction(0)
    hero:teleport("oakhaven/oakhaven", "palace_ejection")

  else
    game:start_dialog("_oakhaven.npcs.guards.town.palace")
  end
end



function wishing_well:on_interaction()
  if game:get_value("oakhaven_wishing_well_balance") == nil then game:set_value("oakhaven_wishing_well_balance", 0) end
  game:start_dialog("_oakhaven.npcs.misc.wishing_well.1", function(answer)
    if answer == 2 then
      --if you have enough money
      if game:get_money() >= 5 then
        game:remove_money(5)
        sol.audio.play_sound("splash")
        initial_money = game:get_value("oakhaven_wishing_well_balance")
        game:set_value("oakhaven_wishing_well_balance", initial_money + 5)

        --now check if that was enough money finally
        if initial_money == 195 then
          hero:start_treasure("coral_ore")
        end        
      --if you don't have enough money
      else
        game:start_dialog("_game.insufficient_funds")
      end
    end
  end)
end


--FRUIT IMPORTER
function fruit_importer:on_interaction()
  if game:get_value("oakhaven_fruit_importer_counter") == nil then
    game:start_dialog("_oakhaven.npcs.market.fruit_importer.1")

  --on the hunt for aubrey
  elseif game:get_value("oakhaven_fruit_importer_counter") == 1 then
    game:start_dialog("_oakhaven.npcs.market.fruit_importer.2")
    game:set_value("oakhaven_have_oranges_box", true)
    game:set_value("oakhaven_fruit_importer_counter", 2)

  --have oranges, but not aubrey
  elseif game:get_value("oakhaven_fruit_importer_counter") == 2 then
    game:start_dialog("_oakhaven.npcs.market.fruit_importer.3")


  end
end

--Aubrey the Orange Thief
function aubrey_door_npc:on_interaction()
  --if you don't have the oranges yet
  if game:get_value("oakhaven_have_oranges_box") ~= true then
    game:start_dialog("_oakhaven.npcs.misc.aubrey_door")
  else
    game:start_dialog("_oakhaven.npcs.misc.aubrey_door_2", function()
      aubrey_door_npc:set_enabled(false)
      aubrey_door:set_enabled(false)
      game:set_value("oakhaven_aubrey_unlocked", true)
    end)

  end

end


---------------------------


--intro cutscene
function remember_sensor:on_activated()
  if game:get_value("hazel_is_here") ~= true then
    game:start_dialog("_generic_dialogs.hey")
    hero:freeze()
    local m = sol.movement.create("path")
    m:set_path{0}
    m:start(hero)
    hero:set_direction(0)
    function m:on_finished()
      game:start_dialog("_oakhaven.npcs.port.cervio.1", function()
        sol.audio.play_sound("quest_log")
        game:start_dialog("_game.quest_log_update") end)
      game:set_value("quest_log_a", "a9")
      hero:unfreeze() end
    game:set_value("hazel_is_here", true)
  end
end