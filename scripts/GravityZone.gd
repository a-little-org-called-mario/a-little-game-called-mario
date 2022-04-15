tool
extends Area2D

export(RectangleShape2D) var shape: RectangleShape2D setget _set_shape
export(bool) var revert_on_exit: bool

onready var _sprite: Sprite = $Sprite

var _general_gravity = preload("res://scripts/resources/Gravity.tres")
var _previous_gravity_direction: Vector2 = Vector2.DOWN

var active: bool setget , _get_active


func _ready() -> void:
	connect("body_entered", self, "_on_body_entered")
	connect("body_exited", self, "_on_body_exited")

	(_sprite.material as ShaderMaterial).set_shader_param("direction", sign(gravity_vec.y))
	if shape == null:
		return
	_sprite.region_rect = Rect2(Vector2.ZERO, shape.extents * 2.0)


func _process(_delta: float) -> void:
	modulate.a = 0.6 if self.active else 0.3


func _on_body_entered(_body: Node) -> void:
	_previous_gravity_direction = _general_gravity.direction
	_general_gravity.direction = gravity_vec


func _on_body_exited(_body: Node) -> void:
	if revert_on_exit and _previous_gravity_direction.length_squared() > 0:
		_general_gravity.direction = _previous_gravity_direction
	_previous_gravity_direction = Vector2.ZERO


func _get_active() -> bool:
	return revert_on_exit or sign(_general_gravity.direction.y) != sign(gravity_vec.y)


func _set_shape(new_shape: RectangleShape2D) -> void:
	shape = new_shape
	$CollisionShape2D.shape = shape
