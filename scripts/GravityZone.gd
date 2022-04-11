extends Area2D

var general_gravity = preload("res://scripts/resources/Gravity.tres")

var previous_gravity_direction : Vector2 = Vector2.DOWN


func _ready() -> void:
	connect("body_entered", self, "_on_body_entered")
	connect("body_exited", self, "_on_body_exited")

	var sprite : Sprite = $Sprite
	var sprite_size : Vector2 = sprite.texture.get_size() / Vector2(sprite.hframes, sprite.vframes)
	var shape : Shape2D = $CollisionShape2D.shape
	if shape is RectangleShape2D:
		sprite.scale = Vector2(
			shape.extents.x * 2 / sprite_size.x,
			shape.extents.y * 2 / sprite_size.y
		)


func _on_body_entered(_body : Node) -> void:
	previous_gravity_direction = general_gravity.direction
	general_gravity.direction = gravity_vec


func _on_body_exited(_body : Node) -> void:
	general_gravity.direction = previous_gravity_direction
