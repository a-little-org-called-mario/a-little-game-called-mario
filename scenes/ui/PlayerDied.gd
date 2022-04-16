extends Panel

const VisibleTime: int = 5
const FORMAT: String = "[center][wave amp=50 freq=2][rainbow freq=0.5 sat=1 val=20]%s[/rainbow][/wave][/center]"

onready var animation_player: AnimationPlayer = $AnimationPlayer


func _ready():
	EventBus.connect("player_died", self, "_on_player_died")


func _on_player_died():
	$PlayerDied.bbcode_text = FORMAT % tr("YOU DIED")

	get_tree().paused = true
	animation_player.play("Appear")

	yield(animation_player, "animation_finished")

	self.hide()
	get_tree().paused = false
	get_tree().reload_current_scene()
