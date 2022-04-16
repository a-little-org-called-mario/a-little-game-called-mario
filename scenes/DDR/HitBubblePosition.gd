extends Position2D


export(float) var spawnRange
export(float) var bubbleLife
export(float) var bubbleSpeed
export(PackedScene) var bubbleMiss
export(PackedScene) var bubbleNice
export(PackedScene) var bubbleCool
export(PackedScene) var bubbleSick
export(PackedScene) var bubblePerfect

func _on_note_hit(score):
	var x = rand_range(-spawnRange, spawnRange)
	var scene = _get_bubble_scene(score)
	var bubble = scene.instance()
	bubble.position = Vector2(x, 0)
	bubble.speed = bubbleSpeed
	bubble.life = bubbleLife
	add_child(bubble)
	pass

func _get_bubble_scene(score) -> PackedScene:
	if score > 900:
		return bubblePerfect
	elif score > 700:
		return bubbleSick
	elif score > 500:
		return bubbleCool
	elif score > 0:
		return bubbleNice
	else:
		return bubbleMiss
