extends Area2D


export var peel_scene : PackedScene = preload("res://scenes/powerups/BananaPeel.tscn")


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func create_peel(velocity: Vector2):
	var peel := peel_scene.instance()
	peel.position = position
	peel.velocity = velocity
	get_parent().add_child(peel)
		

func _on_Banana_body_entered(body: Player) -> void:
	if body:
		HeartInventoryHandle.change_hearts_on(body, 1)
		var normal = (body.global_position - global_position).normalized()
		call_deferred("create_peel", Vector2(normal.x * 300, -300))
		
		queue_free()
