# res://Scripts/resource_types.gd
class_name ResourceTypes

enum Type {
	STONE,
	WOOD,
	COAL,
	IRON
}

static func to_key(t: Type) -> String:
	match t:
		Type.STONE: return "stone"
		Type.WOOD:  return "wood"
		Type.COAL:  return "coal"
		Type.IRON:  return "iron"
		_:          return "unknown"
