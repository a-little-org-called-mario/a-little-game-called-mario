extends Enemy


var deathTime = -1
var killerName = ""


func ai(delta):
	before_death()


func _on_KillTrigger_body_entered(body):
	if not body is Player:
		return
	var player = body as Player
	player.bounce(1000)


func kill(killer):
	killerName = killer
	$DeathParticles.emitting = true
	$Sprite.visible = false
	$CollisionShape2D.set_deferred("disabled", true)
	deathTime = 30


func before_death():
	if deathTime >= 0:
		deathTime -= 1
		if deathTime == 0:
			if is_dying():
				return
			_dying = true
			EventBus.emit_signal("enemy_killed")
			emit_signal("dying", killerName)
			var res = _handle_dying(killerName)
			if res is GDScriptFunctionState:
				yield(res, "completed")
			alive = false
			emit_signal("dead", killerName)
			queue_free()
