#Loads PackedScenes from DataStore and instances them as children of this node's parent
extends Node


export(String) var stored_scene_key


func _ready():
	var stored_scenes = DataStore.get_data_or_null(stored_scene_key)
	if not stored_scenes: #Nothing was set here yet
		return
	if not stored_scenes is Dictionary:
		push_error("DataStore.data[%s] exists but is not a dictionary." % stored_scene_key)
	else:
		for obj in stored_scenes.values():
			var scene : PackedScene = obj
			assert(scene)
			var node := scene.instance()
			get_parent().call_deferred("add_child", node)
	queue_free()
