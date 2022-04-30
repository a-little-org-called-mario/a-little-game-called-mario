extends Enemy

const GRAVITY := 100
const MAX_FALL_SPEED := 500

export (float) var acceleration := 15.0
export (float) var max_velocity := 150.0
export (bool) var auto_start := false
export (bool) var go_left := false
export (NodePath) onready var trigger_area = get_node_or_null(trigger_area)

var velocity := Vector2()
var started := false

func _ready():
	$KillArea.connect("body_entered", self, "_body_touched")
	if auto_start:
		start_bus()
	if trigger_area:
		trigger_area.connect("body_entered", self, "_trigger_entered")
	_sprite.flip_h= !go_left

func start_bus():
	if started or $AnimationPlayer.is_playing(): return
	$AnimationPlayer.play("startup")
	yield($AnimationPlayer,"animation_finished")
	velocity.x+= acceleration
	if go_left:
		velocity.x*= -1
	started= true

func kill(_killer):
	pass

func move(delta):
	if started:
		velocity.x= max(abs(velocity.x) + acceleration, max_velocity) * sign(velocity.x)
	velocity.y= max(velocity.y + GRAVITY, MAX_FALL_SPEED)
	move_and_slide(velocity * delta, Vector2.UP)
	if is_on_floor():
		velocity.y= 0.0
	pass


func _trigger_entered(body):
	if body.is_in_group("Player"):
		start_bus()

func _body_touched(body):
	if body != self and body.is_in_group("enemy") and body.has_method("kill"):
		body.kill(self)
	elif body.is_in_group("Player"):
		HeartInventoryHandle.change_hearts_on(body, -1)
