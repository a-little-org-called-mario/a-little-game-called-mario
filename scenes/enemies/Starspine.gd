extends Enemy

export var speed := 200.0
export var health := 3
export var time_until_sleep := 1.0 #How long the Starspine stays active when it can't see the player
export var hurt_flash_duration := 0.15
export var hurt_flash_color := Color(1.0, 0.5, 0.5)

enum State {IDLE, WAKE, ACTIVE, SLEEP}
export(State) var state := State.IDLE

var targetRelPosition := Vector2(0,0)

onready var raycast := $RayCast2D
onready var sprite := $Sprite
onready var sleep_timer := $SleepTimer
onready var hurt_flash_timer := $HurtFlashTimer

#Hitbox.gd checks this
# warning-ignore:unused_class_variable
var damage = 0


# warning-ignore:shadowed_variable
func kill(killer: Object, damage: int = 1) -> void:
	_damage(damage, killer)


func _damage(dmg: int, killer: Object) -> void:
	sprite.modulate = hurt_flash_color
	hurt_flash_timer.start(hurt_flash_duration)
	
	health = health - dmg
	if health <= 0:
		.kill(killer)


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
				sleep_timer.stop()
			else:
				if sleep_timer.is_stopped():
					sleep_timer.start(time_until_sleep)
			move_and_slide(targetRelPosition.normalized() * speed)
	
	
func get_player_pos() -> Vector2:
	var target_group = get_tree().get_nodes_in_group("Player")
	if target_group.size() > 0:
		var target : Node2D = target_group[0]
		return target.global_position - global_position
	return Vector2.ZERO
	
	
func wake():
	assert(state == State.IDLE)
	state = State.WAKE
	sprite.play("wake")
	
	
func sleep():
	assert(state == State.ACTIVE)
	sleep_timer.stop()
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


func _on_SleepTimer_timeout():
	sleep()


func _on_HurtFlashTimer_timeout():
	sprite.modulate = Color(1.0, 1.0, 1.0)
