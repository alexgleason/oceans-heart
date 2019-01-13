local enemy = ...

function enemy:on_created()
  sprite = enemy:create_sprite("enemies/" .. enemy:get_breed())
  enemy:set_life(1)
  enemy:set_damage(4)
  enemy:set_origin(4, 4)
  enemy:set_obstacle_behavior("flying")
  enemy:set_can_hurt_hero_running(true)
  enemy:set_invincible()
  enemy:set_attack_consequence("sword", function() enemy:remove() end)
end


function enemy:go(direction)
  local movement = sol.movement.create("straight")
  movement:set_speed(100)
  movement:set_angle(direction)
  movement:set_smooth(false)
  movement:start(enemy)

  function movement:on_obstacle_reached()
      enemy:remove()
  end
end


-- Destroy the fireball when the hero is touched.
function enemy:on_attacking_hero(hero, enemy_sprite)
  hero:start_hurt(enemy, enemy_sprite, enemy:get_damage())
  enemy:remove()
end