extends MarwingLevel

func _ready ():
	# there will, inevitably, be a more elegant solution than this
	$DialogueBox.convo = [
		{
			"text":	"HEY PILOT. IT'S ME, LIQUID RANDALL.",
			"audio": "res://audio/voice/marwing/en/MW1-0_LR1.wav",
			"portrait": "res://sprites/marwing/DIALOGUE_ICON--LRANDALL.png"
		},
		{
			"text":	"IT LOOKS LIKE SOME NASTY MERGE CONFLICTS ARE BOMBARDING THE REPO PLANET.",
			"audio": "res://audio/voice/marwing/en/MW1-0_LR2.wav",
			"portrait": "res://sprites/marwing/DIALOGUE_ICON--LRANDALL.png"
		},
		{
			"text":	"BUT DON'T SWEAT IT- THE NEW AND IMPROVED MARWING CAN TAKE CARE OF IT.",
			"audio": "res://audio/voice/marwing/en/MW1-0_LR3.wav",
			"portrait": "res://sprites/marwing/DIALOGUE_ICON--LRANDALL.png"
		},
		{
			"text":	"JUST... FLY AROUND A BIT AND SHOOT THINGS.",
			"audio": "res://audio/voice/marwing/en/MW1-0_LR4.wav",
			"portrait": "res://sprites/marwing/DIALOGUE_ICON--LRANDALL.png"
		},
		{
			"text":	"OH! THEY'RE UNMANNED DRONES. IT'S FINE, YOU DON'T HAVE TO FEEL BAD.",
			"audio": "res://audio/voice/marwing/en/MW1-0_LR5.wav",
			"portrait": "res://sprites/marwing/DIALOGUE_ICON--LRANDALL.png"
		},
		{
			"text":	"SO GET TO WORK, MY DARLING.",
			"audio": "res://audio/voice/marwing/en/MW1-0_LR6.wav",
			"portrait": "res://sprites/marwing/DIALOGUE_ICON--LRANDALL.png"
		},
		{
			"text":	"I BELIEVE IN YOU. YOU CAN DO IT.",
			"audio": "res://audio/voice/marwing/en/MW1-0_LR7.wav",
			"portrait": "res://sprites/marwing/DIALOGUE_ICON--LRANDALL.png"
		},
	]
	yield(get_tree().create_timer(0.5),"timeout")
	$DialogueBox.popup()
	$DialogueBox.start_line(0)

	act_number = 1
	level_number = 0
	name = "Introduction"

func _process (dt: float):
	# Maintains an infinite looping path which will be broken when we exit the dialogue
	if 1 == $Path/Marwing.unit_offset: $Path/Marwing.unit_offset = 0;
	if $DialogueBox.done:
		pass # this is where eventually we'll yield and then move to the next level
