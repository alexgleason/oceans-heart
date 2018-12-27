-- Lua script of map goatshead_island/interiors/squid_house.
-- This script is executed every time the hero enters this map.

-- Feel free to modify the code below.
-- You can add more events and remove the ones you don't need.

-- See the Solarus Lua API documentation:
-- http://www.solarus-games.org/doc/latest

local map = ...
local game = map:get_game()


function map:on_started()
  map:open_doors("front_door")

--enable characters
  aster_enemy:set_enabled(false)
  if game:get_value("barbell_brutes_defeated") ~= true then
    aster_2:set_enabled(false)
  else
    aster:set_enabled(false)
  end
if game:get_value("aster_murdered") == true then
  aster:set_enabled(false)
  aster_2:set_enabled(false)

end

end


--discover he's the squid
function secret_switch:on_interaction()
  if game:get_value("accepted_merchant_guild_contracts_quest") ~= true
  and game:get_value("aster_house_pressed_sesecret_switch") ~= true then
    game:set_value("aster_house_pressed_sesecret_switch", true)
    map:open_doors("secret_squid_head_door")
    sol.audio.play_sound("switch")
    --dialog and decide sides
    game:start_dialog("_goatshead.npcs.phantom_squid.3", function(answer)

      --side with Aster
      if answer == 2 then
      game:set_value("quest_phantom_squid", 3) --quest log, finish hunt squid quest
        --if you already have the contract
        if game:has_item("contract") == true then
          game:start_dialog("_goatshead.npcs.phantom_squid.5andahalf", function()
            game:set_value("quest_phantom_squid_contracts", 2) --quest log, start part 2 of quest
            game:set_value("accepted_merchant_guild_contracts_quest", true)
            game:set_value("talked_to_eamon", 2)
            game:set_value("goatshead_harbor_footprints_visible", false)            
          end)
        --or if you didn't already find the contract:
        else
          game:start_dialog("_goatshead.npcs.phantom_squid.5", function()
            game:set_value("quest_phantom_squid_contracts", 0) --quest log, start part 2 of quest
            game:set_value("accepted_merchant_guild_contracts_quest", true)
            game:set_value("talked_to_eamon", 2)
            game:set_value("goatshead_harbor_footprints_visible", false)
          end)
        end

      --side with Eamon
      else
        game:start_dialog("_goatshead.npcs.phantom_squid.4", function()
          aster:set_enabled(false)
          aster_enemy:set_enabled(true)
          map:close_doors("front_door")
          game:set_value("goatshead_harbor_footprints_visible", false)
          game:set_value("quest_phantom_squid", 2) --quest log, return to Eamon
        end)

      end
    end)
  end
end

--Aster, before beating barbell brutes.
function aster:on_interaction()
  if game:get_value("accepted_merchant_guild_contracts_quest") ~= true then
    game:start_dialog("_goatshead.npcs.phantom_squid.2")
  else
    --see if you have the contract yet
    if game:has_item("contract") ~= true then
      --don't have contract
      game:start_dialog("_goatshead.npcs.phantom_squid.6")
    else
      --have contract
      --have you already had this conversation?
      if game:get_value("accepted_barbell_brute_quest") ~= true then
        game:start_dialog("_goatshead.npcs.phantom_squid.7")
        game:set_value("accepted_barbell_brute_quest", true)
      else
        game:start_dialog("_goatshead.npcs.phantom_squid.8")
      end

    end

  end
end


--Aster, after beating barbell brutes.
function aster_2:on_interaction()
  if game:get_value("phantom_squid_quest_completed") ~= true then
    game:start_dialog("_goatshead.npcs.phantom_squid.9", function() game:add_money(200) end)
    game:set_value("phantom_squid_quest_completed", true)
  else
    game:start_dialog("_goatshead.npcs.phantom_squid.10")
  end
end



function aster_enemy:on_dead()
  map:open_doors("front_door")
  game:set_value("aster_murdered", true)
end