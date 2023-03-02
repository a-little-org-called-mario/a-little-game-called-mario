extends KinematicBody2D

export var velocity := Vector2.ZERO
export var jump_force := -300
export var gravity_vec := Vector2.DOWN * 270

export var sound_db := -1
export var sound_pitch_scale := 0.85

export var escape_time := 0.5 #The cat can not be recollected for this many seconds after it spawns, to avoid immediately recollecting it

export(PackedScene) var cat_scene = preload("res://scenes/friends/Cat.tscn")

var collected := false

onready var escape_timer := $Timer
onready var audio_meow := $MeowStream


func _ready():
	escape_timer.start(escape_time)
	
	audio_meow.volume_db = sound_db
	audio_meow.pitch_scale = sound_pitch_scale
	
	audio_meow.play()
	

func _physics_process(delta):
	velocity += gravity_vec * delta
	move_and_slide(velocity, Vector2.UP)
	if is_on_floor():
		velocity.y = jump_force
		audio_meow.play()
	if is_on_wall():
		velocity.x *= -1
	if is_on_ceiling(): #BONK! You fall down now
		velocity.y = max(0, velocity.y)
		
		
func collect():
	collected = true
	
	visible = false
	set_physics_process(false)
	
	audio_meow.volume_db = 0
	audio_meow.pitch_scale = 1.05
	audio_meow.play()


func _on_PlayerHitbox_body_entered(body : KinematicBody2D):
	if collected:
		return
	if escape_timer.time_left > 0:
		return
	if not body is Player:
		return
	
	var cat = cat_scene.instance()
	get_parent().call_deferred("add_child", cat)
	cat.set_player(body)
	cat.global_position = global_position
	
	collect()



func _on_MeowStream_finished():
	if collected:
		queue_free()
