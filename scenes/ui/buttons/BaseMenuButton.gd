extends Button
class_name BaseMenuButton

export (bool) var focused_by_default = false

onready var selected_icon = self.icon
onready var unselected_icon = ImageTexture.new() if selected_icon else null


func _ready():
	self.connect("pressed", self, "_on_pressed")
	self.connect("focus_entered", self, "_on_focus_entered")
	self.connect("focus_exited", self, "_on_focus_exited")
	self.connect("mouse_entered", self, "grab_focus")
	
	# Copy of image with transparent color
	if selected_icon:
		var img = selected_icon.get_data()
		img.fill(Color(0,0,0,0))
		unselected_icon.create_from_image(img)

	self.icon = unselected_icon

	if focused_by_default:
		grab_focus()


func _on_pressed():
	pass


func _on_focus_entered():
	icon = selected_icon


func _on_focus_exited():
	icon = unselected_icon
