extends GridContainer


export(PackedScene) var heart_scene: PackedScene
export(int) var amplitude: int = 3
export(float) var frequency: float = 4

var inventory = preload("res://scripts/resources/PlayerInventory.tres")
var time: float = 0.0


func _ready() -> void:
	for heart in get_children():
		heart.queue_free()
	_add_hearts(inventory.hearts)
	if not EventBus.is_connected("heart_changed", self, "_on_heart_changed"):
		EventBus.connect("heart_changed", self, "_on_heart_changed")


func _process(delta: float) -> void:
	time += delta

	for i in get_child_count():
		var node: Control = get_child(i)
		var row = int(i / columns)
		var initial_y_pos = row * node.rect_size.y
		var new_y_pos = initial_y_pos + sin(time * frequency + i) * amplitude
		node.rect_position.y = new_y_pos

	if time >= amplitude/frequency*2:
		time = 0


func _on_heart_changed(delta: int, hearts: int) -> void:
	if delta > 0:
		_add_hearts(delta)
	else:
		_remove_hearts(-delta)


func _add_hearts(count: int) -> void:
	for i in count:
		add_child(heart_scene.instance())


func _remove_hearts(count: int) -> void:
	var hearts: Array = get_children()
	for i in clamp(count, 0, hearts.size()):
		var heart = hearts.pop_back()
		heart.get_node("AnimationPlayer").play("Disappear")
