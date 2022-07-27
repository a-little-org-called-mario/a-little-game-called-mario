extends Area2D


export (String) var pageName = "blank"
export (String, MULTILINE) var pageDesc = "blank blank more blank blank blank change this etc"

# This the name of the animation to be displayed by the AnimatedSprite.
# Set this to one currently available there, or add a new one.
# You can check what's already there or add a new animation by going to
# res://scenes/ui/Notes.tscn and going to the node called "Sprite".
export (String) var pageSprite = "little_mario"
export (Vector2) var pageSpriteScale = Vector2(2, 2)


func _on_body_entered(body):
	if body is Player:
		EventBus.emit_signal("note_added", pageName, pageDesc, pageSprite, pageSpriteScale)
		set_deferred("monitoring", false)

