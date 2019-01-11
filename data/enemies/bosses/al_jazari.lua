local enemy = ...

local properties_setter = require("enemies/lib/properties_setter")
local behavior = require("enemies/lib/general_enemy")

local properties = {
  sprite = "enemies/bosses/jazari",
  hurt_style = "boss",
  life = 35,
  damage = 10,
  normal_speed = 15,
  faster_speed = 60,
  wind_up_time = 500,
  has_melee_attack = true,
  melee_distance = 70,
  melee_attack_cooldown = 1800,
  melee_attack_sound = "sword2",
  attack_sprites = {"enemies/misc/sword_slash"},
  has_summon_attack = true,
  summon_attack_distance = 200,
  summon_attack_cooldown = 9000,
  summon_attack_wind_up_time = 1000,
  summoning_sound = "cane",
  summon_breed = "misc/steam_attack",
  summon_group_size = 4,
  summon_group_delay = 1000,
  protected_while_summoning = true,
  must_be_aligned_to_attack = false,
  push_hero_on_sword = false,
  pushed_when_hurt = false,

--these just for testing:
--has_ranged_attack, ranged_attack_distance, ranged_attack_cooldown, ranged_attack_sound, projectile_breed (enemy breed dat), projectile_angle
--optional properties for ranged attack are projectile_damage, projectile_split_children, and projectile_num_bounces
  has_ranged_attack = true,
  ranged_attack_distance = 170,
  ranged_attack_cooldown = 5000,
  ranged_attack_sound = "heart",
  projectile_breed = "misc/energy_ball_bounce",
  projectile_angle = "any",
--has_dash_attack, dash_attack_distance (hero distance threshold), dash_attack_cooldown,
    --dash_attack_direction ("any" or "straight"), dash_attack_length (how far the enemy will dash before stopping)
    --dash_attack_speed, dash_attack_wind_up, dash_attack_sound
  has_dash_attack = true,
  dash_attack_distance = 150,
  dash_attack_cooldown = 3000,
  dash_attack_direction = "target_hero",
  dash_attack_length = 96,
  dash_attack_speed = 120,
  dash_attack_wind_up = 600,
  dash_attack_sound = "running",
--has_orbit_attack, orbit_attack_distance, orbit_attack_cooldown, orbit_attack_sound, orbit_attack_num_projectiles
      --orbit_attack_charge_time, orbit_attack_shoot_delay, orbit_attack_projectile_breed, orbit_attack_radius
  has_orbit_attack = true,
  orbit_attack_distance = 190,
  orbit_attack_cooldown = 5000,
  orbit_attack_sound = "gravel",
  orbit_attack_num_projectiles = 4,
  orbit_attack_charge_time = 1000,
  orbit_attack_shoot_delay = 500,
  orbit_attack_projectile_breed = "misc/energy_ball_small",
  orbit_attack_radius = 16,
}

properties_setter:set_properties(enemy, properties)
behavior:create(enemy, properties)