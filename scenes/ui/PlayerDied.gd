extends Panel

const FORMAT: String = "[center][wave amp=50 freq=2][rainbow freq=0.5 sat=1 val=20]%s[/rainbow][/wave][/center]"
const SKIP_ACTIONS: Array = ["jump", "click", "pause", "restart"]

onready var animation_player: AnimationPlayer = $AnimationPlayer


func _ready():
	EventBus.connect("player_died", self, "_on_player_died")


func _process(_delta: float) -> void:
	if not self.visible:
		return
	for skip_action in SKIP_ACTIONS:
		if Input.is_action_just_pressed(skip_action):
			animation_player.emit_signal("animation_finished")
			break


func _on_player_died():
	$PlayerDied.bbcode_text = FORMAT % tr("YOU DIED")

	get_tree().paused = true
	animation_player.play("Appear")

	yield(animation_player, "animation_finished")

	self.hide()
	get_tree().paused = false
	get_tree().reload_current_scene()
