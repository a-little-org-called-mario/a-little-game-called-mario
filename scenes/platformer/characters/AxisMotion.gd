extends Object

class_name AxisMotion

# X defines a shorthand for the X axis of motion.
const X = Vector2(1, 0)
# Y defines a shorthand for the Y axis of motion.
const Y = Vector2(0, 1)

# Defines the vector along which motion is applied
# for this AxisMotion object. E.g., setting axis to (1, 0)
# will have all motion applied only to the x-axis.
# Defaults to (1, 1).
var _axis = Vector2(1, 1)
# Defines the maximum speed of this AxisMotion object.
var max_speed = 0.0
# Defines the maximum acceleration of this AxisMotion object.
var max_accel = 0.0
# Defines the maximum jerk of this AxisMotion object.
var max_jerk = 0.0

# Calculated vector motion of this object.
var _motion = Vector2()
# Calculated acceleration of this object.
var _accel = Vector2()
# Calculated jerk of this object.
var _jerk = Vector2()


# Initializes this AxisMotion with the given values.
# axis is normalized and then returned as a positive vector.
func _init(axis: Vector2, speed_max: float, accel_max: float, jerk_max: float):
	_axis = axis.normalized().abs()
	max_speed = speed_max
	max_accel = accel_max
	max_jerk = jerk_max


# Sets the axis of this motion to the (normalized) axis.
func set_axis(axis: Vector2):
	_axis = axis.normalized()


# Updates the motion vector of this object, then
# returns the updated vector for convenience.
# Applies current jerk and acceleration, then sets
# the new speed of the vector.
func update_motion() -> Vector2:
	_accel = (_accel + _jerk).clamped(max_accel)
	_motion = (_motion + _accel).clamped(max_speed)
	return _motion


# Gets the current motion vector of this object.
func get_motion() -> Vector2:
	return _motion


# Projects the given motion vector onto the axis
# of this object, then sets the motion vector to the result.
# Ignores max_speed.
# Useful for setting motion with move_and_slide.
func set_motion(motion: Vector2):
	_motion = motion.project(_axis)


# Sets the speed of this AxisMotion to new_speed.
func set_speed(new_speed: float):
	_motion = (_axis * new_speed).clamped(max_speed)


# Gets the current speed of this object.
func get_speed() -> float:
	return _motion.dot(_axis)


# Adds the given speed added_speed to this AxisMotion.
func add_speed(added_speed: float):
	set_speed(_motion.dot(_axis) + added_speed)


# Linearlly interpolates the speed towards the target speed
# as scaled by weight. Useful if you wish to add automatic
# deceleration along an axis.
func interpolate_speed(target_speed: float, weight: float):
	set_speed(lerp(target_speed, _motion.length(), weight))


# Sets the acceleration of this AxisMotion to new_accel.
func set_accel(new_accel: float):
	_accel = (_axis * new_accel).clamped(max_accel)


# Adds the given acceleration added_accel to this AxisMotion.
func add_accel(added_accel: float):
	set_accel(_accel.dot(_axis) + added_accel)


# Gets the current acceleration of this object.
func get_accel() -> float:
	return _accel.dot(_axis)


# Sets the jerk of this AxisMotion to new_jerk.
func set_jerk(new_jerk: float):
	_jerk = (_axis * new_jerk).clamped(max_jerk)


# Adds the given jerk added_jerk to this AxisMotion.
func add_jerk(added_jerk: float):
	set_jerk(_jerk.dot(_axis) + added_jerk)


# Gets the current jerk of this object.
func get_jerk() -> float:
	return _jerk.dot(_axis)
