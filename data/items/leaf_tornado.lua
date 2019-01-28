local item = ...
local game = item:get_game()

local MAGIC_COST = 85
local NUM_ATTACKS = 8

function item:on_started()
  item:set_savegame_variable("possession_leaf_tornado")
  item:set_assignable(true)
end

function item:on_obtaining()
  game:set_ability("sword", 1)
end

function item:on_using()
  if game:get_magic() < MAGIC_COST then sol.audio.play_sound("no") item:set_finished()
  else
    game:remove_magic(MAGIC_COST)
    local map = item:get_map()
    local hero = game:get_hero()
    local x, y, layer = hero:get_position()

    --charge for 500ms
  --  hero:freeze()
    local summoning_state = sol.state.create()
    summoning_state:set_can_control_movement(false)
    summoning_state:set_can_be_hurt(true)
    summoning_state:set_can_use_sword(false)
    summoning_state:set_can_use_item(false)
    summoning_state:set_can_interact(false)
    summoning_state:set_can_grab(false)
    summoning_state:set_can_pick_treasure(false)
    hero:start_state(summoning_state)

    hero:set_animation("charging")
    sol.audio.play_sound("charge_1")
    sol.timer.start(game, 800, function()
      --summon some stuff to hurt enemies
      local leaf_attacks = {}
      for i = 1, NUM_ATTACKS do
        sol.timer.start(game, 800/NUM_ATTACKS * i, function()
          leaf_attacks[i] = map:create_custom_entity{
            name = "leaf_attack",
            direction = 0,
            layer = layer,
            x = x,
            y = y,
            width = 16,
            height = 16,
            sprite = "entities/leaf_whirl_green",
            model = "damaging_sparkle"
          }
          leaf_attacks[i]:set_damage((game:get_value("sword_damage") * 1.5) or 10)
          local m = sol.movement.create("circle")
          m:set_center(hero)
          m:set_radius(8)
          m:set_radius_speed(80)
          m:set_max_rotations(2)
          m:set_angular_speed(7)
          m:start(leaf_attacks[i], function()
            leaf_attacks[i]:remove()
          end)
          m:set_radius(56)
        end)
      end

      sol.timer.start(game, 5000, function()
        for i=1,NUM_ATTACKS do
          if leaf_attacks[i] then
            leaf_attacks[i]:remove()
          end
        end
      end)

      hero:set_sword_sprite_id("hero/gust")
      hero:unfreeze()
      hero:start_attack()
      sol.audio.play_sound("sword_spin_attack_release")
      sol.audio.play_sound("thunk1")
      local sprite = hero:get_sprite()
      local animation = sprite:get_animation()
      function sprite:on_animation_finished()
        hero:set_sword_sprite_id("hero/sword1")
      end
      item:set_finished()


    end) --end of warmup timer callback
  end --end of if has enough magic
end


--  hero:set_sword_sprite_id("hero/sword2")
--  hero:set_sword_sprite_id("hero/sword1")
