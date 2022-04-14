extends Node


onready var player : Player = owner
onready var sprite : Sprite = player.get_node("BusSprite")
onready var collision : CollisionShape2D = player.get_node("BusCollision")

var isBus : bool = false


func _ready() -> void:
	EventBus.connect("bus_collected", self, "_on_bus_collected")
	set_process(false)


func _process(_delta: float) -> void:
	sprite.flip_h = !player.sprite.flip_h


func _on_bus_collected(data: Dictionary) -> void:
	if data.has("collected"):
		isBus = data["collected"]
		sprite.visible = true
		collision.set_deferred("disabled", false)
		
		set_process(true)

		player.sprite.visible = false
		player.get_node("CollisionShape2D").set_deferred("disabled", true)
		player.trail.height = 15
