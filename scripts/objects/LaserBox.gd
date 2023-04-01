tool
extends StaticBody2D


var timer = -1

export var enableTop = false
export var enableRight = false
export var enableBottom = false
export var enableLeft = false

export var activate = 0
export var deactivate = 30
export var loop = 60


onready var _top = $TopPart
onready var _right = $RightPart
onready var _bottom = $BottomPart
onready var _left = $LeftPart


func _physics_process(delta):
	show_parts()
	do_loop()


func show_parts():
	_top.visible = enableTop
	_bottom.visible = enableBottom
	_left.visible = enableLeft
	_right.visible = enableRight



func do_loop():
	timer += 1
	if timer >= loop:
		timer = 0
	
	if timer == activate:
		if enableTop:
			_top.activate()
		if enableRight:
			_right.activate()
		if enableBottom:
			_bottom.activate()
		if enableLeft:
			_left.activate()

	if timer == deactivate:
		if enableTop:
			_top.deactivate()
		if enableRight:
			_right.deactivate()
		if enableBottom:
			_bottom.deactivate()
		if enableLeft:
			_left.deactivate()
