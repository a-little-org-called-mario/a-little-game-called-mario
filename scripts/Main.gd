extends Node2D

const ENDPORTALS_GROUP : String = "EndPortals"

onready var level : TileMap = $TileMap
onready var player : KinematicBody2D = $Player


func _ready() -> void:
	_hook_portals()


func _hook_portals() -> void:
	for portal in get_tree().get_nodes_in_group(ENDPORTALS_GROUP):
		# Avoid objects that should not be in the group.
		if not portal is EndPortal:
			continue
		# Avoid connecting the same object several times.
		if portal.is_connected("body_entered", self, "_on_endportal_body_entered"):
			continue
		portal.connect("body_entered", self, "_on_endportal_body_entered", [ portal.next_level, portal, portal.next_level_should_follow_camera ])


func _on_endportal_body_entered(_body : Node2D, next_level : PackedScene, portal, next_level_should_follow_camera: bool) -> void:
	var animation = portal.on_portal_enter()
	_body.visible = false;
	yield(animation, "animation_finished");
	_body.visible = true;
	call_deferred("_finish_level", next_level, next_level_should_follow_camera)


func _finish_level(next_level : PackedScene = null, next_level_should_follow_camera : bool = false) -> void:
	if next_level:
		# Create the new level, insert it into the tree and remove the old one.
		var new_level : TileMap = next_level.instance()
		add_child_below_node(level, new_level)
		remove_child(level)
		level = new_level

		# Do not forget to hook the new portals
		_hook_portals()

		# We need to flash the player out and in the tree to avoid physics errors.
		remove_child(player)
		player.set_camera_follow(next_level_should_follow_camera)
		add_child_below_node(level, player)
