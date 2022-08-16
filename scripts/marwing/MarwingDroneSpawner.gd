extends Timer

export var max_num_drones: int = 15

export(NodePath) onready var path = get_node(path) as Path
export(PackedScene) var drone_scene

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
	drone.set_process(true)
	drone_key = (drone_key + 1) % drones.size()
	return drone


func _on_timeout():
	path.add_child(_create_drone())
