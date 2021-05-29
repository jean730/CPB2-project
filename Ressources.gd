extends Node


var energy=100000000
var storage = {
	"ORE_1":150,
	"ORE_2":20,
	"COAL":0,
	"coins":0
}
# Called when the node enters the scene tree for the first time.
func use_energy(quantity):
	if energy>=quantity:
		energy-=quantity
		return true
	return false
	
func add_energy(quantity):
	energy+=quantity
	
	
	
func use_ressources(type,quantity):
	if storage[type]>=quantity:
		storage[type]-=quantity
		return true
	return false
	
func add_ressources(type,quantity):
	storage[type]+=quantity
	
func get_ressources(type):
	return storage[type]
	
func enough_ressources(type,quantity):
	return storage[type]>=quantity

func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	add_energy(10*delta)
	pass
