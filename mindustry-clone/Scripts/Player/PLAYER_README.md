# Player System Documentation

## Overview
The player system uses a component-based architecture for better modularity and maintainability. Each aspect of player functionality is separated into its own component.

## Architecture

### Core Components

#### 1. player.gd (Main Controller)
Located: `Scripts/Player/player.gd`

The main player controller that:
- Extends CharacterBody2D for physics
- Manages references to all components
- Forwards signals from components
- Provides public API for external systems
- Delegates all functionality to specialized components

**Key Methods:**
- `get_inventory()`: Returns player inventory
- `take_damage(amount)`: Apply damage to player
- `heal(amount)`: Restore health
- `restore_shield(amount)`: Restore shield
- `get_stats()`: Get all player statistics

#### 2. PlayerMovement
Located: `Scripts/Player/PlayerMovement.gd`

Handles all player movement:
- WASD/Arrow key input
- Acceleration and friction
- Speed management
- Physics integration

**Exported Properties:**
- `max_speed`: Maximum movement speed (default: 280.0)
- `acceleration`: How fast player reaches max speed (default: 1400.0)
- `friction`: How fast player stops (default: 900.0)

#### 3. PlayerCamera
Located: `Scripts/Player/PlayerCamera.gd`

Manages camera behavior:
- Rotation towards mouse
- Zoom in/out with mouse wheel
- Smooth zoom transitions
- Camera positioning

**Exported Properties:**
- `rotate_to_mouse`: Whether player rotates to face mouse (default: true)
- `zoom_min`: Minimum zoom level (default: 0.5)
- `zoom_max`: Maximum zoom level (default: 1.4)
- `zoom_step`: Zoom increment per scroll (default: 0.1)
- `zoom_lerp_speed`: Speed of zoom smoothing (default: 10.0)
- `initial_zoom`: Starting zoom level (default: 0.8)

#### 4. PlayerInventory
Located: `Scripts/Player/PlayerInventory.gd`

Manages player resources:
- Resource storage (stone, wood, coal, iron)
- Fractional resource accumulation
- Inventory change signals

**Signals:**
- `inventory_changed(key: String, new_value: int)`: Emitted when resource count changes

**Methods:**
- `add_resource_fractional(key, amount)`: Add fractional resources (for mining)
- `add_resource(key, amount)`: Add whole resources
- `remove_resource(key, amount)`: Remove resources (returns bool for success)
- `get_resource_count(key)`: Get count of specific resource
- `get_inventory()`: Get full inventory dictionary

#### 5. PlayerMining
Located: `Scripts/Player/PlayerMining.gd`

Handles resource gathering:
- Detects nearby resource nodes
- Processes mining action
- Validates mineable resources
- Calculates harvest rates

**Exported Properties:**
- `enable_mining`: Toggle mining system (default: true)

**Mineable Resources:**
- Stone
- Wood
- Coal
(Iron requires special tools - future feature)

#### 6. PlayerStats
Located: `Scripts/Player/PlayerStats.gd`

Manages player statistics:
- Health and shield system
- Damage calculation (shield absorbs first)
- Death detection
- Stat queries

**Exported Properties:**
- `max_health`: Maximum health (default: 100.0)
- `max_shield`: Maximum shield (default: 50.0)
- `build_speed`: Building speed multiplier (default: 1.0)

**Signals:**
- `health_changed(current, maximum)`: Emitted when health changes
- `shield_changed(current, maximum)`: Emitted when shield changes

**Methods:**
- `take_damage(amount)`: Apply damage (shield first, then health)
- `heal(amount)`: Restore health
- `restore_shield(amount)`: Restore shield
- `get_stats()`: Get all stat values

## Component Communication

Components communicate through:
1. **Signals**: Components emit signals that the main controller forwards
2. **Direct References**: Components can access siblings when needed
3. **Parent Access**: Components can call parent methods for coordination

## Input Actions

- `move_up`: Move up (W, Up Arrow)
- `move_down`: Move down (S, Down Arrow)
- `move_left`: Move left (A, Left Arrow)
- `move_right`: Move right (D, Right Arrow)
- `mine`: Mine resources (E, Right Mouse Button)
- `zoom_in`: Zoom in (Mouse Wheel Up)
- `zoom_out`: Zoom out (Mouse Wheel Down)

## Setup in Scene

The Player scene (`Actors/Player.tscn`) contains:
```
Player (CharacterBody2D)
├── PlayerMovement (Node)
├── PlayerCamera (Node)
├── PlayerInventory (Node)
├── PlayerMining (Node)
├── PlayerStats (Node)
├── WeaponPivot (Node2D)
├── Camera2D
├── Interact_Area (Area2D)
└── CollisionShape2D
```

## Benefits of Component Architecture

1. **Modularity**: Each system is independent and testable
2. **Reusability**: Components can be used on other entities
3. **Maintainability**: Easy to find and modify specific functionality
4. **Extensibility**: Add new components without modifying existing ones
5. **Clean Code**: Smaller, focused files instead of one large player script
6. **Performance**: Can disable components individually if needed

## Adding New Components

To add a new player component:

1. Create a new script in `Scripts/Player/`
2. Extend Node and add `class_name YourComponent`
3. Add component-specific logic
4. Add the component as a child node in Player.tscn
5. Add `@onready var your_component: YourComponent = $YourComponent` in player.gd
6. Call component methods in appropriate lifecycle functions

## Example: Using the Player API

```gdscript
# Get player reference
var player = get_tree().get_first_node_in_group("Player")

# Check inventory
var stone_count = player.get_inventory()["stone"]

# Apply damage
player.take_damage(25.0)

# Heal player
player.heal(50.0)

# Get all stats
var stats = player.get_stats()
print("Health: ", stats["current_health"], "/", stats["max_health"])
print("Speed: ", stats["max_speed"])
```

## Future Enhancements

- [ ] Add stamina system for sprinting
- [ ] Implement experience/leveling system
- [ ] Add equipment/armor system
- [ ] Create skill tree system
- [ ] Add status effects (poison, slow, etc.)
- [ ] Implement dash/dodge ability
- [ ] Add multiplayer synchronization
