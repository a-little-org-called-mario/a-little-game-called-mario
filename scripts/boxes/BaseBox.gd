# Offers basic functionality of a box (animation, counter, ...)
# Extend it and override the 'on_bounce' func to give it a unique behavior.
extends Node2D
class_name BaseBox

const bounce_offset: Vector2 = Vector2(0, -12)
const bounce_duration: float = 0.1

export(int) var bounce_count: int
export(bool) var start_invisible: bool

onready var hitArea = $HitArea
onready var mainCollider : PhysicsBody2D = $Body
onready var sprite = $Sprite
onready var tween = $Tween
onready var audio_meow = $MeowStream

func _ready() -> void:
	hitArea.connect("body_entered", self, "_on_box_entered")
	if start_invisible:
		sprite.visible = false

func _on_box_entered(body: Node2D) -> void:
	if body is KinematicBody2D and body.position.y > hitArea.global_position.y:
		call_deferred("bounce", body)


func _physics_process(_delta : float) -> void:
	(mainCollider.get_child(0) as CollisionShape2D).disabled = !sprite.visible


func bounce(body: KinematicBody2D) -> void:
	sprite.visible = true
	tween.interpolate_property(sprite, "position", sprite.position, bounce_offset, bounce_duration / 2)
	tween.start()
	
	yield(tween, "tween_all_completed")
	audio_meow.play()
	on_bounce(body)
	
	tween.interpolate_property(sprite, "position", sprite.position, Vector2.ZERO, bounce_duration / 2)
	tween.start()
	
	bounce_count -= 1
	if bounce_count <= 0:
		disable()
		

# To be overidden in children to extend the box behavior
func on_bounce(body: KinematicBody2D) -> void:
	pass

func disable() -> void:
	sprite.modulate = sprite.modulate.darkened(0.4)
	hitArea.disconnect("body_entered", self, "_on_box_entered")

