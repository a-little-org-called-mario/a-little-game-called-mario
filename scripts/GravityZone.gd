tool
extends Area2D

export(RectangleShape2D) var shape : RectangleShape2D setget _set_shape
export(bool) var revert_on_exit : bool

var general_gravity = preload("res://scripts/resources/Gravity.tres")

var previous_gravity_direction: Vector2 = Vector2.DOWN


func _ready() -> void:
	connect("body_entered", self, "_on_body_entered")
	connect("body_exited", self, "_on_body_exited")

	if shape == null:
		return
	var sprite: Sprite = $Sprite
	var sprite_size: Vector2 = sprite.texture.get_size() / Vector2(sprite.hframes, sprite.vframes)
	sprite.scale = shape.extents * 2 / sprite_size


func _on_body_entered(_body: Node) -> void:
	previous_gravity_direction = general_gravity.direction
	general_gravity.direction = gravity_vec


func _on_body_exited(_body: Node) -> void:
	if revert_on_exit and previous_gravity_direction.length_squared() > 0:
		general_gravity.direction = previous_gravity_direction
	previous_gravity_direction = Vector2.ZERO


func _set_shape(new_shape : RectangleShape2D) -> void:
	shape = new_shape
	$CollisionShape2D.shape = shape
