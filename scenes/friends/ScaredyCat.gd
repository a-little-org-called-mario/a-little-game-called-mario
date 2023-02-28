extends KinematicBody2D

export var velocity := Vector2.ZERO
export var jump_force := -300
export var gravity_vec := Vector2.DOWN * 270

export(PackedScene) var cat_scene = preload("res://scenes/friends/Cat.tscn")


func _physics_process(delta):
	velocity += gravity_vec * delta
	move_and_slide(velocity, Vector2.UP)
	if is_on_floor():
		velocity.y = jump_force
	if is_on_wall():
		velocity.x *= -1
	if is_on_ceiling(): #BONK! You fall down now
		velocity.y = max(0, velocity.y)


func _on_PlayerHitbox_body_entered(body : KinematicBody2D):
	if not body is Player:
		return
	
	var cat = cat_scene.instance()
	get_parent().call_deferred("add_child", cat)
	cat.set_player(body)
	cat.global_position = global_position
