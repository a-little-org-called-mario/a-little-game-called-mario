# angry randal, occasionally swoops down to try to get that man

extends "res://scripts/GassyRandal.gd"

onready var hitArea = $HitArea

export var moveDuration = 2
export var waitTimeBetweenSwoops = 20

var time = 0
var swooping := false
var currentSwoopIndex = 0
var swoopFrom := []
var swoopTo := []


func _ready():
	initSwoopTimer()
	initSwoopTargetLocations()
	initCollisionDetection()


func initSwoopTimer() -> void:
	$SwoopTimer.connect("timeout", self, "_on_SwoopTimer_timeout")
	$SwoopTimer.wait_time = waitTimeBetweenSwoops
	$SwoopTimer.start()


func _on_SwoopTimer_timeout() -> void:
	$SwoopTimer.stop()
	swooping = true
	currentSwoopIndex = 0


func initSwoopTargetLocations() -> void:
	var screenSize = get_viewport().get_visible_rect().size
	var upperLeftPoint = Vector2(screenSize.x * 0.1, screenSize.y * 0.1)
	var upperRightPoint = Vector2(screenSize.x - (screenSize.y * 0.1), screenSize.y * 0.1)
	var bottomMiddlePoint = Vector2(screenSize.x * 0.5, screenSize.y - (screenSize.y * 0.1))

	swoopFrom = [upperLeftPoint, bottomMiddlePoint, upperRightPoint, bottomMiddlePoint]
	swoopTo = [bottomMiddlePoint, upperRightPoint, bottomMiddlePoint, upperLeftPoint]


func _process(delta: float):
	if swooping:
		handleSwoop(delta)


func handleSwoop(delta: float) -> void:
	if time > moveDuration:
		time = 0
		currentSwoopIndex = currentSwoopIndex + 1

		if currentSwoopIndex >= len(swoopFrom):
			stopSwooping()
	else:
		time += delta

	var t = time / moveDuration
	position = lerp(swoopFrom[currentSwoopIndex], swoopTo[currentSwoopIndex], t)


func stopSwooping() -> void:
	currentSwoopIndex = 0
	swooping = false
	$SwoopTimer.start()


func randalVibe():
	if not swooping:
		.randalVibe()


func initCollisionDetection() -> void:
	$HitArea.connect("body_entered", self, "_on_body_entered")


func _on_body_entered(body) -> void:
	if body is Player:
		call_deferred("hitPlayer")


func hitPlayer():
	EventBus.emit_signal("heart_changed", {"value": -1})
