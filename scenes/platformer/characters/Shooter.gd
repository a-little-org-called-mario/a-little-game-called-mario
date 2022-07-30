extends Position2D


export(PackedScene) var default_projectile: PackedScene = preload("res://scenes/CoinProjectile.tscn")
export(PackedScene) var fireball_projectile: PackedScene = preload("res://scenes/powerups/Fireball.tscn")
var inventory = preload("res://scripts/resources/PlayerInventory.tres")

onready var player : Player = owner

func _ready() -> void:
	EventBus.connect("fire_flower_collected", self, "_on_flower_collected")


func _input(event: InputEvent) -> void:
	# Remove one coin and spawn a projectile
	# Continus shooting after 0 coins
	if event.is_action_pressed("shoot"):
		if inventory.has_flower:
			if inventory.flower_amount > 0:
				shoot(fireball_projectile)
		elif CoinInventoryHandle.change_coins_on(player, -1):
			shoot(default_projectile)


func shoot(projectile_scene: PackedScene) -> void:
	# Spawn the projectile and move it to its origin point
	# Origin is affected by changes to Sprite (ex: squashing)
	var projectile = projectile_scene.instance()
	player.get_parent().add_child(projectile)
	var shoot_dir := Vector2.RIGHT * player.pivot.scale.x
	# Changes ShootOrigin based on direction
	if shoot_dir == Vector2.LEFT:
		set_position(Vector2(-4, -16))
	else:
		set_position(Vector2(4, -16))
	projectile.position = global_position
	# Projectile handles movement
	projectile.start_moving(shoot_dir)
	player.emit_signal("shooting")
	EventBus.emit_signal("shot")


func _on_flower_collected(data : Dictionary) -> void:
	if data.has("collected"):
		inventory.has_flower = data["collected"]
