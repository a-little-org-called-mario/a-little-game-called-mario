extends Area2D
# Copied some stuff from player proyectile

signal destroyed

export(float) var projectile_speed: float = 4
export(bool) var look_at_direction: bool = true

var _direction: Vector2 = Vector2()
var _active: bool = false


func _ready() -> void:
	self.connect("body_entered", self, "_body_entered")


func start_moving(dir: Vector2 = Vector2.ZERO) -> void:
	_handle_start(dir)
	_active = true
	_direction = dir.normalized()


# To be overridden to play sounds or other animations
func _handle_start(_dir: Vector2) -> void:
	pass

func _physics_process(_delta: float) -> void:
	if _active:
		_handle_movement()
		if look_at_direction and _direction != Vector2():
			look_at(position + _direction)


# Override to do anything else than move in a straight line
func _handle_movement() -> void:
	position += _direction * projectile_speed


func _body_entered(body: Node2D) -> void:
	# If body is the player then lose health
	if body is Player:
		print("Player was hit!")
		EventBus.emit_signal("heart_changed", {"value": -1})
	destroy()


func destroy() -> void:
	if not _active:
		return
	set_deferred("monitorable", false)
	set_deferred("monitoring", false)
	_active = false
	# warning-ignore:void_assignment
	var res = _handle_destruction()
	if res is GDScriptFunctionState:
		yield(res, "completed")
	emit_signal("destroyed")
	queue_free()


# Override to add fancy effects
func _handle_destruction() -> void:
	pass
