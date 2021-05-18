extends Node2D
var ressource = preload("res://Ressource.tscn")

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var new_ressource = null
var timer = 0
var energy_consumption = 5
var duration = 3.5
var progress_bar=null
# Called when the node enters the scene tree for the first time.
func _ready():
	progress_bar = $ProgressBar
	


# Called every frame. 'delta' is the elapsed time since the previous frame.

func _process(delta):
	self.duration = 3.5 / get_parent().get_parent().speedMultiplier
	if timer<duration:
		timer+=delta
		progress_bar.set_progress(int(100*timer/duration))
	else:
		if (new_ressource==null or (new_ressource is Node2D and new_ressource.position.distance_to(self.position)>64)) and get_parent().get_parent().get_node("Ressources").use_energy(energy_consumption):
			timer-=duration
			
			new_ressource = ressource.instance()
			match get_parent().get_parent().get_node("map").get_cell(floor(self.position.x/64),floor(self.position.y/64)):
				4:
					new_ressource.type=new_ressource.Type.COPPER_ORE
				3:
					new_ressource.type=new_ressource.Type.IRON_ORE
				2:
					new_ressource.type=new_ressource.Type.COAL
				
			new_ressource.position.x=self.position.x
			new_ressource.position.y=self.position.y+32
			get_parent().add_child(new_ressource)
			progress_bar.set_alert(false)
		else:
			progress_bar.set_alert(true)
			

