extends CanvasLayer


const CHANGE_DURATION = 1.25

onready var _hp_bar := $ProgressRed/Progress
onready var _hp_bar_red := $ProgressRed
onready var _tween := $ProgressRed/Progress/Tween
onready var _heal := $BossHealSFX
onready var _name := $Name


func _ready():
	EventBus.connect("player_died", self, "_on_player_died")


func _on_set_health(maxHealth):
	_hp_bar.max_value = maxHealth
	_hp_bar_red.max_value = maxHealth
	_hp_bar_red.value = maxHealth
	_tween.interpolate_property(_hp_bar, "value", 1, maxHealth, CHANGE_DURATION, Tween.TRANS_CUBIC, Tween.EASE_OUT, 0.4)
	_tween.start()
	_heal.play()


func _on_health_change(oldHealth, newHealth):
	if oldHealth > newHealth:
		_hp_bar.value = newHealth
		_tween.interpolate_property(_hp_bar_red, "value", oldHealth, newHealth, CHANGE_DURATION, Tween.TRANS_CUBIC, Tween.EASE_OUT, 0.1)
	else:
		_hp_bar_red.value = newHealth
		_tween.interpolate_property(_hp_bar, "value", oldHealth, newHealth, CHANGE_DURATION, Tween.TRANS_CUBIC, Tween.EASE_OUT, 0.1)
		_heal.play()
	_tween.start()


func _on_player_died():
	change_visible(false)


func change_visible(vis = false):
	_name.visible = vis
	_hp_bar_red.visible = vis

