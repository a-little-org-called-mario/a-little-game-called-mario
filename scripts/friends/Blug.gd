extends Area2D


const SPEED = 2
const DIST = 64

onready var _sprite := $Sprite
onready var _text_trigger := $TextTrigger

export (String, MULTILINE) var dialog = "blug\nglug\nhello"
var queue := []

func _ready():
	$Collision.visible = true
	fill_queue()

func _physics_process(delta):
	var playPos = Vector2()
	for body in get_overlapping_bodies():
		if body is Player:
			playPos = body.position
	
	if playPos.x > position.x + DIST:
		position.x += SPEED
		_sprite.scale.x = 2
	elif playPos.x < position.x - DIST:
		position.x -= SPEED
		_sprite.scale.x = -2

func _on_TextTrigger_body_exited(_body):
	randomize()
	if randf() > 0.3:
		if queue.empty():
			fill_queue()
		if !queue.empty():
			_text_trigger.text = queue.pop_back()
	else:
		_text_trigger.text = "blug"

func fill_queue():
	queue = dialog.split("\n")
	queue.shuffle()
