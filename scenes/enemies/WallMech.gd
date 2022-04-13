# Using the Enemy class that someone else made.
# The Bub enemy is using collision layer 4 and mask 2 so this enemy is as well.
# Also reusing the res://scenes/enemies/Bullet.tscn and res://scenes/SimpleExplosion.tscn for now
extends Enemy

onready var turret_sfx : AudioStreamPlayer2D = $TurretSound
onready var shoot_timer : Timer = $ShootTimer
onready var move_timer : Timer = $MoveTimer
onready var shoot_delay : Timer = $ShootDelayTimer

var _moving : bool = true
var _motion = Vector2.ZERO
var _col : KinematicCollision2D
var muzzles : Array = []

export(float) var max_speed = 0.75
export(Vector2) var shoot_direction = Vector2.LEFT
export(Vector2) var move_direction = Vector2.DOWN
export(PackedScene) var bullet_scene
export(PackedScene) var muzzle_flash_scene

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for child in $Muzzles.get_children():
		muzzles.append(child)
	shoot_timer.start()


func ai(_delta: float) -> void:
	if _col:
		move_direction = move_direction * Vector2(-1,-1)

func move(_delta: float) -> void:
	if _moving:
		_motion = move_direction * max_speed
		_col = move_and_collide(_motion)

func shoot() -> void:
	# create bullet and muzzle flashes for each muzzle.
	for muzzle in muzzles:
		var bullet = bullet_scene.instance()
		var flash = muzzle_flash_scene.instance()
		get_parent().add_child(bullet)
		muzzle.add_child(flash)
		bullet.global_position = muzzle.global_position
		flash.global_position = muzzle.global_position
		bullet.start_moving(shoot_direction)
		
	# _moving will be set to true after sound effect plays
	turret_sfx.play()

func _on_ShootTimer_timeout() -> void:
	# WallMech stops to indicate to the player that it is about to attack
	# WallMech will start moving again after shooting
	_moving = false
	shoot_delay.start()

func _on_TurretSound_finished() -> void:
	move_timer.start()

func _on_MoveTimer_timeout() -> void:
	# Set moving to true and start the shoot_timer again.
	_moving = true
	shoot_timer.start()

func _on_ShootDelayTimer_timeout() -> void:
	shoot()
