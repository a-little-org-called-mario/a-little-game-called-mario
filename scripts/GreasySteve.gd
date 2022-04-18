# greasy steve drips ASS

extends "res://scripts/GassyRandal.gd"

export var is_dripping_grease: bool = true


func _process(_delta):
	$GreaseLeft.visible = is_dripping_grease
	$GreaseRight.visible = is_dripping_grease
