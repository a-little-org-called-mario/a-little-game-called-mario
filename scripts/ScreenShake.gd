extends Node
class_name ScreenShake

const TRANS = Tween.TRANS_SINE
const EASE = Tween.EASE_IN_OUT

var amplitude: float = 0.0
var priority: float = 0.0

onready var camera: Camera2D = get_parent()
onready var _tween: Tween = $Tween
onready var _freq_timer: Timer = $Frequency
onready var _duration_timer: Timer = $Duration


func start(_duration: float = 0.2,
		_frequency: float = 15.0,
		_amplitude: float = 16.0,
		_priority = 0) -> void:
	
	if _priority < priority:
		return

	if !Settings.screen_shake:
		return

	priority = _priority
	amplitude = _amplitude

	_duration_timer.wait_time = _duration
	_freq_timer.wait_time = 1 / float(_frequency)
	_duration_timer.start()
	_freq_timer.start()

	_new_shake()


func _new_shake() -> void:
	var rand: Vector2 = Vector2(
		rand_range(-amplitude, amplitude),
		rand_range(-amplitude, amplitude)
	)

	_tween.interpolate_property(
		camera, "offset", camera.offset, rand, _freq_timer.wait_time, TRANS, EASE
	)
	_tween.start()


func _reset() -> void:
	_tween.interpolate_property(
		camera, "offset", camera.offset, Vector2.ZERO, _freq_timer.wait_time, TRANS, EASE
	)
	_tween.start()

	priority = 0


func _on_Frequency_timeout() -> void:
	_new_shake()


func _on_Duration_timeout() -> void:
	_reset()
	_freq_timer.stop()
	_duration_timer.stop()
