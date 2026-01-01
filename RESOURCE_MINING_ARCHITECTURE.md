# Resource Mining System - Architektur Übersicht

## System-Diagramm

```
┌─────────────────────────────────────────────────────────────────┐
│                         RESOURCE MINING SYSTEM                   │
└─────────────────────────────────────────────────────────────────┘

┌──────────────────────┐
│   Player.tscn        │
│  (CharacterBody2D)   │
├──────────────────────┤
│ • PlayerMovement     │───┐
│ • PlayerCamera       │   │
│ • PlayerInventory    │◄──┼─── Signal: inventory_changed(key, value)
│ • PlayerMining       │   │
│ • PlayerStats        │   │
│ • Interact_Area      │◄──┼─── Radius: 80 pixels
└──────────────────────┘   │
          │                │
          │ process_mining │
          ▼                │
┌──────────────────────┐   │
│  PlayerMining.gd     │   │
├──────────────────────┤   │
│ enable_mining: bool  │   │
│ player_mineable: {}  │   │
│ _current_target      │   │
├──────────────────────┤   │
│ • _update_target()   │───┼─── Sucht ResourceNodes
│ • _try_mine()        │───┼─── Mining Logic
└──────────────────────┘   │
          │                │
          │ get_overlapping_areas()
          ▼                │
┌──────────────────────┐   │
│  ResourceNode.tscn   │   │
│    (Area2D)          │   │
├──────────────────────┤   │
│ resource_type: Enum  │◄──┼─── STONE, WOOD, COAL, IRON
│ harvest_per_second:  │   │
│     float = 4.0      │   │
│ required_tool: ""    │   │
├──────────────────────┤   │
│ • get_resource_key() │───┼─── Returns "stone", "wood", etc.
│ • [Gruppe fehlt!]    │   │     ⚠️ KRITISCH!
└──────────────────────┘   │
          │                │
          │ key + amount   │
          ▼                │
┌──────────────────────┐   │
│ PlayerInventory.gd   │   │
├──────────────────────┤   │
│ inventory: {}        │───┼─── {"stone": 0, "wood": 0, ...}
│ _fraction_buffer: {} │   │
├──────────────────────┤   │
│ • add_resource_      │   │
│   fractional()       │───┼─── Sammelt bruchteile
│ • add_resource()     │───┼─── Fügt ganze zahlen hinzu
│ • remove_resource()  │   │
└──────────────────────┘   │
          │                │
          │ emit signal    │
          └────────────────┘
                           │
                           ▼
┌──────────────────────────────┐
│         HUD.tscn             │
│      (CanvasLayer)           │
├──────────────────────────────┤
│ TopLeftPanel:                │
│  • Stone: 0                  │◄─── Zeigt Ressourcen
│  • Wood: 0                   │
│  • Coal: 0                   │
│  • Iron: 0                   │
│                              │
│ TopRightPanel:               │
│  • Health: 100/100           │◄─── Zeigt Stats
│  • Shield: 50/50             │
│  • Speed: 280                │
│  • Build Speed: 1.0x         │
└──────────────────────────────┘
```

## Datenfluss beim Mining

```
SCHRITT 1: Input Detection
┌─────────┐
│ Spieler │──── Drückt 'E' (Input Action "mine")
└─────────┘
     │
     ▼
┌──────────────────────┐
│ PlayerMining.gd      │
│ process_mining()     │──── Wird jeden Frame aufgerufen (_process)
└──────────────────────┘


SCHRITT 2: Target Detection
┌──────────────────────┐
│ PlayerMining.gd      │
│ _update_target()     │
└──────────────────────┘
     │
     │ Interact_Area.get_overlapping_areas()
     ▼
┌──────────────────────┐
│ Prüfe ob Area:       │
│ • in group           │──── "resource_node" ⚠️ FEHLT!
│   "resource_node"    │
│ ODER                 │
│ • is ResourceNode    │──── Klassen-Check (Fallback)
└──────────────────────┘
     │
     ▼
  Gefunden! → _current_target = node


SCHRITT 3: Mining Execution
┌──────────────────────┐
│ PlayerMining.gd      │
│ _try_mine(node)      │
└──────────────────────┘
     │
     ├─► Get resource_key         (z.B. "stone")
     ├─► Check player_mineable    (Darf ich das abbauen?)
     ├─► Get harvest_per_second   (z.B. 4.0)
     │
     └─► Calculate: gain = harvest_per_second * delta
                          = 4.0 * 0.016 = 0.064 pro Frame
                          = ~4.0 pro Sekunde


SCHRITT 4: Fractional Accumulation
┌──────────────────────────────┐
│ PlayerInventory.gd           │
│ add_resource_fractional()    │
└──────────────────────────────┘
     │
     │ Beispiel über 1 Sekunde:
     │
     ├─► Frame 1:  _fraction_buffer["stone"] = 0.064
     ├─► Frame 2:  _fraction_buffer["stone"] = 0.128
     │   ...
     ├─► Frame 15: _fraction_buffer["stone"] = 0.960
     ├─► Frame 16: _fraction_buffer["stone"] = 1.024
     │                                         ↓
     │                          whole = 1 ✓
     │                          _fraction_buffer["stone"] = 0.024
     │                          inventory["stone"] += 1
     │
     └─► emit inventory_changed("stone", 1)


SCHRITT 5: HUD Update
┌──────────────────────┐
│ HUD.gd               │
│ _on_inventory_       │
│ changed(key, value)  │
└──────────────────────┘
     │
     └─► StoneLabel.text = "Stone: 1"
```

## Zeitliche Analyse

```
PRO SEKUNDE (bei 60 FPS):

Input Check:     60x pro Sekunde (_process)
Target Update:   60x pro Sekunde
Mining Calc:     60x pro Sekunde (wenn 'E' gedrückt)
Fractional Add:  60x pro Sekunde
Signal Emit:     ~4x pro Sekunde (nur bei ganzen Einheiten)
HUD Update:      ~4x pro Sekunde

PERFORMANCE: ✓ Sehr effizient
```

## Wichtige Interaktionen

### 1. Mining Detection Chain
```
Interact_Area (80px Radius)
    ↓
ResourceNode (muss in group "resource_node" sein!) ⚠️
    ↓
PlayerMining erkennt Target
    ↓
Mining startet bei Input "mine"
```

### 2. Resource Flow Chain
```
ResourceNode (harvest_per_second: 4.0)
    ↓
PlayerMining (berechnet: 4.0 * delta)
    ↓
PlayerInventory (akkumuliert fractional)
    ↓
Signal: inventory_changed
    ↓
HUD (zeigt neue Werte an)
```

### 3. Component Communication
```
player.gd (Main Controller)
    │
    ├─► Forward signals
    ├─► Delegate calls
    │
    ├── PlayerMovement    (unabhängig)
    ├── PlayerCamera      (unabhängig)
    ├── PlayerMining ────► PlayerInventory (direkte Referenz!)
    └── PlayerStats       (unabhängig)
```

## Kritische Abhängigkeiten

### PlayerMining benötigt:
- ✓ Parent: Player (CharacterBody2D)
- ✓ Sibling: Interact_Area (Area2D)
- ✓ Sibling: PlayerInventory (Node)
- ⚠️ Externe: ResourceNode mit group "resource_node"

### PlayerInventory benötigt:
- ✓ Nur: Parent (für Node-Baum)
- ✓ Vollständig unabhängig!

### ResourceNode benötigt:
- ✓ Script: resource_node.gd
- ✓ Type: Area2D
- ⚠️ Group: "resource_node" FEHLT!
- ✓ Export: resource_type (Enum)
- ✓ Export: harvest_per_second (float)

### HUD benötigt:
- ✓ Export: player_path (NodePath)
- ✓ Signal: player.inventory_changed
- ✓ Signal: player.health_changed
- ✓ Signal: player.shield_changed

## Fehlerbehandlung

```
PlayerMining._ready():
├─► Kein parent?          → Error + return
├─► Keine Interact_Area?  → Error + return
└─► Kein PlayerInventory? → Error + return

PlayerMining._try_mine():
├─► Kein resource_key?    → Silent return
├─► Nicht mineable?       → Silent return
└─► Kein harvest_rate?    → Fallback: 2.0

HUD._ready():
├─► Kein player_path?     → Suche in Group "player"
├─► Immer noch kein player? → Warning
└─► Keine Methoden?       → Fallback auf Properties
```

## Performance Überlegungen

### Gut:
✓ Signals statt Polling (effizient!)
✓ Fractional Buffer (nur int-Updates senden Signal)
✓ Component-based (nur aktive Komponenten arbeiten)
✓ Area2D für Kollision (Godot-optimiert)

### Könnte optimiert werden:
- _update_target() läuft jeden Frame
  → Könnte auf Timer umgestellt werden (z.B. 10x/s statt 60x/s)
- get_overlapping_areas() jedes Frame
  → Könnte gecacht werden zwischen Frames

### Aber:
**Für ein Lernprojekt: Performance ist mehr als ausreichend!** ✓

## Zusammenfassung der Architektur-Qualität

| Aspekt | Bewertung | Grund |
|--------|-----------|-------|
| **Separation of Concerns** | ⭐⭐⭐⭐⭐ | Perfekt getrennt |
| **Component Coupling** | ⭐⭐⭐⭐ | Locker über Signals |
| **Error Handling** | ⭐⭐⭐⭐ | Gute Checks |
| **Extensibility** | ⭐⭐⭐⭐⭐ | Sehr einfach zu erweitern |
| **Performance** | ⭐⭐⭐⭐⭐ | Sehr effizient |
| **Debugging** | ⭐⭐⭐⭐ | Gut durch Modularität |

**Gesamt: 4.7/5** 🌟

---

*Dieses Diagramm zeigt die Architektur des Resource Mining Systems.*  
*Erstellt: 1. Januar 2026*
