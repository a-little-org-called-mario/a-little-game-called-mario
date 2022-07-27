extends Button


var canChangeFocus = true


signal page_changed(pageName)


func _process(delta):
	var focusOwner = get_focus_owner()
	change_focus(focusOwner)
	emit_current_focus(focusOwner)
	


func change_focus(fOwner):
	# forcing the focus to change
	if fOwner == self and canChangeFocus:
		
		if Input.is_action_just_pressed("ui_up"):
			var above = get_node_or_null(focus_neighbour_top)
			if above != null:
				above.grab_focus()
				
		elif Input.is_action_just_pressed("ui_down"):
			var below = get_node_or_null(focus_neighbour_bottom)
			if below != null:
				below.canChangeFocus = false
				below.grab_focus()
	
	canChangeFocus = true


func emit_current_focus(fOwner):
	# tell Notes what page to display
	if fOwner == self:
		emit_signal("page_changed", text)

