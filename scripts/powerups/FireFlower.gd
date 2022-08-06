#FireFlower sprite by Jacob Posten (Harper's brother)
extends Powerup
class_name FireFlower

func _on_body_entered(_body):
	call_deferred("collect", "fire_flower_collected", {"amount": 5})
