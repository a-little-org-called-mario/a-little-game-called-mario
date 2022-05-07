extends MarwingShip

export var crosshair_range : Vector2;
export var crosshair_speed: float;
var crosshair_pos: Vector2 = Vector2.ZERO;

onready var camera: Camera = get_node("Camera");
onready var mesh: MeshInstance = get_node("Mesh");
onready var crosshair: Sprite3D = get_node("Crosshair");

func _ready ():
	camera.set_current(true);

func _physics_process (dt: float):
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
		mesh.translation.x = perpen.x;        # apply offset to mesh

		# vertical strafing
		perpen.y = clamp(
				perpen.y - delta_strafe("marwing_down", dt) + delta_strafe("marwing_up", dt),
				-max_perpen.y, max_perpen.y);
		if 0 != perpen.y and 0 == Input.get_action_strength("marwing_up") and 0 == Input.get_action_strength("marwing_down"):
			perpen.y = perpen.y + (dt * strafe_speed * (-0.75 if 0 < perpen.y else 0.75));
			if abs(perpen.y) < (dt * strafe_speed * 0.75): perpen.y = 0;
		mesh.translation.y = perpen.y;

		# apply rotation to emphasize strafing
		if 0 != perpen.x: mesh.rotation_degrees.z = max_lean.x * (-perpen.x / max_perpen.x);
		if 0 != perpen.y: mesh.rotation_degrees.x = max_lean.y * (perpen.y / max_perpen.y);

	# handle aiming & shooting
	if can_shoot:
		crosshair_pos.x = clamp(
			crosshair_pos.x - delta_aim("marwing_aimright", dt) + delta_aim("marwing_aimleft", dt),
			-crosshair_range.x, crosshair_range.x);
		crosshair.translation.x = crosshair_pos.x;

		crosshair_pos.y = clamp(
			crosshair_pos.y - delta_aim("marwing_aimdown", dt) + delta_aim("marwing_aimup", dt),
			-crosshair_range.y, crosshair_range.y);
		crosshair.translation.y = crosshair_pos.y;

		if Input.is_action_pressed("marwing_shoot"):
			shoot(mesh.translation,crosshair.translation-mesh.translation);

## Calculates how much weight a given input should have on the ship's strafe offset by factoring in strafe speed and input strength.
#  @input_name        the input to check for
#  @dt                the amount of time, in seconds, since the last physics process
func delta_strafe (input_name: String,dt: float) -> float:
	if Input.is_action_pressed(input_name):
		return dt * strafe_speed * Input.get_action_strength(input_name);
	return float(0);

func delta_aim (input_name: String,dt: float) -> float:
	if Input.is_action_pressed(input_name):
		return dt * crosshair_speed * Input.get_action_strength(input_name);
	return float(0);
