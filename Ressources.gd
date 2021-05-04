extends Node


var energy=10000

# Called when the node enters the scene tree for the first time.
func use_energy(quantity):
	if energy>=quantity:
		energy-=quantity
		return true
	return false
func add_energy(quantity):
	energy+=quantity
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
