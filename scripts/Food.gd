class_name Food
extends KinematicBody2D

var vel_y = 0
var vel_rotation = 0
var is_pie = false


func randomize_me():
	vel_rotation = int(rand_range(-2, 2))
	vel_y = int(rand_range(50, 150))
	position.y = int(rand_range(0, -100))
	position.x = int(rand_range(32, 1000))

	if randf() > 0.5:
		var x = int(rand_range(0, 7)) * 32
		var y = int(rand_range(0, 2)) * 32
		$Sprite.region_rect = Rect2(x, y, 32, 32)
		is_pie = false
	else:
		$Sprite.region_rect = Rect2(1 * 32, 3 * 32, 32, 32)
		is_pie = true


func _physics_process(delta: float):
	$Sprite.rotation_degrees += vel_rotation
	var collision = move_and_collide(Vector2(0, vel_y * delta))
	if collision:
		if collision.collider as TileMap:
			randomize_me()
		elif collision.collider.name == "Player" and is_pie:
			EventBus.emit_signal("player_died")


func _ready():
	randomize_me()
