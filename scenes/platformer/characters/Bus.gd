extends Sprite

export(NodePath) var collision_shape: NodePath

var inventory = preload("res://scripts/resources/PlayerInventory.tres")

onready var player : Player = owner
onready var sprite : AnimatedSprite = player.get_node("BusSprite")
#onready var collision : CollisionShape2D = player.get_node("BusCollision")
onready var horn_sound : AudioStreamPlayer = sprite.get_node("Horn")
onready var resting_sound : AudioStreamPlayer2D = sprite.get_node("brrrrrrrrr")
onready var moving_sound : AudioStreamPlayer2D = sprite.get_node("moving_sound")

enum busState {RESTING, MOVING};
var state
onready var collision: CollisionShape2D = get_node(collision_shape)



func _ready() -> void:
	state = busState.RESTING
	EventBus.connect("bus_collected", self, "_on_bus_collected")
	call_deferred("_activate_bus", inventory.has_bus)


func _process(_delta: float) -> void:
	if inventory.has_bus:
		player.powerupspeed = 4
		player.powerupaccel = 2
	else:
		player.powerupspeed = 1
		player.powerupaccel = 1
	#print(player.x_motion.get_speed())
	#print(state)
	#if player.x_motion.get_speed() <= player.STOPTHRESHOLD and state != busState.RESTING:
		#_set_state(busState.RESTING)
	#elif player.x_motion.get_speed() != 0 and state == busState.RESTING:
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



#func _activate_bus() -> void:
#	sprite.visible = true
#	collision.set_deferred("disabled", false)
#	call_deferred("_update_player", true)
#	set_process(true)

func _activate_bus(active: bool) -> void:
	# Sprites
	visible = active
	player.sprite.visible = !active

	# Collision
	collision.disabled = !active
	player.collision.disabled = active
  set_process(active)
  
  var trail: Line2D = player.get_node_or_null("Trail")
	if trail != null:
		trail.height = 15 if active else 30

func _update_player(on : bool) -> void:
	
	player.sprite.visible = !on
	player.get_node("CollisionShape2D").set_deferred("disabled", on)
	player.get_node("BouncyMoustache").visible = !on
  

func _set_state(newState):
	if(state == newState):
		return
	if (newState == busState.RESTING):
		sprite.animation = "standing"
		sprite.playing = false
		resting_sound.playing = true # When more state sounds are added that continuously should play
		moving_sound.playing = false # make all the sounds an dictionary.
	if (newState == busState.MOVING):
		sprite.animation = "driving"
		sprite.playing = true
		moving_sound.playing = true
		resting_sound.playing = false
	state = newState

func _play_horn():
	horn_sound.play()

func exit_bus():
	sprite.visible = false
	sprite.playing = false
	collision.set_deferred("disabled", true)
	call_deferred("_update_player", false)
	set_process(false)