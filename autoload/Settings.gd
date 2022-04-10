extends Node

const CameraLeanAmount = preload("res://scripts/CameraLeanAmount.gd")

# graphics settings
var camera_lean : int = CameraLeanAmount.MAX;
var screen_shake : bool = true;
var crt_filter : bool = true;

# sfx settings
var volume_game : int = 10;
var volume_music : int = 10;
var volume_sfx : int = 10;
