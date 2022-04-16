extends Panel

const VisibleTime: int = 5

func _ready():
	EventBus.connect("player_died", self, "_on_player_died")


func _on_player_died():
	self.show()
	$PlayerDied.bbcode_text = "\n" + tr("[wave amp=50 freq=2][rainbow freq=0.5 sat=1 val=20]YOU DIED[/rainbow] [/wave]")
	yield(get_tree().create_timer(VisibleTime), "timeout")
	self.hide()
