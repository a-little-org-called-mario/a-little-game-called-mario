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
	for targetNode in $Control/HBox.get_children():
		if targetNode.movePositon == focusNo:
			targetNode.moveFocused = true
		else:
			targetNode.moveFocused = false



func _on_change_selected(new_move):
	focusNo = new_move
