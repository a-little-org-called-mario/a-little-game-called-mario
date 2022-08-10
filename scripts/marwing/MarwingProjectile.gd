extends Area
class_name MarwingProjectile

var direction: Vector3;
var current_range: float;

export var speed: float;
export var damage: int;
export var max_range: float;


func ready ():
	current_range = 0;
	connect("area_shape_entered", self, "on_contact");


func _physics_process (dt: float):
	translation = translation + (dt * speed * direction);

	# handle range - if bullet has traveled for too long, get rid of it
	current_range = current_range + (dt * speed);
	if current_range > max_range: destroy();


func destroy():
	set_deferred("monitoring", false);
	set_deferred("mointorable", false);
	queue_free();


func on_contact(_other: Area):
	destroy();
