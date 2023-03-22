extends Node2D
class_name BouncyMoustache

onready var player: Player = owner

onready var line1 = $DampedSpringJointR/point1R/LineR
onready var segment1 = $DampedSpringJointR/point2R
onready var rightSegment = $DampedSpringJointR
onready var curve1: Curve2D = Curve2D.new()

onready var line2 = $DampedSpringJointL/point1L/LineL
onready var segment2 = $DampedSpringJointL/point2L
onready var leftSegment = $DampedSpringJointL
onready var curve2: Curve2D = Curve2D.new()

onready var base_position_y: float = position.y
const vecOffset = Vector2(0, 10)


func _process(_delta):
	position.y = base_position_y + (0.0 if not player.crouching else 17.5)

	line1.global_rotation = rightSegment.rotation
	curve1.clear_points()
	curve1.add_point(line1.position, vecOffset, vecOffset)
	if self.global_scale.x > 0:
		curve1.set_point_out(0, curve1.get_point_out(0) * Vector2(-1.0, 1.0))
	curve1.add_point(segment1.position)
	line1.points = curve1.get_baked_points()

	line2.global_rotation = leftSegment.rotation
	curve2.clear_points()
	curve2.add_point(line2.position, vecOffset, vecOffset)
	if self.global_scale.x > 0:
		curve2.set_point_out(0, curve2.get_point_out(0) * Vector2(-1.0, 1.0))
	curve2.add_point(segment2.position)
	line2.points = curve2.get_baked_points()
