extends GridContainer


export(Texture) var heart_texture : Texture
export(int) var amplitude = 3
export(float) var frequency = 4

var heart_texture_path : String
var inventory = preload("res://scripts/resources/PlayerInventory.tres")
var time : float = 0.0
var heart_sprite_size : int = 16 # Magic number because i'm too lazy to get the height programattically

func _ready() -> void:
	EventBus.connect("heart_changed", self, "_on_heart_change")
	heart_texture_path = heart_texture.resource_path
	_update_hearts()


func _process(delta: float) -> void:
	time += delta
	
	for i in get_child_count():
		var node : TextureRect = get_child(i)
		var row = int(i / columns)
		var initial_y_pos = row * (heart_sprite_size * rect_scale.y)
		var new_y_pos = initial_y_pos + sin(time * frequency + i) * amplitude
		
		node.rect_position.y = new_y_pos


func _on_heart_change(_data: Dictionary) -> void:
	call_deferred("_update_hearts")
	

func _update_hearts() -> void:
	for node in get_children():
		node.queue_free()
	
	var count : int = inventory.hearts
	for _i in range(count):
		var heart := TextureRect.new()
		heart.texture = heart_texture
		add_child(heart)
