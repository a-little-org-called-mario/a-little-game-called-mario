extends Popup

## This could all probably be used to build a more universal system, but rn I'm just hacking this together for Marwing

var current_line : int = 0;
var current_convo = [];
var typing : bool = false;
var done : bool = false;

func _process (dt: float):
	if visible:
		$Tick.hide();

		if typing and $Label.percent_visible <= 1:
			$Label.percent_visible = $Label.percent_visible + (dt * (0.9 if Input.is_action_pressed("ui_accept") else 0.45));
			if $Label.percent_visible >= 1:
				typing = false;
				$Label.percent_visible = 1;
		elif not typing:
			$Tick.show();
			if Input.is_action_just_pressed("ui_accept"):
				start_line(current_line+1);
				$SFXPlayer.play();
	else:
		$VoicePlayer.stop();


func start_line (line:int = 0):
	if line < 0:
		return;

	if line >= current_convo.size():
		hide();
		done = true;
		return;

	current_line = line;
	typing = true;
	$Label.text = current_convo[line].text;
	$Label.percent_visible = 0;

	if ResourceLoader.exists(current_convo[line].audio):
		print("found it")
		var audio = ResourceLoader.load(current_convo[line].audio);
		audio.loop_mode = 0;
		$VoicePlayer.stream = audio;
		$VoicePlayer.play();
	pass;
