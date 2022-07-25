extends "res://scripts/cutscene/BasicAnimationHandle.gd"


onready var _tween := $Tween
onready var _part := $DeathPart
onready var _b_death := $BossDeathSFX


func _ready():
	visible = false


func _on_boss_dead(_attackerName):
	visible = true
	_part.emitting = true
	_b_death.play()
	_tween.interpolate_property(self, "position:x", position.x, position.x + 3000, 1, Tween.TRANS_BACK, Tween.EASE_IN, 2.5)
	_tween.start()


func _on_tween_completed(_object, _key):
	EventBus.emit_signal("show_all_portals")

