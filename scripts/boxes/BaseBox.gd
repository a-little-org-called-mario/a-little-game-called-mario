# Offers basic functionality of a box (animation, counter, ...)
# Extend it and override the 'on_bounce' func to give it a unique behavior.
extends Node2D

const bounce_offset = Vector2(0, -12)
const bounce_duration = 0.1

export(int) var bounce_count 
export(bool) var start_invisible 

onready var hitArea = $HitArea
onready var mainCollider = $Body
onready var sprite = $Sprite
onready var tween = $Tween

func _ready():
	hitArea.connect("body_entered", self, "_on_box_entered")
	if start_invisible:
		sprite.visible = false
		remove_child(mainCollider)
		

func _on_box_entered(body):
	if body is KinematicBody2D and body.position.y > hitArea.global_position.y:
		call_deferred("bounce")
		$box.connect("body_exited", self, "_on_box_body_exited")

func _on_box_body_exited(body):
		add_child(mainCollider)


func bounce():
	sprite.visible = true
	tween.interpolate_property(sprite, "position", sprite.position, bounce_offset, bounce_duration / 2)
	tween.start()
	
	yield(tween, "tween_all_completed")
	on_bounce()
	
	tween.interpolate_property(sprite, "position", sprite.position, Vector2.ZERO, bounce_duration / 2)
	tween.start()
	
	bounce_count -= 1
	if bounce_count <= 0:
		disable()
		

# override in children to extend the box behavior
func on_bounce():
	pass

func disable():
	sprite.modulate = sprite.modulate.darkened(0.4)
	hitArea.disconnect("body_entered", self, "_on_box_entered")

