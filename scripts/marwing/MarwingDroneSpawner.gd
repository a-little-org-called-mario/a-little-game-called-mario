extends Timer

export var max_num_drones: int = 15

export(NodePath) var spawn_point_path
export(PackedScene) var drone_scene

export(NodePath) onready var path = get_node(path) as Path
onready var spawn_point := get_node(spawn_point_path) as Spatial

# circular array, prevents this mode from using infinite memory
var drone_key: int = 0
var drones = []

func _ready():
	randomize()
	self.connect("timeout", self, "_on_timeout")
	for n in max_num_drones:
		drones.append(drone_scene.instance() as MarwingShipBase)
		drones[n].set_process(false);
		


func _create_drone() -> MarwingShipBase:
	var drone = drones[drone_key];
	print(get_node("../"))
	drone.set_process(true)
	drone.translation = spawn_point.translation
	drone_key = (drone_key + 1) % drones.size()
	return drone


func _on_timeout():
	path.add_child(_create_drone())
