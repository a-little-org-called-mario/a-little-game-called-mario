extends PathFollow
class_name MarwingShip

# Max stats block
export var max_hp: int = 100;                                   # the maximum amount of health the ship has
export var fire_rate: float = 8.5;                             # how many times, per second, the ship can fire
export var forward_speed: float = 16.6;                        # the speed at which the ship moves along the path, in units per second
export var strafe_speed: float = 5.2;                          # the speed at which the ship can move perpendicular to the path, in units/sec
export var max_perpen: Vector2 = Vector2(2.7, 1.8);            # how far from the path the ship can go, in relative horizontal and vertical units

# Dynamic stats block
var hp: int;                                                   # the current health the ship has
var perpen: Vector2 = Vector2.ZERO;                            # the current perpendicular offset the ship has from the path
var max_lean: Vector2 = Vector2(15,17.5);                      # the angle at which the ship leans when strafing

# State information
export var move_forward: bool = true;                          # whether or not the ship moves forward (0 -> 1) or backward
var can_shoot: bool = true;                                    # whether or not the ship can fire its weapons
var can_move: bool = true;                                     # whether or not the ship can move along the path
var can_strafe: bool = true;                                   # whether or not the ship can move perpendicular to the path
var invulnerable: bool = true;                                 # whether or not the ship can take damage

# Projectile information
export var projectile: PackedScene;
onready var fallback_projectile: PackedScene = preload("res://scenes/levels/marwing/projectiles/DefaultProj.tscn");
onready var fire_timer: Timer = get_node("FireTimer");
var can_fire: bool = true;

func _ready ():
	$AnimationPlayer.play("normal");
	hp = max_hp;
	fire_timer.connect("timeout",self,"allow_fire");

func _physics_process (dt: float):
	# move the ship along the path based on speed and direction
	if can_move: offset = offset + (dt * forward_speed * (1 if move_forward else -1));

	# toggle death animation when hp hits zero, then remove node from scene
	if hp <= 0 and not invulnerable:
		can_move = false;
		can_strafe = false;
		can_shoot = false;
		$AnimationPlayer.play("die");
		yield($AnimationPlayer,"animation_finished");
		queue_free();

# note (jam): this is written as a function only so that it can be called in AnimationPlayer call method tracks
func set_invulnerable (inv: bool = false):
	invulnerable = inv;

# Should never be explicitly called - only a response to the FireTimer's "timeout" signal
func allow_fire ():
	can_fire = true;

func shoot (origin: Vector3, dir: Vector3):
	if not can_fire:
		return;

	var proj: PackedScene = projectile if projectile != null else fallback_projectile;
	var inst = proj.instance();
	inst.translation = origin;
	inst.direction = dir;
	add_child(inst);	# note (jam):   this is really bad actually. bullets probably shouldn't be parented to a ship and affected by their movement along a path
	can_fire = false;
	fire_timer.start(1 / fire_rate);
