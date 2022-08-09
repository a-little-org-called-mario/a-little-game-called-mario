extends Enemy

export var speed := 200.0

enum State {IDLE, WAKE, ACTIVE, SLEEP}
export(State) var state := State.IDLE

var targetRelPosition := Vector2(0,0)

onready var raycast := $RayCast2D
onready var sprite := $Sprite

#Hitbox.gd checks this
# warning-ignore:unused_class_variable
var damage = 0

func move(_delta):
	var playerRelPosition = get_player_pos()
	raycast.cast_to = playerRelPosition
	
	match state:
		State.IDLE:
			if raycast.get_collider() is Player:
				targetRelPosition = playerRelPosition
				wake()
		
		State.ACTIVE:
			if raycast.get_collider() is Player:
				targetRelPosition = playerRelPosition
			move_and_slide(targetRelPosition.normalized() * speed)
	
	
func get_player_pos() -> Vector2:
	var target : Node2D = get_tree().get_nodes_in_group("Player")[0]
	return target.global_position - global_position
	
	
func wake():
	assert(state == State.IDLE)
	state = State.WAKE
	sprite.play("wake")
	
	
func sleep():
	assert(state == State.ACTIVE)
	state = State.SLEEP
	sprite.play("sleep")
	damage = 0
	
	
func _on_AnimatedSprite_animation_finished():
	match state:
		State.WAKE:
			state = State.ACTIVE
			sprite.play("active")
			damage = 1
			
		State.SLEEP:
			state = State.IDLE
			sprite.play("idle")
