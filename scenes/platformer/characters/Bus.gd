extends AnimatedSprite

export(NodePath) var collision_shape: NodePath
export(NodePath) onready var hitbox_collision = get_node(hitbox_collision) as CollisionShape2D

var inventory = preload("res://scripts/resources/PlayerInventory.tres")

onready var player : Player = owner
onready var horn_sound : AudioStreamPlayer = get_node("Horn")
onready var resting_sound : AudioStreamPlayer2D = get_node("brrrrrrrrr")
onready var moving_sound : AudioStreamPlayer2D = get_node("moving_sound")
onready var collision: CollisionShape2D = get_node(collision_shape)
onready var attack_box : Area2D = $BusAttackBox

enum busState {RESTING, MOVING};
var state


func _ready() -> void:
	EventBus.connect("bus_collected", self, "_on_bus_collected")
	call_deferred("_activate_bus", inventory.has_bus)


func _process(_delta: float) -> void:
	
	if  (Input.is_action_pressed("right") or Input.is_action_pressed("left")):
		_set_state(busState.MOVING)
	else:
		_set_state(busState.RESTING) 
		
	if Input.is_action_just_pressed("make_sound"):
		_play_horn();
	if Input.is_action_just_released("undo"):
		exit_bus()


func _on_bus_collected(data: Dictionary) -> void:
	if data.has("collected"):
		inventory.has_bus = data["collected"]
		call_deferred("_activate_bus", inventory.has_bus)

func _activate_bus(active: bool) -> void:
	# Sprites
	visible = active
	player.sprite.visible = !active

	# Collision
	collision.disabled = !active
	hitbox_collision.disabled = !active	
	player.collision.disabled = active 
	set_process(active)
	inventory.has_bus = active # does nothing if already active.
	var trail: Line2D = player.get_node_or_null("Trail")
	if trail != null:
		trail.height = 15 if active else 30
	var moustache = get_parent().get_node_or_null("BouncyMoustache")
	if moustache != null:
		moustache.visible = !active
	
	if (!active):
		player.powerupspeed = 1
		player.powerupaccel = 1
		moving_sound.playing = false 
		resting_sound.playing = false
	else:
		player.powerupspeed = 4
		player.powerupaccel = 2

func _set_state(newState):
	if(state == newState):
		return
	if (newState == busState.RESTING):
		animation = "standing"
		playing = true
		resting_sound.play(resting_sound.get_playback_position()) # When more state sounds are added that continuously should play
		moving_sound.playing = false # make all the sounds a dictionary.
		attack_box.activate(false)
	if (newState == busState.MOVING):
		animation = "driving"
		playing = true
		moving_sound.play(moving_sound.get_playback_position())
		resting_sound.playing = false
		attack_box.activate(true)
	state = newState

func _play_horn():
	horn_sound.play()

func exit_bus():
	attack_box.activate(false)
	call_deferred("_activate_bus", false)
