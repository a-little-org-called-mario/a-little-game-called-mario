extends KinematicBody2D

export var velocity := Vector2.ZERO
export var gravity : float = 650
export var spawn_cooldown : float = 1.5 #Make the peel not detect collisions immediately, so it won't be hit immediately after spawning

var banana_slide_scene := preload("res://scenes/platformer/characters/player_components/BananaSlide.tscn")

func _ready():
	$Hitbox.monitoring = false
	$Timer.start(spawn_cooldown)


func _physics_process(delta):
	velocity += Vector2.DOWN * gravity * delta
	velocity = move_and_slide(velocity, Vector2.UP)
	if is_on_floor():
		velocity = Vector2.DOWN


func _on_Hitbox_body_entered(body : Player):
	if body:
		var rel_position = body.global_position - global_position
		var banana_slide = banana_slide_scene.instance()
		banana_slide.direction = Vector2.RIGHT * -sign(rel_position.x)
		body.add_child(banana_slide)
		
		queue_free()


func _on_Timer_timeout() -> void:
	$Hitbox.monitoring = true
