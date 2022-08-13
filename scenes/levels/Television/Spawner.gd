extends Position2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export(PackedScene) var summonedItem
export var summonDelay = 5
export var simultaneousSummons = 2
var active=false
var lastSummon = 0

# Called when the node enters the scene tree for the first time.
func _enter_tree():
	active=true # Replace with function body.

func _exit_tree():
	active=false # Replace with function body.

func _process(delay):
	lastSummon += delay
	if lastSummon >= summonDelay:
		print("summoning")
		summon()
		lastSummon -= summonDelay

func summon():
	if get_child_count() >= simultaneousSummons:
		return false
	var thrown = summonedItem.instance()
	add_child(thrown)
	thrown.global_position.x = global_position.x
	thrown.global_position.y = global_position.y
	return true

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
