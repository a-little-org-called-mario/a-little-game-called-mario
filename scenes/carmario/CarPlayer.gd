extends KinematicBody2D

const ACCELERATION :float= 15.0
const MAX_SPEED :float= 100.0
const TURN_SPEED :float= 200.0
const ROAD_SPEED :float= 400.0
const MAX_HEALTH :float= 100.0

var velocity := Vector2()
var real_velocity := Vector2()
var terrain_counter :int= 0
var upside_down := false

onready var sprite = $Sprite
var _car_ui :Control
var health:= MAX_HEALTH setget set_health, get_health
var distance_traveled:= 0.0
var felonies := 0

func _ready():
	sprite.connect("animation_finished", self, "_sprite_animation_finished")
	$AnimationPlayer.connect("animation_finished", self, "_player_animation_finished")
	var arr= get_tree().get_nodes_in_group("car_ui")
	if !arr.empty():
		_car_ui= arr[0]
		_car_ui.show()
	else:
		set_process(false)

func _exit_tree():
	if _car_ui:
		_car_ui.hide()

func _physics_process(delta):
	var braking := false
	var speed_multiplier := 1.0
	if health <= 0:
		speed_multiplier= 0.0
		braking= true
	if terrain_counter > 0:
		speed_multiplier= 0.75
		self.health-= delta
		braking= true
		if real_velocity.x > 0:
			$Noise.play()
	
	var input := Input.get_vector("left","right","up","down")
	if upside_down:
		input.y*= -1
	
	if input.x < 0:
		velocity.x= min(velocity.x, max(velocity.x - ACCELERATION * speed_multiplier, -ROAD_SPEED * 0.5 * speed_multiplier))
		braking= true
		$Noise.play()
		self.health-= delta
	if input.x > 0:
		velocity.x= max(velocity.x, min(velocity.x + ACCELERATION * speed_multiplier, MAX_SPEED * speed_multiplier))
	if input.y < 0:
		velocity.y= min(velocity.y, max(velocity.y - TURN_SPEED * speed_multiplier, -TURN_SPEED * speed_multiplier))
		braking= true
	if input.y > 0:
		velocity.y= max(velocity.y, min(velocity.y + TURN_SPEED * speed_multiplier, TURN_SPEED * speed_multiplier))
		braking= true
	real_velocity= (velocity + Vector2.RIGHT * ROAD_SPEED * speed_multiplier) * delta
	var col := move_and_collide(real_velocity)
	distance_traveled+= real_velocity.x
	if col:
		velocity.x= max(-ROAD_SPEED, velocity.x - abs(velocity.x * 0.5))
		$Oof.play()
		if col.collider.is_in_group("enemy"):
			if col.collider.has_method("kill"):
				col.collider.kill(self)
				felonies+= 1
			if !upside_down:
				sprite.animation= "angry"
			velocity.y= 0.0
			self.health-= 10 * max(0.5, range_lerp(velocity.x, 0, MAX_SPEED, 0.5, 1.0))
		elif col.collider.is_in_group("immovable_object"):
			self.health= 0
			velocity= Vector2.ZERO
			felonies+= 1
		else:
			self.health-= delta * 25
	else:
		velocity.y*= 0.9
		velocity.x*= 0.99
	braking= braking and !$AnimationPlayer.current_animation == "flip"
	$Trail1.emitting= braking
	$Trail2.emitting= braking

func _process(_delta):
	$Offset.position.x= position.x + get_viewport().size.x * 0.4
	_car_ui.set_speed(round(real_velocity.x * 100))
	_car_ui.set_distance(round(distance_traveled))
	_car_ui.set_health(health / MAX_HEALTH)
	_car_ui.set_felonies(round(felonies))

func _input(event :InputEvent):
	if event.is_action_pressed("shoot"):
		$Sprite/Honk.play(range_lerp(health, 0, MAX_HEALTH, 0.75, 1.0))

func set_health(value):
	health= clamp(value, 0, MAX_HEALTH)
	if health <= 0 and sprite.animation != "car_only":
		sprite.animation= "car_only"
		$Shape.set_deferred("disabled",true)
		$AnimationPlayer.play("die")
func get_health() -> float:
	return health

func terrain_entered():
	terrain_counter+= 1
	felonies+= 1
	if terrain_counter > 0 and !$AnimationPlayer.is_playing():
		$AnimationPlayer.play("shake")
func terrain_exited():
	terrain_counter-= 1
	if terrain_counter == 0 and $AnimationPlayer.current_animation == "shake":
		$AnimationPlayer.play("RESET")

func slip():
	if $AnimationPlayer.current_animation == "flip" or $AnimationPlayer.current_animation == "die": return
	$AnimationPlayer.play("flip")
	$Aaa.play()
	set_collision_mask_bit(3, false)

func _sprite_animation_finished():
	if sprite.animation == "angry":
		sprite.animation= "idle"

func _player_animation_finished(anim):
	match anim:
		"die":
			EventBus.emit_signal("player_died")
		"flip":
			upside_down= not upside_down
			if sprite.animation != "car_only" and upside_down:
				sprite.animation= "upside_down" 
			elif sprite.animation == "upside_down" and !upside_down:
				sprite.animation= "idle"
			set_collision_mask_bit(3, true)
			felonies+= int(upside_down)
