extends Node


var inventory = preload("res://scripts/resources/PlayerInventory.tres")
onready var player : Player = owner
onready var sprite : AnimatedSprite = player.get_node("BusSprite")
onready var collision : CollisionShape2D = player.get_node("BusCollision")
onready var horn_sound : AudioStreamPlayer = sprite.get_node("Horn")

enum busState {RESTING, MOVING};
var state



func _ready() -> void:
	state = busState.RESTING
	EventBus.connect("bus_collected", self, "_on_bus_collected")
	if inventory.has_bus:
		_activate_bus()
	else:
		set_process(false)


func _process(_delta: float) -> void:
	sprite.flip_h = !player.sprite.flip_h
	if inventory.has_bus:
		player.powerupspeed = 4
		player.powerupaccel = 2
	else:
		player.powerupspeed = 1
		player.powerupaccel = 1
	#print(player.x_motion.get_speed())
	#print(state)
	#if player.x_motion.get_speed() <= player.STOPTHRESHOLD and state != busState.RESTING:
		#_change_state(busState.RESTING)
	#elif player.x_motion.get_speed() != 0 and state == busState.RESTING:
	if Input.is_action_pressed("right") or Input.is_action_pressed("left"):
		_change_state(busState.MOVING)
	else:
		_change_state(busState.RESTING) 
		
	if Input.is_action_just_pressed("make_sound"):
		_play_horn();
	if Input.is_action_just_released("undo"):
		exit_bus()


func _on_bus_collected(data: Dictionary) -> void:
	if data.has("collected"):
		inventory.has_bus = data["collected"]
		_activate_bus()


func _activate_bus() -> void:
	sprite.visible = true
	sprite.playing = true
	collision.set_deferred("disabled", false)
	call_deferred("_update_player", true)
	set_process(true)


func _update_player(on : bool) -> void:
	
	player.sprite.visible = !on
	player.get_node("CollisionShape2D").set_deferred("disabled", on)
	var trail: Line2D = player.get_node_or_null("Trail")
	if trail != null:
		trail.height = 15


func _change_state(newState):
	if (newState == busState.RESTING):
		sprite.animation = "standing"
		sprite.playing = false
	if (newState == busState.MOVING):
		sprite.animation = "driving"
		sprite.playing = true
	state = newState

func _play_horn():
	horn_sound.play()

func exit_bus():
	sprite.visible = false
	sprite.playing = false
	collision.set_deferred("disabled", true)
	call_deferred("_update_player", false)
	set_process(false)
