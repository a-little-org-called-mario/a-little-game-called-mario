extends KinematicBody2D


var velocity = Vector2(0, -200)
var acceleration = Vector2(0.98, 10)

export var lifeTime = 240
export var randVeloX = true
export var value = 1


func _ready():
	if randVeloX:
		velocity.x = rand_range(-100, 100) 


func _physics_process(delta):
	$Coin.value = value
	
	velocity.y += acceleration.y
	velocity.x *= acceleration.x
	
	var result = move_and_slide(velocity, Vector2.UP)
	velocity.x = result.x
	if result.y == 0:
		velocity.y *= -0.4
	
	lifeTime -= 1
	if lifeTime <= 0:
		queue_free()


func _on_collected():
	queue_free()
