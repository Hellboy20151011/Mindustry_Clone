# Weapon System Documentation

## Overview
The weapon system in Mindustry Clone provides a flexible and data-driven approach to weapon management, projectiles, and upgrades.

## Architecture

### Core Components

#### 1. WeaponData (Resource)
Located: `Scripts/Weapons/WeaponData.gd`

A Resource class that defines weapon properties:
- `weapon_id`: Unique identifier for the weapon
- `projectile_scene`: PackedScene for the projectile to spawn
- `damage`: Base damage per projectile
- `fire_rate`: Shots per second
- `projectile_speed`: Speed of projectiles
- `spread_deg`: Spread angle in degrees
- `shots_per_trigger`: Number of projectiles per shot (for shotgun-like weapons)
- `energy_cost`: Energy cost per shot (future feature)

**Usage:** Create WeaponData resources in the Godot editor as `.tres` files (e.g., `pistol.tres`).

#### 2. Weapon_Controller (Node2D)
Located: `Scripts/Weapons/Weapon_Controller.gd`

Controls weapon firing and projectile spawning:
- Rotates towards mouse position
- Handles cooldown between shots
- Spawns projectiles with spread calculation
- Manages fire rate timing

**Usage:** Attach to a weapon pivot node on the player or entity.

#### 3. Projectile (Area2D)
Located: `Scripts/Weapons/Projectile.gd`

Represents a single projectile in flight:
- Moves in a straight line
- Has lifetime limit
- Carries damage value
- Auto-destroys after lifetime expires

**Setup:** Called via `setup(direction, speed, damage, life)` method.

#### 4. WeaponUpgrade (Resource)
Located: `Scripts/Weapons/WeaponUpgrade.gd`

Defines weapon upgrade modifications:
- `upgrade_id`: Unique identifier
- `add_damage`: Additional damage bonus
- `add_fire_rate`: Fire rate bonus
- `add_shots_per_trigger`: Extra projectiles per shot
- `add_spread_deg`: Spread modification
- `mul_projectile_speed`: Speed multiplier

**Usage:** Create upgrade resources that can be applied to weapons.

## Creating a New Weapon

1. **Create a WeaponData resource:**
   - Right-click in FileSystem → New Resource → WeaponData
   - Set properties (damage, fire_rate, etc.)
   - Assign the Projectile scene (`res://Actors/Projectiles.tscn`)
   - Save as `.tres` file (e.g., `rifle.tres`)

2. **Assign to Weapon_Controller:**
   - Select the WeaponPivot node in your character scene
   - In Inspector, set `weapon_data` to your new WeaponData resource

3. **Customize projectile appearance (optional):**
   - Open `Actors/Projectiles.tscn`
   - Modify the Sprite2D texture
   - Or create a variant scene for different projectile types

## Weapon Examples

### Pistol (Default)
```gdscript
weapon_id = "pistol"
damage = 10
fire_rate = 6.0  # 6 shots per second
projectile_speed = 900.0
spread_deg = 0.0
shots_per_trigger = 1
```

### Shotgun (Example)
```gdscript
weapon_id = "shotgun"
damage = 8
fire_rate = 2.0  # 2 shots per second
projectile_speed = 700.0
spread_deg = 30.0  # 30 degree spread
shots_per_trigger = 5  # 5 pellets per shot
```

### Machine Gun (Example)
```gdscript
weapon_id = "machine_gun"
damage = 5
fire_rate = 15.0  # 15 shots per second
projectile_speed = 1000.0
spread_deg = 5.0  # slight spread
shots_per_trigger = 1
```

## Key Features

- **Data-driven design:** All weapon properties defined in resources
- **Easy balancing:** Adjust weapon stats without touching code
- **Projectile pooling ready:** System designed for future optimization
- **Upgrade system:** Built-in support for weapon modifications
- **Spread calculation:** Automatic distribution of multiple projectiles

## Input Actions

- `shoot`: Fire weapon (default: Left Mouse Button)

## Future Enhancements

- [ ] Implement energy/ammo system using `energy_cost`
- [ ] Add weapon switching system
- [ ] Implement upgrade application system
- [ ] Add hit detection and damage dealing
- [ ] Add muzzle flash effects
- [ ] Add sound effects for shooting
- [ ] Implement projectile collision and impact effects
- [ ] Add different projectile types (explosive, piercing, etc.)
