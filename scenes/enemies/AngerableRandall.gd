#Sort of like the Angry Randall Spawner, but can become angry mid level by calling anger()
extends Node2D

export var angry_randall_scene : PackedScene = preload("res://scenes/enemies/AngryRandal.tscn")


# Called when the node enters the scene tree for the first time.
func _ready():
	if DataStore.get_data_or_null("randall_angered"):
		call_deferred("spawn_angry_randall") #This has to be deferred so it can add the node


func anger():
	DataStore.set_data("randall_angered", true, true)
	spawn_angry_randall()
	
	
func spawn_angry_randall():
	var node = angry_randall_scene.instance()
	node.position = position
	get_parent().add_child(node)
	queue_free()
