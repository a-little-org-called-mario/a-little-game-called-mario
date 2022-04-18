extends MarwingShip

func _ready ():
	$Camera.set_current(true);

func _physics_process (dt: float):
	#note (jam): it would be really neat if this ended up being an exponential rather than linear acceleration
	#			 but i'm not in the mood to do that now

	# handle strafing based on player inputs
	if can_strafe:
		# horizontal strafing
		perpen.x = clamp(
				perpen.x - delta_strafe("marwing_right", dt) + delta_strafe("marwing_left", dt),
				-max_perpen.x, max_perpen.x);
		# if no horizontal strafe input, move back towards center
		if 0 != perpen.x and 0 == Input.get_action_strength("marwing_left") and 0 == Input.get_action_strength("marwing_right"):
			perpen.x = perpen.x + (dt * strafe_speed * (-0.75 if 0 < perpen.x else 0.75));
			if abs(perpen.x) < (dt * strafe_speed * 0.75): perpen.x = 0;
		$Mesh.translation.x = perpen.x;		# apply offset to mesh

		# vertical strafing
		perpen.y = clamp(
				perpen.y - delta_strafe("marwing_down", dt) + delta_strafe("marwing_up", dt),
				-max_perpen.y, max_perpen.y);
		if 0 != perpen.y and 0 == Input.get_action_strength("marwing_up") and 0 == Input.get_action_strength("marwing_down"):
			perpen.y = perpen.y + (dt * strafe_speed * (-0.75 if 0 < perpen.y else 0.75));
			if abs(perpen.y) < (dt * strafe_speed * 0.75): perpen.y = 0;
		$Mesh.translation.y = perpen.y;

		# apply rotation to emphasize strafing
		if 0 != perpen.x: $Mesh.rotation_degrees.z = max_lean.x * (-perpen.x / max_perpen.x);
		if 0 != perpen.y: $Mesh.rotation_degrees.x = max_lean.y * (perpen.y / max_perpen.y);

	pass;

## Calculates how much weight a given input should have on the ship's strafe offset by factoring in strafe speed and input strength.
#  @input_name		the input to check for
#  @dt				the amount of time, in seconds, since the last physics process
func delta_strafe (input_name: String,dt: float) -> float:
	if Input.is_action_pressed(input_name):
		return dt * strafe_speed * Input.get_action_strength(input_name);
	return float(0);
