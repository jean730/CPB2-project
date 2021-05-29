extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var rng = null
var rngSeed = 0
var speedMultiplier = 1
var powerMultiplier = 1
# Called when the node enters the scene tree for the first time.
func _ready():
	get_tree().set_screen_stretch(SceneTree.STRETCH_MODE_2D,  SceneTree.STRETCH_ASPECT_KEEP, Vector2(1024,600),1)
	pass
