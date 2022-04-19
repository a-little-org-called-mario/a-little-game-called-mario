extends Node

export var mixAmount : float = 0.0

onready var rect = $ViewportContainer/MeshInstance2D
onready var tween = $Tween

func _process(_delta):
	# Set shader param controlling "funkiness"
	rect.material.set_shader_param("mixAmt", mixAmount)

func slow():
	# Tweening the "funkiness"
	tween.interpolate_property(self, "mixAmount", mixAmount, 1.0, 0.1, Tween.TRANS_BACK, Tween.EASE_IN)
	tween.start()
	
	# Engine.time_scale has some problems, but it's fine
	Engine.time_scale = 0.7
func speed():
	tween.interpolate_property(self, "mixAmount", mixAmount, 0, 0.2, Tween.TRANS_BACK, Tween.EASE_IN)
	tween.start()
	
	Engine.time_scale = 1
