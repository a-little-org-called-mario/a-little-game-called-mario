tool
extends Water

export var size := Vector2(1024, 300) setget size_set
export var color := Color(0.0, 0.3, 0.7, 0.5) setget color_set
export var surface_color := Color(0.8, 0.8, 1.0, 0.7) setget surface_color_set
export var surface := true setget surface_set

var extra_wave_height := 24 #How far the waves go above the water collision

var is_ready := false

func _ready():
	is_ready = true
	update_size()
	update_params()

func size_set(value: Vector2):
	size = value
	if is_ready: #Make sure child nodes are loaded first
		update_size()
		
func color_set(value):
	color = value
	if is_ready: #Make sure child nodes are loaded first
		update_params()
	
func surface_color_set(value):
	surface_color = value
	if is_ready: #Make sure child nodes are loaded first
		update_params()
		
func surface_set(value):
	surface = value
	if is_ready: #Make sure child nodes are loaded first
		update_params()
		

func update_size():
	$Display.scale = size + Vector2(0, extra_wave_height if surface else 0)
	$Display.position = size
	$CollisionShape2D.shape.extents = size / 2
	$CollisionShape2D.position = size / 2
	$Display.material.set_shader_param("size", size)
	

func update_params():
	$Display.material.set_shader_param("color", color)
	$Display.material.set_shader_param("surface_color", surface_color)
	$Display.material.set_shader_param("surface", surface)
