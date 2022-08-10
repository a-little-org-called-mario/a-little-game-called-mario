extends Timer

export(NodePath) onready var path = get_node(path) as Path
export(PackedScene) var drone_scene


func _ready():
	randomize()
	self.connect("timeout", self, "_on_timeout")


func _create_drone() -> MarwingShip:
	var drone := drone_scene.instance() as MarwingShip
	drone.max_hp = 20
	drone.forward_speed = rand_range(1, 5)
	drone.move_forward = false
	drone.rotate_y(deg2rad(-90))
	drone.rotate_z(deg2rad(-30))
	drone.unit_offset = rand_range(0, 1)
	drone.loop = true
	drone.h_offset = rand_range(-20, 20)
	drone.v_offset = 6
	return drone


func _on_timeout():
	path.add_child(_create_drone())
