extends Area2D


export var pageName = "blank"
export var pageDesc = "blank blank more blank blank blank change this etc"
export var pageSprite = "little_mario"


func _physics_process(delta):
	if monitoring:
		for body in get_overlapping_bodies():
			if body is Player:
				EventBus.emit_signal("note_added", pageName, pageDesc, pageSprite)
				monitoring = false

