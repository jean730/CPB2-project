extends Node2D
var ressource = preload("res://Ressource.tscn")
var ressource_instance = ressource.instance()
var product = ressource_instance.Type.COPPER_INGOT
var ingredients = null
var ingredients_counter=0
var new_ressource = null
var timer = 0
var energy_consumption = 100
var duration = 1
var progress_bar=null
# Called when the node enters the scene tree for the first time.
func _ready():
	progress_bar = $ProgressBar
	progress_bar.set_progress(0)
	match product:
		ressource_instance.Type.COPPER_INGOT:
			ingredients=Vector2(ressource_instance.Type.COPPER_ORE,1)
		ressource_instance.Type.IRON_INGOT:
			ingredients=Vector2(ressource_instance.Type.IRON_ORE,1)
	
func use_ingredients():
	if ingredients_counter>=ingredients[1]:
		ingredients_counter-=ingredients[1]
		$RichTextLabel.bbcode_text="[center]"+str(ingredients_counter)+"[/center]"
		return true
	return false


func _process(delta):
	if ingredients_counter>=ingredients[1]:
		if timer<=duration:
			timer+=delta
			progress_bar.set_progress(int(100*timer/duration))
		else:
			if (new_ressource==null or new_ressource.position.distance_to(self.position)>64) and get_parent().get_parent().get_node("Ressources").use_energy(energy_consumption) and use_ingredients():
				timer-=duration
				
				new_ressource = ressource.instance()
				match get_parent().get_parent().get_node("map").get_cell(floor(self.position.x/64),floor(self.position.y/64)):
					4:
						new_ressource.type=product
				new_ressource.position.x=self.position.x
				new_ressource.position.y=self.position.y+32
				get_parent().add_child(new_ressource)
				progress_bar.set_alert(false)
			else:
				progress_bar.set_alert(true)
			



func _on_Forge_area_entered(area):
	if area is Ressource and area.type==ingredients[0]:
		area.queue_free()
		ingredients_counter+=1
		$RichTextLabel.bbcode_text="[center]"+str(ingredients_counter)+"[/center]"
