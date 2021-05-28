extends Node2D
class_name CentraleClass
var ressource = preload("res://Ressource.tscn")
var ressource_instance = ressource.instance()
var combustible = [ressource_instance.Type.COAL,1]
var combustible_counter=0
var timer = 0
var energy_production = 100
var duration = 2
var progress_bar=null
# Called when the node enters the scene tree for the first time.
func _ready():
	progress_bar = $ProgressBar
	progress_bar.set_progress(100)
	progress_bar.set_alert(true)
	
func use_ingredients():
	if combustible_counter>=combustible[1]:
		combustible_counter-=combustible[1]
		$RichTextLabel.bbcode_text="[center]"+str(combustible_counter)+"[/center]"
		return true
	return false


func _process(delta):
	energy_production = 100 * get_parent().get_parent().powerMultiplier
	if combustible_counter>=combustible[1]:
		progress_bar.set_alert(false)
		if timer<=duration:
			timer+=delta
			get_parent().get_parent().get_node("Ressources").add_energy(energy_production*delta/duration)
			progress_bar.set_progress(int(100*timer/duration))
		else:
			if use_ingredients():
				timer-=duration
	else:
		progress_bar.set_alert(true)
			



func _on_Forge_area_entered(area):
	if area is Ressource and area.type==combustible[0]:
		if area.real==true:
			area.queue_free()
			combustible_counter+=1
			$RichTextLabel.bbcode_text="[center]"+str(combustible_counter)+"[/center]"
