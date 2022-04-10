extends Node

const CameraLeanAmount = preload("res://scripts/CameraLeanAmount.gd")

# graphics settings
var camera_lean : int = CameraLeanAmount.MAX;
var screen_shake : bool = true;
var crt_filter : bool = true;
