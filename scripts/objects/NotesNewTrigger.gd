extends Area2D


export (String) var pageName = "blank"
export (String, MULTILINE) var pageDesc = "blank blank more blank blank blank change this etc"

# This the name of the animation to be displayed by the AnimatedSprite.
# Set this to one currently available there, or add a new one.
# You can check what's already there or add a new animation by going to
# res://scenes/ui/Notes.tscn and going to the node called "Sprite".
export var pageSprite = "little_mario"


func _on_body_entered(body):
	if body is Player:
		EventBus.emit_signal("note_added", pageName, pageDesc, pageSprite)
		set_deferred("monitoring", false)

