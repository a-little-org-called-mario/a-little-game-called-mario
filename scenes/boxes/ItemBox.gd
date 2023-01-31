#Spawns a Node2D from item_scene when bounced
extends BaseBox


export var item_scene : PackedScene #What to spawn when this box is bounced
export var spawn_offset := Vector2(0, -64) #Position to spawn the node, relative to the ItemBox position


func _ready():
	assert(item_scene, "ItemBox has no item_scene set")


func on_bounce(_body: KinematicBody2D):
	var node : Node2D = item_scene.instance()
	node.global_position = global_position + spawn_offset
	get_parent().add_child(node)
