extends StaticBody2D

signal out_of_view
signal booth_passed

export (int) var price :int= 5
export (float) var chance_of_spill :float= 0.25
var toll_paid := false

func _ready():
	$PayZone.connect("body_entered",self, "_payzone_entered")
	$FreeZone.connect("body_entered",self, "_payzone_entered", [true])
	$VisibilityNotifier.connect("screen_exited",self, "_out_of_view")

func _payzone_entered(body, for_free:= false):
	if body.is_in_group("Player"):
		if !body.get_collision_mask_bit(3):
			for_free= true
		if CoinInventoryHandle.change_coins_on(body, -price * int(!for_free)):
			$BarrierShape.set_deferred("disabled", true)
			$PayZone.set_deferred("monitoring", false)
			$FreeZone.set_deferred("monitoring", false)
			toll_paid= true
			if not for_free and body.has_method("set_health"):
				body.set_health(body.get_health() + 25)
				$AnimationPlayer.play("open")
				$Paid.play()
			else:
				$Nope.play()
			emit_signal("booth_passed")
		else:
			$AnimationPlayer.play("no_coins")
			$Nope.play()

func _out_of_view():
	if toll_paid:
		emit_signal("out_of_view")
		$BarrierShape.set_deferred("disabled", false)
		$PayZone.set_deferred("monitoring", true)
		$FreeZone.set_deferred("monitoring", true)
		toll_paid= false
		$AnimationPlayer.play("RESET")
		$Spill.visible= randf() < chance_of_spill
		$Spill.monitoring= $Spill.visible

func change_price(value):
	price= value
