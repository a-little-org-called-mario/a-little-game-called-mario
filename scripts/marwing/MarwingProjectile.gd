extends Area

var direction: Vector3;
var current_range: float;

export var speed: float;
export var damage: int;
export var max_range: float;

func ready ():
	current_range = 0;
	connect("area_shape_entered",self,"on_contact");

func _physics_process (dt: float):
	translation = translation + (dt * speed * direction);
	current_range = current_range + (dt * speed);
	if current_range > max_range: destroy();

func destroy ():
	set_deferred("monitoring", false);
	set_deferred("mointorable", false);
	queue_free();

func on_contact (other: Area):
	if other.get_collision_layer_value(9) or other.get_collision_layer_value(10):
		other.hp = other.hp - damage;
	destroy();
