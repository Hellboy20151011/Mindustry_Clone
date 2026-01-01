# Resource Mining - Quick Action Checklist

## ⚠️ KRITISCH: Muss behoben werden (CRITICAL: Must Fix)

### 1. ResourceNode Group Fehlt
**Problem:** Der ResourceNode hat keine "resource_node" Group zugewiesen.

**Lösung Option A - Im Godot Editor (Empfohlen):**
1. Öffne `Actors/ResourceNode.tscn`
2. Wähle den Root Node (ResourceNode)
3. Gehe zu Node Tab (rechts) → Groups
4. Klicke "Add Group"
5. Tippe "resource_node" ein
6. Klicke OK
7. Speichere die Szene (Ctrl+S)

**Lösung Option B - Im Code:**
Füge in `Scripts/Resources/resource_node.gd` hinzu:
```gdscript
func _ready() -> void:
    add_to_group("resource_node")
```

**Warum wichtig:**
- Ohne diese Group findet PlayerMining keine ResourceNodes
- Mining funktioniert nicht!
- Das ist der Hauptgrund warum das System getestet werden muss

---

## ✅ Empfohlene Tests (Recommended Tests)

### Test 1: Basic Mining
1. Öffne `Maps/test_map.tscn` im Godot Editor
2. Klicke Play Scene (F6)
3. Bewege Spieler (WASD) zum Stein
4. Drücke 'E' zum Abbauen
5. **Erwartung:** Stone-Zähler im HUD steigt

### Test 2: Multiple Resource Types
1. Öffne `Actors/ResourceNode.tscn`
2. Ändere `resource_type` von STONE zu WOOD
3. Speichere als neue Szene: `ResourceNode_Wood.tscn`
4. Füge zu test_map hinzu
5. Teste Mining
6. **Erwartung:** Wood-Zähler steigt

### Test 3: Interaction Range
1. Im Play Mode, bewege dich langsam zum ResourceNode
2. Drücke 'E' aus verschiedenen Entfernungen
3. **Prüfe:** Ab welcher Distanz funktioniert Mining?
4. **Standard:** 80 Pixel Radius (siehe Player.tscn Interact_Area)

### Test 4: Harvest Rate
1. Mine einen ResourceNode für 10 Sekunden
2. Zähle wie viele Ressourcen du bekommst
3. **Erwartung:** ~40 Ressourcen (harvest_per_second = 4.0)
4. **Wenn anders:** Ist die Rate gut für dein Gameplay?

### Test 5: Input Conflicts
1. Stehe neben einem ResourceNode
2. Halte 'E' (mining) gedrückt
3. Klicke gleichzeitig Left Mouse (shooting)
4. **Prüfe:** Funktionieren beide? Oder gibt es Konflikte?

### Test 6: HUD Updates
1. Öffne HUD Script während Play Mode läuft
2. Aktiviere Debugger
3. Prüfe ob Signal "inventory_changed" gefeuert wird
4. **Erwartung:** Bei jeder ganzen Ressource ein Signal

---

## 🔧 Optionale Verbesserungen (Optional Improvements)

### Priorität HOCH:
- [ ] ResourceNode Group setzen (KRITISCH!)
- [ ] Teste alle 6 Tests oben
- [ ] Erstelle ResourceNode Varianten (Wood, Coal, Iron)

### Priorität MITTEL:
- [ ] Füge Partikel-Effekt beim Mining hinzu
- [ ] Erstelle Icons für Ressourcen im HUD
- [ ] Balance: Tune harvest_per_second Werte
- [ ] Erweitere Interact_Area Radius (100-120?)

### Priorität NIEDRIG:
- [ ] Mining Animation auf Player
- [ ] Sound Effects beim Mining
- [ ] Resource Depletion (Nodes verschwinden)
- [ ] Mining Progress Bar

---

## 📋 Quick Reference

### Input Actions:
- **Mining:** E-Key oder Right Mouse Button
- **Movement:** WASD oder Arrow Keys
- **Shoot:** Left Mouse Button
- **Zoom:** Mouse Wheel

### Key Files:
- Player Mining: `Scripts/Player/PlayerMining.gd`
- Player Inventory: `Scripts/Player/PlayerInventory.gd`
- Resource Node: `Scripts/Resources/resource_node.gd`
- Resource Types: `Scripts/Resources/resource_types.gd`
- HUD: `Scripts/UI/hud.gd`

### Important Values:
- Interact Range: 80 pixels (Player.tscn → Interact_Area)
- Harvest Rate: 4.0 per second (ResourceNode.tscn)
- Player Speed: 280 (PlayerMovement.gd)

---

## 🎯 Success Criteria

Das Mining System funktioniert wenn:
- ✅ Spieler kann sich bewegen
- ✅ Spieler kann ResourceNodes erreichen
- ✅ 'E' drücken startet Mining
- ✅ HUD zeigt steigende Ressourcenzahlen
- ✅ Keine Errors in der Console
- ✅ Fractional Accumulation arbeitet korrekt

---

## 🚨 Typische Probleme & Lösungen

### Problem: Mining funktioniert nicht
**Mögliche Ursachen:**
1. ResourceNode hat keine Group "resource_node" → **Siehe oben**
2. Interact_Area fehlt auf Player → Prüfe Player.tscn
3. Input Action "mine" nicht konfiguriert → Prüfe project.godot

### Problem: HUD zeigt keine Updates
**Mögliche Ursachen:**
1. player_path nicht gesetzt in HUD → Prüfe test_map.tscn
2. Signal nicht connected → Prüfe hud.gd _ready()
3. Player hat keine "Player" Group → Prüfe Player.tscn

### Problem: Ressourcen steigen zu schnell/langsam
**Lösung:**
- Ändere `harvest_per_second` in ResourceNode.tscn
- Standard: 4.0
- Schneller: 8.0-10.0
- Langsamer: 1.0-2.0

---

## 📞 Wenn Probleme auftreten

1. Prüfe Console auf Errors (F4 in Godot)
2. Aktiviere Debugger beim Play
3. Füge `print()` statements hinzu:
```gdscript
# In PlayerMining.gd → _try_mine()
print("Mining: ", key, " Amount: ", gain_float)
```

4. Prüfe ob alle Komponenten gefunden werden:
```gdscript
# In PlayerMining.gd → _ready()
print("Interact_Area found: ", interact_area != null)
print("Inventory found: ", _player_inventory != null)
```

---

**Status:** Ready for Testing  
**Letzte Aktualisierung:** 1. Januar 2026  
**Nächster Schritt:** ResourceNode Group setzen, dann testen!
