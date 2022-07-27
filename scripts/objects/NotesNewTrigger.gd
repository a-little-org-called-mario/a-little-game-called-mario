extends Area2D


export (String) var pageName = "blank"
export (String, MULTILINE) var pageDesc = "blank blank more blank blank blank change this etc"
export var pageSprite = "little_mario"


func _on_body_entered(body):
	if body is Player:
		EventBus.emit_signal("note_added", pageName, pageDesc, pageSprite)
		set_deferred("monitoring", false)
