class_name Water
extends Area2D

#Warning: Although things can be in multiple water areas at the same time, do not allow
# anything to be in water areas with different multipliers at the same time.
# Strange things will happen.
export var gravity_multiplier := 0.2
export var jump_multiplier := 0.5
export var float_gravity_multiplier := -0.1

const IN_WATER_GROUP := "in_water"
const WATER_COUNT_META := "water_count"


func _physics_process(_delta):
	var bodies := get_overlapping_bodies()
	for temp_body in bodies:
		var body : PhysicsBody2D = temp_body
		if "double_jump" in body:
			body.double_jump = true


func _on_body_entered(body: Node):
	#This keeps a count of how many water areas a body is in.
	#This count is needed so physics work correctly when a body is touching multiple water areas.
	var old_water_count := 0
	if body.has_meta(WATER_COUNT_META):
		old_water_count = body.get_meta(WATER_COUNT_META)
	body.set_meta(WATER_COUNT_META, old_water_count + 1)
	body.add_to_group(IN_WATER_GROUP)
	
	if old_water_count == 0: #The body was not in water already
		if "gravity" in body:
			body.gravity.strength *= gravity_multiplier
		if "jump_force" in body:
			body.jump_force *= jump_multiplier
		if "gravity_scale" in body:
			body.gravity_scale *= float_gravity_multiplier


func _on_body_exited(body: Node):
	assert(body.has_meta(WATER_COUNT_META))
	var old_water_count : int = body.get_meta(WATER_COUNT_META)
	body.set_meta(WATER_COUNT_META, old_water_count - 1)
	
	if old_water_count == 1: #The body just exited the last water area
		body.remove_from_group(IN_WATER_GROUP)
		if "gravity" in body:
			body.gravity.strength /= gravity_multiplier
		if "jump_force" in body:
			body.jump_force /= jump_multiplier
		if "gravity_scale" in body:
			body.gravity_scale /= float_gravity_multiplier
	
