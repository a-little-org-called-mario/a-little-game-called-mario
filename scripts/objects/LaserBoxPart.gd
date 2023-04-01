tool
extends RayCast2D


var endPoint = Vector2(0,0)
var halfX = 0
var activateTimer = -1
var deactivateTimer = -1

onready var _line = $Line
onready var _dot = $DotLine
onready var _sprite = $Sprite
onready var _hitbox = $Hitbox
onready var _collision = $Hitbox/Collision


func _ready():
	$Line.width = false
	$Hitbox/Collision.disabled = true


func _physics_process(_delta):
	find_end_point()
	
	if activateTimer >= 0:
		handle_activate()
	elif deactivateTimer >= 0:
		handle_deactivate()
	
	_line.points[1] = endPoint
	_dot.points[1] = endPoint
	_collision.scale.x = halfX
	_collision.position.x  = halfX


func find_end_point():
	if is_colliding():
		endPoint = to_local(get_collision_point())
		halfX = endPoint.x / 2
	else:
		endPoint = Vector2(1500, 0)
		halfX = 750


func handle_activate():
	activateTimer += 1
	
	if activateTimer == 1:
		_line.width = 8
	elif activateTimer == 5:
		_line.width = 0
	elif activateTimer == 9:
		_line.width = 16
	elif activateTimer == 10:
		_line.width = 24

	elif activateTimer == 11:
		_line.width = 32
	elif activateTimer == 13:
		_collision.disabled = false
		activateTimer = -1


func handle_deactivate():
	deactivateTimer += 1
	
	if deactivateTimer == 1:
		_collision.disabled = true
		_line.width = 24
	elif deactivateTimer == 2:
		_line.width = 16
	elif deactivateTimer == 3:
		_line.width = 8
	elif deactivateTimer == 4:
		_line.width = 0
		deactivateTimer = -1


func activate():
	activateTimer = 0


func deactivate():
	deactivateTimer = 0
