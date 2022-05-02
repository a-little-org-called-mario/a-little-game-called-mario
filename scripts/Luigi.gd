# Object Class: Keter
# Luigi is dangerous and should never approached under any circumstance.
# Luigi lives in his mansion and hoards money like a dragon.
# Luigi is [REDACTED] because of [REDACTED]
# Luigi is GOOD
# LUIGI IS GOOD
# TRUST LUIGI
# THIS MESSAGE HAS BEEN BROUGHT TO YOU BY LUIGI
extends Enemy
class_name Luigi

signal luigi_defeated

const FIREBALL_SPAWN_DIST: float = 32.0
const ASCEND_SPEED: float = 100.0
const RETURN_SPEED: float = 70.0

export(bool) var is_mortal: bool = false
export(int) var max_health: int = 5
export(PackedScene) var fireball: PackedScene = preload("res://scenes/enemies/Bullet.tscn")
export(int) var fireball_count: int = 6
export(float) var fireball_cooldown: float = 2.5
export(float) var flip_time: float = 4.0
export(float) var flip_offset: float = 0.0
enum { IDLE, CHARGING, KILLING, COOLDOWN, DYING }
var state: int = IDLE
var player: Node2D
onready var health: int = max_health


func _ready():
	if !is_mortal:
		modulate.a = 0.75
	else:
		$Healthbar.show()
	EventBus.connect("player_spotted", self, "player_spotted")
	$KillTimer.connect("timeout", self, "shoot_fireballs")
	if flip_offset > 0.0:
		$TurnTimer.wait_time = flip_offset
		$TurnTimer.start()
		yield($TurnTimer, "timeout")
	$TurnTimer.connect("timeout", self, "turn_around")
	$TurnTimer.wait_time = flip_time
	$TurnTimer.one_shot = false
	$TurnTimer.start()


func move(delta: float):
	match state:
		IDLE, COOLDOWN:
			var collision: KinematicCollision2D = move_and_collide(
				Vector2.DOWN * ASCEND_SPEED * delta
			)
			if (
				collision
				and collision.collider is Player
				and collision.position.y > (position.y + 26)
			):
				HeartInventoryHandle.change_hearts_on(collision.collider, -5)
		CHARGING:
			move_and_collide(Vector2.UP * RETURN_SPEED * delta)
			continue
		CHARGING, KILLING, COOLDOWN:
			if player.is_inside_tree():
				$Sprite.flip_h = player.global_position.x < global_position.x
			$VisionCone.rotation_degrees = 180 * float($Sprite.flip_h)


func turn_around():
	if state != IDLE:
		return
	$AnimationPlayer.play("squash")
	if randi() % 2:
		$Idle1.play()
	else:
		$Idle2.play()
	$Sprite.flip_h = not $Sprite.flip_h
	$VisionCone.rotation_degrees = 180 * float($Sprite.flip_h)


func player_spotted(_spotted_by: Node, mario: Node):
	if state != IDLE:
		return
	state = CHARGING
	player = mario
	$VisionCone.disable_spoting()
	$Sprite.animation = "run"
	$Callout.play()
	$AnimationPlayer.play("vibrate")
	yield($Callout, "finished")
	$KillTimer.start()


func shoot_fireballs():
	if not (state == IDLE or state == CHARGING):
		return
	state = KILLING
	if player == null:
		player = self
	$DeathZone.emitting = true
	$Sprite.animation = "idle"
	$FireballTimer.wait_time = max(0.1, 1.0 / fireball_count)
	$FireballTimer.start()
	for f in fireball_count:
		spawn_fireball(player.position)
		$Scream.play()
		$Sprite.modulate = $Sprite.modulate.linear_interpolate(Color.red, 1.0 / fireball_count)
		yield($FireballTimer, "timeout")
	$FireballTimer.stop()
	state = COOLDOWN
	$Tween.interpolate_property($Sprite, "modulate", Color.orange, Color.white, fireball_cooldown)
	$Tween.start()
	yield($Tween, "tween_completed")
	$Tween.remove_all()
	_cooldown_finished()


func spawn_fireball(towards: Vector2 = Vector2.ZERO):
	if towards == Vector2.ZERO:
		towards = position
	var projectile = fireball.instance()
	get_parent().add_child(projectile)
	projectile.set_collision_mask_bit(1, false)
	var start_pos = Vector2(FIREBALL_SPAWN_DIST, 0).rotated(randf() * PI * 2.0)
	projectile.position = position + start_pos
	projectile.start_moving(projectile.to_local(towards).rotated(randf() * 0.15))


func _cooldown_finished():
	if state != COOLDOWN:
		return
	state = IDLE
	$VisionCone.enable_spoting()
	$AnimationPlayer.stop()
	$Sprite.position = Vector2(0, 32)
	$Sprite.modulate = Color.white
	$DeathZone.emitting = false


func kill(killer):
	if (
		(killer.position.x > position.x and $Sprite.flip_h)
		or (killer.position.x < position.x and !$Sprite.flip_h)
	):
		turn_around()
		$TurnTimer.start()
	elif !is_mortal:
		$Idle1.play()
	if is_mortal:
		health -= 1
		$Healthbar/Value.rect_scale.x = float(health) / float(max_health)
		$Scream.play()
		if health <= 0:
			state = DYING
			$VisionCone.disable_spoting()
			disable_collision()
			.kill(killer)


func _handle_dying(_killer):
	$AnimationPlayer.play("death")
	$Healthbar.hide()
	yield($AnimationPlayer, "animation_finished")
	emit_signal("luigi_defeated")


func _on_boss_death(killer):
	is_mortal = true
	health = 0
	state = DYING
	$VisionCone.disable_spoting()
	disable_collision()
	.kill(killer)
