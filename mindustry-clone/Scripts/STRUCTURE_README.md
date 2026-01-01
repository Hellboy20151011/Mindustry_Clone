# Scripts Folder Structure

This document describes the organized structure of the Scripts folder and the purpose of each directory.

## Directory Structure

```
Scripts/
├── Player/          # Player-related components and systems
├── Weapons/         # Weapon system and projectiles
├── Resources/       # Resource types and resource nodes
├── UI/              # User interface scripts (HUD, menus overlays)
├── Menus/           # Menu scenes scripts (main menu, settings, etc.)
└── Core/            # Core game systems and managers (future)
```

## Folder Descriptions

### Player/
Contains all player-related scripts using a component-based architecture:
- `player.gd` - Main player controller (delegates to components)
- `PlayerMovement.gd` - Handles movement and physics
- `PlayerCamera.gd` - Manages camera and zoom
- `PlayerInventory.gd` - Resource inventory system
- `PlayerMining.gd` - Resource gathering logic
- `PlayerStats.gd` - Health, shield, and other stats
- `PLAYER_README.md` - Detailed player system documentation

**Key Features:**
- Modular component-based design
- Each component handles one responsibility
- Easy to extend and maintain
- Reusable components

### Weapons/
Weapon system using data-driven design with Resources:
- `Weapon_Controller.gd` - Controls weapon firing
- `WeaponData.gd` - Weapon properties (Resource)
- `WeaponUpgrade.gd` - Weapon upgrade definitions (Resource)
- `Projectile.gd` - Projectile behavior
- `WEAPONS_README.md` - Detailed weapons documentation

**Key Features:**
- Data-driven weapon configuration
- Easy weapon balancing via resources
- Support for multiple projectiles per shot
- Built-in upgrade system

### Resources/
Resource management system:
- `resource_types.gd` - Enum and utilities for resource types
- `resource_node.gd` - Harvestable resource nodes in the world

**Available Resources:**
- Stone
- Wood
- Coal
- Iron

### UI/
User interface components:
- `hud.gd` - In-game HUD displaying resources and stats

**HUD Displays:**
- Resource counts (stone, wood, coal, iron)
- Player health and shield
- Movement speed
- Build speed

### Menus/
Game menu screens:
- `main_menu.gd` - Main menu screen
- `settings.gd` - Settings/options menu
- `world_selection.gd` - World/map selection menu

**Menu Navigation:**
- Main Menu → World Selection → Game
- Main Menu → Settings
- Settings → Back to Main Menu

### Core/ (Future)
Reserved for core game systems:
- Game managers (GameManager, SaveManager, etc.)
- Autoload singletons
- Global utilities
- Event bus systems

## Design Principles

### 1. Component-Based Architecture
The player system demonstrates component-based design where functionality is split into reusable, independent components rather than monolithic scripts.

**Benefits:**
- Better code organization
- Easier testing and debugging
- Improved reusability
- Clearer separation of concerns

### 2. Data-Driven Design
The weapon system uses Resources to store data separately from code, allowing for easy balancing and modification without code changes.

**Benefits:**
- Non-programmers can balance weapons
- Easy to create variants
- Hot-reloadable in editor
- Version control friendly

### 3. Signal-Based Communication
Components communicate through signals rather than tight coupling.

**Benefits:**
- Loose coupling between systems
- Easy to add/remove listeners
- Decoupled architecture
- Better testability

## Best Practices

### Naming Conventions
- **Files**: Use PascalCase for class files (e.g., `PlayerMovement.gd`)
- **Folders**: Use PascalCase for folder names
- **Variables**: Use snake_case for variables
- **Constants**: Use SCREAMING_SNAKE_CASE

### Script Organization
- Keep scripts small and focused (Single Responsibility Principle)
- Use components for complex entities
- Put related scripts in the same folder
- Document complex systems with README files

### Resource Usage
- Use Resources for data that varies between instances
- Create `.tres` files in appropriate folders (e.g., weapon data in Actors/)
- Prefer exported properties on Resource scripts

## Migration from Old Structure

The old flat structure in `Scripts/` has been reorganized into logical folders:

**Old → New:**
- `player.gd` → `Player/player.gd` (refactored into components)
- `Weapon_Controller.gd` → `Weapons/Weapon_Controller.gd`
- `WeaponData.gd` → `Weapons/WeaponData.gd`
- `WeaponUpgrade.gd` → `Weapons/WeaponUpgrade.gd`
- `Projectile.gd` → `Weapons/Projectile.gd`
- `resource_node.gd` → `Resources/resource_node.gd`
- `resource_types.gd` → `Resources/resource_types.gd`
- `main_menu.gd` → `Menus/main_menu.gd`
- `settings.gd` → `Menus/settings.gd`
- `world_selection.gd` → `Menus/world_selection.gd`
- `Actors/hud.gd` → `UI/hud.gd`

All scene references have been updated to reflect the new paths.

## Adding New Systems

When adding a new system to the game:

1. **Determine the category**: Does it fit in an existing folder?
2. **Create a new folder if needed**: For major new systems
3. **Follow component pattern**: Break complex systems into components
4. **Add documentation**: Create a README for complex systems
5. **Update this file**: Document the new folder structure

## See Also

- [Player System Documentation](Player/PLAYER_README.md)
- [Weapon System Documentation](Weapons/WEAPONS_README.md)
- [Root README](../../README.md)
