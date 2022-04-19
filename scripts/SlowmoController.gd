extends Node

onready var slowmo = $Slowmo

func _process(_delta):
	# "toggle_inventory" is the key "E", it doesn't matter in this case I think.
	if Input.is_action_just_pressed("toggle_inventory"):
		# Calling slow here to remove it from slowmo to make it reusable in dfferent contextstststs
		slowmo.slow()
	elif Input.is_action_just_released("toggle_inventory"):
		# Calling speed here to remove it from slowmo to make it reusable in dfferent contextstststs
		slowmo.speed()
