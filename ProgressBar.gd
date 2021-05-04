extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func set_progress(percentage):
	$progress_bar_full.set_region_rect(Rect2(0,0,256.0*percentage/100.0,64))
func set_alert(boolean):
	if boolean:
		$progress_bar_full.modulate = Color(1,0.5,0)
	else:
		$progress_bar_full.modulate = Color(0.3,1,0.7)
func _ready():
	$progress_bar_full.set_region(true)
	$progress_bar_full.modulate = Color(0.3,1,0.7)
	set_progress(64)
	pass # Replace with function body.


