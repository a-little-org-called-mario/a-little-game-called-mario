extends Node2D

export(int) var tick

func _process(delta):
	tick += 1
	emit_signal("set_tick", tick)

signal set_tick
