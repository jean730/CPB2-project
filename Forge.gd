extends Node2D
var ressource = preload("res://Ressource.tscn")
var ressource_instance = ressource.instance()
var product = null
var ingredients = null
var ingredients_counter=0
var new_ressource = null
var timer = 0
var energy_consumption = 10
var duration = 3.5
var progress_bar=null
# Called when the node enters the scene tree for the first time.
func _ready():
	progress_bar = $ProgressBar
	progress_bar.set_progress(0)

	
func use_ingredients():
	if ingredients_counter>=ingredients[1]:
		ingredients_counter-=ingredients[1]
		$RichTextLabel.bbcode_text="[center]"+str(ingredients_counter)+"[/center]"
		return true
	return false


func _process(delta):
	self.duration = 3.5 / get_parent().get_parent().speedMultiplier
	if product != null:
		if ingredients_counter>=ingredients[1]:
			if timer<=duration:
				timer+=delta
				progress_bar.set_progress(int(100*timer/duration))
			else:
				if (not is_instance_valid(new_ressource) or (is_instance_valid(new_ressource) and new_ressource.position.distance_to(self.position)>64)) and get_parent().get_parent().get_node("Ressources").use_energy(energy_consumption) and use_ingredients():
					timer-=duration
					
					new_ressource = ressource.instance()
					new_ressource.type=product
					new_ressource.position.x=self.position.x
					new_ressource.position.y=self.position.y+32
					get_parent().add_child(new_ressource)
					progress_bar.set_alert(false)
				else:
					progress_bar.set_alert(true)
			



func _on_Forge_area_entered(area):
		
	if area is Ressource:
		if area.real==true and area.type == ressource_instance.Type.COPPER_ORE or area.type == ressource_instance.Type.IRON_ORE:
			if self.product == null:
				match area.type:
					ressource_instance.Type.COPPER_ORE:
						ingredients=Vector2(ressource_instance.Type.COPPER_ORE,1)
						product = ressource_instance.Type.COPPER_INGOT
					ressource_instance.Type.IRON_ORE:
						ingredients=Vector2(ressource_instance.Type.IRON_ORE,1)
						product = ressource_instance.Type.IRON_INGOT
				print(product,ingredients)
			if area.type==ingredients[0]:
				area.queue_free()
				print(area.type)
				ingredients_counter+=1
				$RichTextLabel.bbcode_text="[center]"+str(ingredients_counter)+"[/center]"
