extends Panel

const VisibleTime: int = 5

func _ready():
	EventBus.connect("player_died", self, "_on_player_died")


func _on_player_died():
	self.show()
	$PlayerDied.bbcode_text = "\n" + tr("PLAYER_DIED")
	yield(get_tree().create_timer(VisibleTime), "timeout")
	self.hide()
