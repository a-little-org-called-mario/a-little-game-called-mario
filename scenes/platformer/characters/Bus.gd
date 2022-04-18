extends Sprite

export(NodePath) var collision_shape: NodePath

var inventory = preload("res://scripts/resources/PlayerInventory.tres")

onready var player: Player = owner
onready var collision: CollisionShape2D = get_node(collision_shape)


func _ready() -> void:
	EventBus.connect("bus_collected", self, "_on_bus_collected")
	call_deferred("_activate_bus", inventory.has_bus)


func _process(_delta: float) -> void:
	if inventory.has_bus:
		player.powerupspeed = 4
		player.powerupaccel = 2
	else:
		player.powerupspeed = 1
		player.powerupaccel = 1


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
	player.collision.disabled = active

	var trail: Line2D = player.get_node_or_null("Trail")
	if trail != null:
		trail.height = 15 if active else 30

	set_process(active)
