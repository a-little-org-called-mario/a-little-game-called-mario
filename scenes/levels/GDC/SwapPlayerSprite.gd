extends Area2D


export (PackedScene) var newSpriteScene
export (NodePath) var hideSprite

var triggered = false


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Area2D_body_entered(body:Node):
	if body is Player and not triggered:
		var newSprite = newSpriteScene.instance()

		body.get_node("Pivot/Sprite").queue_free()
		body.get_node("Pivot/BouncyMoustache").queue_free()

		body.anim = newSprite.get_node("Anims")
		
		body.get_node("Pivot").add_child(newSprite)
		
		triggered = true
		get_node(hideSprite).hide()
