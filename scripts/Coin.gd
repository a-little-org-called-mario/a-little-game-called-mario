extends Area2D

func _ready():
	pass


func _on_Coin_body_entered(body):
	set_collision_layer_bit(3, false)
	$AnimationPlayer.play("fade")
	$AudioStreamPlayer2D.play()

func _on_AnimationPlayer_animation_finished(anim_name):
	queue_free()
