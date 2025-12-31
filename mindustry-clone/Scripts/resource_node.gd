# res://Actors/resource_node.gd
extends Area2D
class_name ResourceNode

@export var resource_type: ResourceTypes.Type = ResourceTypes.Type.STONE
@export var harvest_per_second: float = 4.0
@export var required_tool: String = "" # später (Pickaxe etc.), jetzt leer

func get_resource_key() -> String:
	return ResourceTypes.to_key(resource_type)
