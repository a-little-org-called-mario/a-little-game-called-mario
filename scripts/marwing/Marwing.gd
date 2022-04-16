# extends PathFollow

# # Stats
# var hp : int = 100;			
# var max_hp : int = 100;
# var fire_rate : int = 8;				# how many times we can fire per second
# var speed : float = 16.6;				# how far along the path we go per second
# var strafe : float = 5.2;				# how far the ship can strafe per second
# var p_offset : Vector2 = Vector2.ZERO;	# the perpendicular offset between the ship and the rail
# var max_h_offset : float = 2.7;
# var max_v_offset : float = 1.8;
# var max_h_lean : float = 15;
# var max_v_lean : float = 17.5;

# # State information
# var can_shoot : bool = false;
# var can_move : bool = true;
# var invulnerable : bool = false;

# func _ready ():
# 	$AnimationPlayer.play("normal");
# 	$Camera.set_current(true);
# 	pass;

# func _physics_process (dt: float):
# 	if can_move:
# 		# Move along path
# 		offset = offset + (dt * speed);

# 		# Horizontal perpendicular movement
# 		p_offset.x = clamp(p_offset.x - move_delta("marwing_right",dt) + move_delta("marwing_left",dt), -max_h_offset, max_h_offset);
# 		if 0 == Input.get_action_strength("marwing_right") and 0 == Input.get_action_strength("marwing_left") and 0 != p_offset.x:
# 			p_offset.x = p_offset.x + (strafe * dt * (-0.75 if 0 < p_offset.x else 0.75));
# 			if abs(p_offset.x) < (strafe * dt * 0.75): p_offset.x = 0;
# 		$Mesh.translation.x = p_offset.x;

# 		# Vertical perpendicular movement
# 		p_offset.y = clamp(p_offset.y - move_delta("marwing_down",dt) + move_delta("marwing_up",dt), -max_v_offset, max_v_offset);
# 		if 0 == Input.get_action_strength("marwing_down") and 0 == Input.get_action_strength("marwing_up") and 0 != p_offset.y:
# 			p_offset.y = p_offset.y + (strafe * dt * (-0.75 if 0 < p_offset.y else 0.75));
# 			if abs(p_offset.y) < (strafe * dt * 0.75): p_offset.y = 0;
# 		$Mesh.translation.y = p_offset.y;

# 		# Apply rotation to emphasize perpendicular movement
# 		if 0 != p_offset.x:	$Mesh.rotation_degrees.z = max_h_lean * (-p_offset.x / max_h_offset);
# 		if 0 != p_offset.y: $Mesh.rotation_degrees.x = max_v_lean * (p_offset.y / max_v_offset);

# func move_delta (input_name: String,dt: float) -> float:
# 	if Input.is_action_pressed(input_name):
# 		var input_strength: float = Input.get_action_strength(input_name);
# 		return strafe * dt * input_strength;
# 	return float(0);

# func set_invulnerable (inv: bool = false):
# 	invulnerable=inv;

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
