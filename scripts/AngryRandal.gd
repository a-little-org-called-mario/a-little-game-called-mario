# angry randal, occasionally swoops down to try to get that man

extends "res://scripts/GassyRandal.gd"

export var health: int = 2
export var moveDuration = 1.25
export var waitTimeBetweenSwoops = 1.5
export var damage_flash_interval := 0.15
export var damage_flash_amount: int = 6

var time = 0
var swooping := false
var currentSwoopIndex = 0
var swoopFrom := []
var swoopTo := []
var damage_flash_left := 0


func _ready():
	initSwoopTimer()
	$DamageFlashTimer.wait_time = damage_flash_interval


func initSwoopTimer() -> void:
	$SwoopTimer.connect("timeout", self, "_on_SwoopTimer_timeout")
	$SwoopTimer.wait_time = waitTimeBetweenSwoops
	$SwoopTimer.start()


func _on_SwoopTimer_timeout() -> void:
	if $VisibilityNotifier2D.is_on_screen():
		$SwoopTimer.stop()
		initSwoopTargetLocations()
		swooping = true
		currentSwoopIndex = 0
	else:
		$SwoopTimer.start()


func initSwoopTargetLocations() -> void:
	var player: Node2D = get_tree().get_nodes_in_group("Player")[0]

	var upperLeftPoint = Vector2(position.x, position.y)
	var bottomMiddlePoint = player.position
	var upperRightPoint = (
		(bottomMiddlePoint - upperLeftPoint).reflect(Vector2.RIGHT)
		+ bottomMiddlePoint
	)

	swoopFrom = [upperLeftPoint, bottomMiddlePoint, upperRightPoint, bottomMiddlePoint]
	swoopTo = [bottomMiddlePoint, upperRightPoint, bottomMiddlePoint, upperLeftPoint]


func kill(killer: Object, damage: int = 1) -> void:
	_damage(damage, killer)


func _damage(dmg: int, _killer: Object) -> void:
	health = health - dmg
	damage_flash_left += damage_flash_amount
	if health <= 0:
		queue_free()


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


func _on_DamageFlashTimer_timeout():
	if damage_flash_left > 0:
		$RandalCloud.visible = not $RandalCloud.visible
		$BigRandalCloud.visible = not $BigRandalCloud.visible
		damage_flash_left -= 1
	else:
		$RandalCloud.visible = true
		$BigRandalCloud.visible = true
