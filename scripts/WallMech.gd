# Using the Enemy class that someone else made.
# The Bub enemy is using collision layer 4 and mask 2 so this enemy is as well.
# Unfortunately, most of the worlds are made as layer 1 so we need to mask 1
# WallMech so it interacts with most worlds. This should be refactored later.
# Also reusing the res://scenes/enemies/Bullet.tscn and res://scenes/SimpleExplosion.tscn for now
extends Enemy

onready var turret_sfx: AudioStreamPlayer2D = $TurretSound
onready var shoot_timer: Timer = $ShootTimer
onready var move_timer: Timer = $MoveTimer
onready var shoot_delay: Timer = $ShootDelayTimer
onready var anim: AnimationPlayer = $AnimationPlayer

var _moving: bool = true
var _motion = Vector2.ZERO
var _col: KinematicCollision2D
var muzzles: Array = []

# Exported vars for level designers
# For reference, Vector2.LEFT = (-1, 0) Vector2.DOWN = (0 ,1)
export(float) var max_speed = 0.75
export(Vector2) var shoot_direction = Vector2.LEFT
export(Vector2) var move_direction = Vector2.DOWN
export(PackedScene) var bullet_scene
export(PackedScene) var muzzle_flash_scene
export(int) var health = 3
export(int) var time_between_shots = 3
export(int) var pre_shot_delay = 1
export(int) var move_after_shot_delay = 1


func _ready() -> void:
	for child in $Muzzles.get_children():
		muzzles.append(child)
	shoot_timer.wait_time = time_between_shots
	move_timer.wait_time = move_after_shot_delay
	shoot_delay.wait_time = pre_shot_delay
	shoot_timer.start()


# This is function from Enemy.gd that we're overwriting
func ai(_delta: float) -> void:
	if _col:
		move_direction = move_direction * Vector2(-1, -1)
	$Sprite.set_flip_h(shoot_direction.x > 0)


# This is function from Enemy.gd that we're overwriting
func move(_delta: float) -> void:
	if _moving:
		_motion = move_direction * max_speed
		_col = move_and_collide(_motion)


func shoot() -> void:
	# create bullet and muzzle flashes for each muzzle.
	for muzzle in muzzles:
		var bullet = bullet_scene.instance()
		var flash = muzzle_flash_scene.instance()
		# Add the bullets to the root scene so they don't move with the WallMech
		get_parent().add_child(bullet)
		muzzle.add_child(flash)
		bullet.global_position = muzzle.global_position
		flash.global_position = muzzle.global_position
		# start_moving is a function from Bullet.tscn
		bullet.start_moving(shoot_direction)

	# _moving will be set to true after sound effect plays
	turret_sfx.play()


# The PlayerProjectile.gd expects the enemy to be in the "enemy" group
# and have a "kill(killer)" function. I think this would be better as a
# genearl signal, but this is how it is currently done.
# Here I am overwriting the Enemy.gd's kill function since this unit
# has health and therefore acts differently.
# PlayerProjectile.gd does NOT supply a damage value, however
# I added a damage var here in case other powerups will eventually
# It is set to 1 here so the game doesn't complain if the projectile has no
# damage var.
func kill(killer: Object, damage: int = 1) -> void:
	# WallMech has 3 hidden hit points.
	_damage(damage, killer)


func _damage(dmg: int, killer: Object) -> void:
	anim.play("hurt")
	health = health - dmg
	if health <= 0:
		EventBus.emit_signal("enemy_killed")
		emit_signal("dying", killer)
		var res = _handle_dying(killer)
		if res is GDScriptFunctionState:
			yield(res, "completed")
		alive = false
		emit_signal("dead", killer)
		queue_free()


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
