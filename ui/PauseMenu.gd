extends CanvasLayer

var current_pause:bool;

func _ready() -> void:
	$PauseMenu.hide();
	EventBus.connect("game_paused",self,"_on_pause_toggle");
	
func _process(delta:float) -> void:
	if Input.is_action_just_pressed("pause"):
		EventBus.emit_signal("game_paused",!get_tree().paused);

# data: whether or not we want the game to be paused
func _on_pause_toggle (data:bool) -> void:
	if data:
		$PauseMenu.show();
	else:
		$PauseMenu.hide();
	get_tree().paused=data;


