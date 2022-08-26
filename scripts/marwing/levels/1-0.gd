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
			"text":	"BUT DON'T SWEAT IT, LITTLE BUDDY- THE NEW AND IMPROVED MARWING CAN, UH, TAKE CARE OF IT.",
			"audio": "res://audio/voice/marwing/en/MW1-0_LR3.wav",
			"portrait": "res://sprites/marwing/DIALOGUE_ICON--LRANDALL.png"
		},
		{
			"text":	"JUST UH... FLY AROUND A BIT AND SHOOT SOME THINGS.",
			"audio": "res://audio/voice/marwing/en/MW1-0_LR4.wav",
			"portrait": "res://sprites/marwing/DIALOGUE_ICON--LRANDALL.png"
		},
		{
			"text":	"OH! UH, THEY'RE, UH, UNMANNED DRONES, BY THE WAY. IT'S FINE, YOU DON'T HAVE TO FEEL BAD. I MEAN I APPRECIATE YOUR KIND HEART, YOUR UH, CONSCIENCE, YOUR MORTAL FIBER, BUT UH, IT'S FINE. YOU CAN-YOU CAN JUST SHOOT, JUST, JUST SHOOT AWAY, IT'S FINE. IT'S OK, JUST SHOOT, JUST SHOOT, AND... PEW-PEW PEW PEW-PEW! IT'S GOOD, IT'S ALL GOOD, IT'S ALL GOOD.",
			"audio": "res://audio/voice/marwing/en/MW1-0_LR5.wav",
			"portrait": "res://sprites/marwing/DIALOGUE_ICON--LRANDALL.png"
		},
		{
			"text":	"SO, UH, GET TO WORK, MY DARLING.",
			"audio": "res://audio/voice/marwing/en/MW1-0_LR6.wav",
			"portrait": "res://sprites/marwing/DIALOGUE_ICON--LRANDALL.png"
		},
		{
			"text":	"I BELIEVE IN YOU. YOU CAN DO IT. GOOD LUCK, CHAMP, I KNOW YOU'LL MAKE IT. YOU KNOW I WISH I COULD BE OUT THERE WITH YOU AMONG THE STARS, YOU KNOW, TO BE YOUNG AND FREE AGAIN, BUT, OH WELl. I NO LONGER HAVE THUMBS, I CAN'T OPERATE A CONTROL STICK, BUT UH, I CAN STILL BE HERE WITH YOU, IN THE RADIO BROADCAST COMMUNICATIONS TRANSMISSIONS SIGNAL, AND UH WELP, THAT'LL BE GOOD ENOUGH FOR ME I THINK. UH, ER, MAKE US PROUD.",
			"audio": "res://audio/voice/marwing/en/MW1-0_LR7.wav",
			"portrait": "res://sprites/marwing/DIALOGUE_ICON--LRANDALL.png"
		},
	]
	yield(get_tree().create_timer(0.5),"timeout")
	$DialogueBox.show()
	$DialogueBox.start_line(0)

	act_number = 1
	level_number = 0
	name = "Introduction"


func _process (dt: float):
	# Maintains an infinite looping path which will be broken when we exit the dialogue
	if 1 == $Path/Marwing.unit_offset: $Path/Marwing.unit_offset = 0;
	if $DialogueBox.done:
		# this is where eventually we'll yield and then move to the next level
		EventBus.emit_signal("level_exited")
