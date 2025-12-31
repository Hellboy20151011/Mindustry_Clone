# Player Statistics Implementation

## Overview
This implementation adds player statistics to the Mindustry Clone game as requested in the issue.

## Added Features

### Player Statistics
The player now has the following statistics that can be configured in the Godot editor:

1. **Health Points (Lebenspunkte)**
   - `max_health`: Maximum health (default: 100.0)
   - `current_health`: Current health value
   - Displayed in HUD as "Health: X/Y"

2. **Shield (Schild)**
   - `max_shield`: Maximum shield (default: 50.0)
   - `current_shield`: Current shield value
   - Shields absorb damage before health
   - Displayed in HUD as "Shield: X/Y"

3. **Speed (Geschwindigkeit)**
   - `max_speed`: Maximum movement speed (default: 280.0)
   - Already existed in the game
   - Displayed in HUD as "Speed: X"

4. **Building Speed (Baugeschwindigkeit)**
   - `build_speed`: Multiplier for building actions (default: 1.0)
   - Can be used to make building faster/slower
   - Displayed in HUD as "Build Speed: X.Xx"

## Implementation Details

### Files Modified

1. **Scripts/player.gd**
   - Added new exported variables for stats (organized in groups)
   - Added signals: `health_changed`, `shield_changed`
   - Added stat management functions:
     - `take_damage(amount)`: Applies damage to shield first, then health
     - `heal(amount)`: Restores health
     - `restore_shield(amount)`: Restores shield
     - `get_stats()`: Returns dictionary of all stats
     - `_on_death()`: Called when health reaches 0 (placeholder)

2. **Actors/hud.gd**
   - Added references to new stat labels
   - Connected to player stat signals
   - Added update functions for real-time stat display
   - Displays initial stats on ready

3. **Actors/HUD.tscn**
   - Added new TopRightPanel for player stats
   - Added labels: HealthLabel, ShieldLabel, SpeedLabel, BuildSpeedLabel
   - Positioned in top-right corner of screen

## How to Use

### In the Editor
1. Open the Player scene (`Actors/Player.tscn`)
2. Select the Player node
3. In the Inspector, find "Player Stats" group
4. Adjust the values:
   - Max Health: 100.0
   - Max Shield: 50.0
   - Build Speed: 1.0

### In Code
You can interact with player stats programmatically:

```gdscript
# Get reference to player
var player = get_tree().get_first_node_in_group("Player")

# Deal damage
player.take_damage(25.0)  # Removes 25 shield/health

# Heal player
player.heal(50.0)  # Restores 50 health

# Restore shield
player.restore_shield(25.0)  # Restores 25 shield

# Get all stats
var stats = player.get_stats()
print("Health: ", stats.current_health, "/", stats.max_health)
```

## Testing the Implementation

### Manual Testing in Godot Editor
1. Open the project in Godot
2. Run the game (F5)
3. Observe the top-right panel showing player stats
4. Move around to verify speed stat is accurate
5. To test damage/healing, add temporary code in `_process()`:

```gdscript
# Add to player.gd _process() for testing
if Input.is_action_just_pressed("ui_page_down"):
    take_damage(10.0)
if Input.is_action_just_pressed("ui_page_up"):
    heal(10.0)
```

### Expected Results
- Player stats display in top-right corner
- Health shows 100/100 initially
- Shield shows 50/50 initially
- Speed shows 280
- Build Speed shows 1.0x
- Stats update in real-time when changed

## Future Enhancements
- Add health bar visualization
- Add shield regeneration over time
- Implement death/respawn system
- Add damage feedback (screen flash, sound)
- Link build_speed to actual building mechanics
- Add stat upgrades/power-ups
