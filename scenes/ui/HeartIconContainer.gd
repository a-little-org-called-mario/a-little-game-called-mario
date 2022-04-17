extends GridContainer


export(PackedScene) var heart_scene: PackedScene
export(int) var amplitude: int = 3
export(float) var frequency: float = 4

var inventory = preload("res://scripts/resources/PlayerInventory.tres")
var time: float = 0.0
var local_hearts: int = 0


func _ready() -> void:
	for heart in get_children():
		heart.queue_free()


func _process(delta: float) -> void:
	time += delta

	if local_hearts != inventory.hearts:
		update_hearts()

	for i in get_child_count():
		var node: Control = get_child(i)
		var row = int(i / columns)
		var initial_y_pos = row * node.rect_size.y
		var new_y_pos = initial_y_pos + sin(time * frequency + i) * amplitude
		
		node.rect_position.y = new_y_pos


func update_hearts() -> void:
	while local_hearts < inventory.hearts:
		add_child(heart_scene.instance())
		local_hearts += 1
	while local_hearts > inventory.hearts:
		get_child(local_hearts - 1).get_node("AnimationPlayer").play("Disappear")
		local_hearts -= 1
