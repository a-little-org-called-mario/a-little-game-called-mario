extends Node2D

var last_inputs = []

export (String, FILE, "*.tscn") var redirect_scene

#There's an issue where if you're playing on an xbox controller then "b" will be "a" and "a" will be "b".
#If someone knows how to get if the player is using an xbox controller then modify the "code_add" function
#to support it if you want

func _process(_delta: float) -> void:

	if Input.is_action_just_pressed("konami_up"):
		code_add("up")
	if Input.is_action_just_pressed("konami_down"):
		code_add("down")
	if Input.is_action_just_pressed("konami_left"):
		code_add("left")
	if Input.is_action_just_pressed("konami_right"):
		code_add("right")
	if Input.is_action_just_pressed("konami_b"):
		code_add("b")
	if Input.is_action_just_pressed("konami_a"):
		code_add("a")
	if Input.is_action_just_pressed("konami_start"):
		code_add("start")

		if check_code(last_inputs):
			print("Konami Code Activated")
			CheatsInfo.code_entered = true
			EventBus.emit_signal("change_scene", { "scene": redirect_scene })

func check_code(inputs: Array) -> bool:
	var CODE = ["up","up","down","down","left","right","left","right","b","a","start"]
	return inputs == CODE

func code_add(button: String) -> void:
	last_inputs.append(button)
	
	while last_inputs.size() >= 12: #Removes elements from the front of the array until the size of the array is 11
		last_inputs.pop_front()

	$Timer.start() #Starts a timer that clears all inputs if there is no input for 5 seconds.

func _on_Timer_timeout() -> void:
	last_inputs = []
