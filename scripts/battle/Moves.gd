extends CanvasLayer


var moveIcons = ["Hammer", "Hammer", "Hammer", "Hammer", "Hammer"]
var focusNo = 2


func _ready():
	var count = 0
	for targetNode in $Control/HBox.get_children():
		targetNode.iconBase = moveIcons[count]
		count += 1 


func _process(delta):
	handle_focus()


func handle_focus():
	if Input.is_action_just_pressed("battle_moves_left"):
		focusNo -= 1
	if Input.is_action_just_pressed("battle_moves_right"):
		focusNo += 1
	
	if focusNo < 0:
		focusNo = 4
	elif focusNo > 4:
		focusNo = 0
	
	for targetNode in $Control/HBox.get_children():
		if targetNode.movePositon == focusNo:
			targetNode.moveFocused = true
		else:
			targetNode.moveFocused = false

