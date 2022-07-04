extends Enemy


export(Vector2) var move_direction = Vector2.LEFT
export(int, 100, 400, 50) var default_speed = 150
export(int, 400, 750, 50) var force_speed = 500

onready var animation: AnimationPlayer = $AnimationPlayer
onready var ray_player: RayCast2D = $RayCastPlayer

onready var _speed: int = default_speed


func ai(delta: float):
	if ray_player.get_collider() as Player:
		set_physics_process(false)
		set_process(false)
		_speed = force_speed
		animation.play("rearup")
		yield(animation, "animation_finished")
		set_physics_process(true)
		yield(get_tree().create_timer(0.5), "timeout")
		_speed = default_speed
		set_process(true)


func move(delta: float):
	move_and_slide(move_direction*_speed + Vector2.DOWN*force_speed, Vector2.UP)
	if not (is_on_wall() or is_on_ceiling()):
		return
	var player := get_last_slide_collision().collider as Player
	if player:
		player.bounce(8000, move_direction + Vector2.UP)
	if not is_on_floor():
		return
	_speed = default_speed
	animation.play("turn")
	scale = Vector2(-1,-1) if move_direction > Vector2.LEFT else Vector2(-1,1)
	move_direction *= -1
	set_physics_process(false)
	yield(animation, "animation_finished")
	set_physics_process(true)


func _handle_dying(_killer):
	disable_collision()
	set_physics_process(false)
	_sprite.visible = false
	$SquishParticles.emitting = true
	yield(get_tree().create_timer(0.2), "timeout")
