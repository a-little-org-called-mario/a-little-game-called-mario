#Fireball asset by Charbomber#9698
#Shoot sound by Jacob Posten (Harper's brother)
#Hit sound by Mike Koenig https://soundbible.com/1348-Large-Fireball.html
extends PlayerProjectile
class_name Fireball


func _handle_start(_dir: Vector2):
	$Shoot.play()
	pass


func _handle_destruction():
	$Hit.play()
	$Sprite.visible = false
	yield($Hit, "finished")
	pass
