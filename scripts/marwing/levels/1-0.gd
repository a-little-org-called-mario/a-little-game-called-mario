extends MarwingLevel

func _ready ():
	$DialogueBox.current_convo=[
		{
			"text": "HEY PILOT. IT'S ME, LIQUID RANDALL.",
			"audio": "res://voice/marwing/MW1-0_LR1.wav"
		},
		{
			"text": "IT LOOKS LIKE SOME NASTY MERGE CONFLICTS ARE BOMBARDING THE REPO PLANET.",
			"audio": "res://voice/marwing/MW1-0_LR2.wav"
		},
		{
			"text": "BUT DON'T SWEAT IT - THE NEW AND IMPROVED MARWING CAN TAKE CARE OF IT.",
			"audio": "res://voice/marwing/MW1-0_LR3.wav"
		},
		{
			"text": "JUST... FLY AROUND A BIT AND SHOOT THINGS.\n(GUNS CURRENTLY OFFLINE, MY BAD LOL)",
			"audio": "res://voice/marwing/MW1-0_LR4.wav"
		},
		{
			"text": "OH! THEY'RE UNMANNED DRONES. IT'S FINE, YOU DON'T HAVE TO FEEL BAD.",
			"audio": "res://voice/marwing/MW1-0_LR5.wav"
		},
		{
			"text": "SO GET TO WORK, MY DARLING. MY BABY BITCH DARLING.",
			"audio": "res://voice/marwing/MW1-0_LR6.wav"
		},
		{
			"text": "I BELIEVE IN YOU. YOU CAN DO IT.",
			"audio": "res://voice/marwing/MW1-0_LR7.wav"
		}
	];
	yield(get_tree().create_timer(0.5),"timeout");
	$DialogueBox.popup();
	$DialogueBox.start_line(0);

func _process (dt: float):
	# Maintains an infinite looping path which will be broken when we exit the dialogue
	if 1 == $Path/Marwing.unit_offset: $Path/Marwing.unit_offset = 0;
	if $DialogueBox.done:
		pass;	# This IS where we'll move to 1-1, once it's ready
