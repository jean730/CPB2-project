extends Area2D
var ressource = preload("res://Ressource.tscn")
var ressource_instance = ressource.instance()

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_VoidStorage_area_entered(area):
	if area is Ressource and area.real==true:
		if area.type==ressource_instance.Type.IRON_INGOT:
			get_parent().get_parent().get_node("Ressources").add_ressources("ORE_1",1)
		if area.type==ressource_instance.Type.COPPER_INGOT:
			get_parent().get_parent().get_node("Ressources").add_ressources("ORE_2",1)
		if area.type==ressource_instance.Type.COAL:
			get_parent().get_parent().get_node("Ressources").add_ressources("COAL",1)
		area.queue_free()
