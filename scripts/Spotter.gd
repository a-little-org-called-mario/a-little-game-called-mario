extends Area2D
class_name Spotter
# Attach this script to any Area2D to alert enemies when it spots the player

# Only alert a specific node, or everything inside a group
export(NodePath) var report_to_node
export(String) var report_to_group: String = ""


func _ready():
	if report_to_node:
		report_to_node = get_node_or_null(report_to_node)
	connect("body_entered", self, "_body_spotted")
	handle_setup()


func _body_spotted(body):
	var is_valid: bool = check_valid_detection(body)
	if is_valid and body.is_in_group("Player"):
		if not report_to_group.empty():
			for node in get_tree().get_nodes_in_group(report_to_group):
				if node.has_method("player_spotted"):
					node.player_spotted(self, body)
		elif (
			report_to_node
			and is_instance_valid(report_to_node)
			and report_to_node.has_method("player_spotted")
		):
			report_to_node.player_spotted(self, body)
		else:
			EventBus.emit_signal("player_spotted", self, body)


# Override this to do any setup work
func handle_setup():
	pass


# Override this to make checks before emitting a signal
func check_valid_detection(_body: PhysicsBody2D) -> bool:
	return true


# Disable/Enable all shapes
func disable_spoting():
	set_deferred("monitoring", false)


func enable_spoting():
	set_deferred("monitoring", true)
