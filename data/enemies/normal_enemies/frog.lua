local enemy = ...

local properties_setter = require("enemies/lib/properties_setter")
local behavior = require("enemies/lib/ranged_attacker")

local properties = {
  sprite = "enemies/" .. enemy:get_breed(),
  life = 15,
  damage = 8,
  normal_speed = 15,
  faster_speed = 17,
  detection_distance = 125,
  projectile_breed = "misc/energy_ball_split",
  projectile_angle = "any",
  projectile_damage = 2,
  projectile_split_children = 8,
}

properties_setter:set_properties(enemy, properties)
behavior:create(enemy, properties)