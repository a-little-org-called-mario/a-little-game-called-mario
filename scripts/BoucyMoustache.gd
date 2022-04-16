extends Node2D
class_name BouncyMoustache

onready var line1 = $DampedSpringJoint2D/point1/Line2D
onready var segment2 = $DampedSpringJoint2D/point2
onready var rightSegment = $DampedSpringJoint2D

onready var line2 = $DampedSpringJoint2D2/point1/Line2D
onready var segment22 = $DampedSpringJoint2D2/point2
onready var leftSegment = $DampedSpringJoint2D2


func _process(_delta):
	# line1.global_position = Vector2.ZERO
	line1.global_rotation = rightSegment.rotation
	for p in range(len(line1.points)):
		line1.remove_point(0)
	line1.add_point(line1.position)
	line1.add_point(segment2.position)

	line2.global_rotation = leftSegment.rotation
	for p in range(len(line2.points)):
		line2.remove_point(0)
	line2.add_point(line2.position)
	line2.add_point(segment22.position)
