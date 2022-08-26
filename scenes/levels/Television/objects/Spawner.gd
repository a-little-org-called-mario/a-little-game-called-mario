extends Position2D

export(PackedScene) var summoned_item
export(int) var summon_delay = 5
export(int) var simultaneous_summons = 2
export(NodePath) onready var timer = get_node(timer) as Timer


func _ready():
	timer.wait_time = summon_delay


func _on_Timer_timeout():
	summon()


func summon():
	if get_child_count() >= simultaneous_summons + 1:
		return false
	var thrown = summoned_item.instance()
	add_child(thrown)
	thrown.global_position.x = global_position.x
	thrown.global_position.y = global_position.y
	return true
