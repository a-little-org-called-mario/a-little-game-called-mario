#If Randall has been angered before, spawns Angry Randall when the level starts
class_name AngryRandallSpawner
extends Node2D

export var spawn_passive_randall := true #Spawns a regular Gassy Randall if Randall hasn't been angered
export var spawn_path : NodePath = ".." #Where to spawn the node. Defaults to this node's parent

export var normal_randall_scene : PackedScene = preload("res://scenes/enemies/GassyRandal.tscn")
export var angry_randall_scene : PackedScene = preload("res://scenes/enemies/AngryRandal.tscn")


func _ready():
	var destination = get_node(spawn_path)
	if DataStore.get_data_or_null("randall_angered"):
		var node = angry_randall_scene.instance()
		node.global_position = global_position
		destination.call_deferred("add_child", node)
		queue_free()
	elif spawn_passive_randall:
		var node = normal_randall_scene.instance()
		node.global_position = global_position
		destination.call_deferred("add_child", node)
		queue_free()
