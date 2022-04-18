extends Node2D
class_name BouncyMoustache

onready var player: Player = owner

onready var line1 = $DampedSpringJoint2D/point1/Line2D
onready var segment1 = $DampedSpringJoint2D/point2
onready var rightSegment = $DampedSpringJoint2D
onready var curve1: Curve2D = Curve2D.new()

onready var line2 = $DampedSpringJoint2D2/point1/Line2D
onready var segment2 = $DampedSpringJoint2D2/point2
onready var leftSegment = $DampedSpringJoint2D2
onready var curve2: Curve2D = Curve2D.new()

onready var base_position_y: float = position.y
const vecOffset = Vector2(0, 10)


func _process(_delta):
	position.y = base_position_y + (0.0 if not player.crouching else 17.5)

	line1.global_rotation = rightSegment.rotation
	for _p in range(curve1.get_point_count()):
		curve1.remove_point(0)
	curve1.add_point(line1.position, vecOffset, vecOffset)
	curve1.add_point(segment1.position)
	line1.points = curve1.get_baked_points()

	line2.global_rotation = leftSegment.rotation
	for _p in range(curve2.get_point_count()):
		curve2.remove_point(0)
	curve2.add_point(line2.position, vecOffset, vecOffset)
	curve2.add_point(segment2.position)
	line2.points = curve2.get_baked_points()
