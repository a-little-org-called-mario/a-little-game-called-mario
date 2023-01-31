extends Area2D

export var color = Color(0.7, 0.3, 0.7)
export var radius : float = 16
export var velocity := Vector2.ZERO
export var turn_speed : float = 0.3

var noise := OpenSimplexNoise.new()
var time : float = 0.0

onready var particles := $CPUParticles2D

# Called when the node enters the scene tree for the first time.
func _ready():
	particles.emitting = false
	noise.seed = randi()
	$CollisionShape2D.shape.radius = radius
	$Sprite.position = Vector2.ONE * radius
	$Sprite.scale = Vector2.ONE * radius * 2
	$Sprite.material.set_shader_param("color", color)


func _physics_process(delta):
	time += delta
	position += velocity * delta
	velocity = velocity.rotated(TAU * noise.get_noise_1d(time) * turn_speed * delta)
	
	
func pop():
	$Sprite.visible = false
	particles.emitting = true
	particles.restart()
	set_deferred("monitoring", false)
	$RemoveTimer.start()
	velocity = Vector2.ZERO


func _on_Bubble_body_entered(body : Node2D):
	if not body.is_in_group("no_pop_bubble"):
		pop()


func _on_RemoveTimer_timeout():
	queue_free()


func _on_Bubble_area_entered(area : Area2D):
	if not area.is_in_group("no_pop_bubble"):
		if area.get_collision_layer_bit(4) or area.get_collision_layer_bit(8): #Check if the area is an Enemy Projectile or Player Projectile
			pop()
