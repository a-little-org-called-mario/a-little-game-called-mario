extends Node
class_name ScreenShake

const TRANS = Tween.TRANS_SINE
const EASE = Tween.EASE_IN_OUT

var amplitude = 0
var priority = 0

onready var camera = get_parent()
onready var _tween: Tween = $Tween
onready var _freq_timer: Timer = $Frequency
onready var _duration_timer: Timer = $Duration


#warning-ignore:SHADOWED_VARIABLE
#warning-ignore:SHADOWED_VARIABLE
func start(duration = 0.2, frequency = 15, amplitude = 16, priority = 0):
	if priority < self.priority:
		return

	if !Settings.screen_shake:
		return

	self.priority = priority
	self.amplitude = amplitude

	_duration_timer.wait_time = duration
	_freq_timer.wait_time = 1 / float(frequency)
	_duration_timer.start()
	_freq_timer.start()

	_new_shake()


func _new_shake():
	var rand = Vector2()
	rand.x = rand_range(-amplitude, amplitude)
	rand.y = rand_range(-amplitude, amplitude)

	_tween.interpolate_property(
		camera, "offset", camera.offset, rand, _freq_timer.wait_time, TRANS, EASE
	)
	_tween.start()


func _reset():
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
