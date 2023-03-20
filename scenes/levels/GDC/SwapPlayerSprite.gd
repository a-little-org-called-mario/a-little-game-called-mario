extends Area2D


export (PackedScene) var newSpriteScene
export (NodePath) var hideSprite

var isMario = true


func _on_Area2D_body_entered(body:Node):
	if body is Player:
		if isMario:
			body.get_node("Pivot/Sprite").name = "MarioSprite"
			body.get_node("Pivot/MarioSprite").hide()
			body.get_node_or_null("Pivot/BouncyMoustache").hide()

			var newSprite = newSpriteScene.instance()
			body.get_node("Pivot").add_child(newSprite)
			body.anim = newSprite.get_node("Anims")
			isMario = false
		else:
			body.get_node("Pivot/Sprite").queue_free()
			body.get_node("Pivot/MarioSprite").show()
			body.get_node_or_null("Pivot/BouncyMoustache").show()
			body.anim = body.get_node("Pivot/MarioSprite").get_node("Anims")
			body.get_node("Pivot/MarioSprite").name = "Sprite"
			get_node(hideSprite).hide()
			queue_free()
