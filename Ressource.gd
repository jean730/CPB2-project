class_name Ressource
extends Area2D
enum Type {IRON_ORE,COPPER_ORE,IRON_INGOT,COPPER_INGOT,COAL}
export(Type) var type
export(bool) var real = true
var speed = 0.5
# Declare member variables here. Examples:
# var a = 2
# var b = "text"

func genColor(rng):
	var vec = Vector3(rng.randf(),rng.randf(),rng.randf()).normalized()
	return Color(vec.x,vec.y,vec.z)
# Called when the node enters the scene tree for the first time.
func _ready():
	var rng = RandomNumberGenerator.new()
	if get_tree().get_root().get_node("Game").rngSeed==0:
		rng.randomize()
		get_tree().get_root().get_node("Game").rngSeed=rng.randi_range(0,100000000)
	rng.seed = get_tree().get_root().get_node("Game").rngSeed	
	match self.type:
		Type.COPPER_ORE:
			get_node("Sprite").texture = load("res://minerai.png")
			get_node("Sprite").modulate = genColor(rng)
		Type.COPPER_INGOT:
			get_node("Sprite").texture = load("res://lingot.png")
			get_node("Sprite").modulate = genColor(rng)
		Type.IRON_ORE:
			rng.seed+=100000
			get_node("Sprite").texture = load("res://minerai.png")
			get_node("Sprite").modulate = genColor(rng)
		Type.IRON_INGOT:
			rng.seed+=100000
			get_node("Sprite").texture = load("res://lingot.png")
			get_node("Sprite").modulate = genColor(rng)
		Type.COAL:
			get_node("Sprite").texture = load("res://charbon.png")
	if not real:
		get_node("Sprite").set_light_mask(0)
	pass # Replace with function body.



func logistics(tile_id,delta):
	var tileposx = floor(self.position.x/64)
	var tileposy = floor(self.position.y/64)
	var posy = self.position.y/64-tileposy
	var posx = self.position.x/64-tileposx
	var oldpos = self.position
	match tile_id:
		0:
			self.position.y+=100*self.speed*delta
			self.position.x=tileposx*64+32
			self.rotation=self.rotation*0.9
			if len(self.get_overlapping_areas())>0 and self.get_overlapping_areas()[0] is get_script()\
				and self.get_overlapping_areas()[0].position.y>self.position.y:
					if self.get_overlapping_areas()[0].real:
						self.position = oldpos
			
		2:
			self.position.x-=100*self.speed*delta
			self.position.y=tileposy*64+32
			self.rotation=-PI/2*0.1+self.rotation*0.9
			if len(self.get_overlapping_areas())>0 and self.get_overlapping_areas()[0] is get_script()\
				and self.get_overlapping_areas()[0].position.x<self.position.x:
					if self.get_overlapping_areas()[0].real:
						self.position = oldpos
		3:
			self.position.y-=100*self.speed*delta
			self.position.x=tileposx*64+32
			self.rotation=PI*0.1+self.rotation*0.9
			if len(self.get_overlapping_areas())>0 and self.get_overlapping_areas()[0] is get_script()\
				and self.get_overlapping_areas()[0].position.y<self.position.y:
					if self.get_overlapping_areas()[0].real:
						self.position = oldpos
		4:
			self.position.x+=100*self.speed*delta
			self.position.y=tileposy*64+32
			self.rotation=PI/2*0.1+self.rotation*0.9
			if len(self.get_overlapping_areas())>0 and self.get_overlapping_areas()[0] is get_script()\
				and self.get_overlapping_areas()[0].position.x>self.position.x:
					if self.get_overlapping_areas()[0].real:
						self.position = oldpos
		5:
			if (1-posy)>(posx):
				logistics(get_parent().get_parent().get_node("logisticsMap").get_cell(tileposx-1,tileposy),delta*2)
			else:
				logistics(get_parent().get_parent().get_node("logisticsMap").get_cell(tileposx,tileposy+1),delta*2)
		6:
			if (1-posy)>(1-posx):
				logistics(get_parent().get_parent().get_node("logisticsMap").get_cell(tileposx+1,tileposy),delta*2)
			else:
				logistics(get_parent().get_parent().get_node("logisticsMap").get_cell(tileposx,tileposy+1),delta*2)
		7:
			if posy>(1-posx):
				logistics(get_parent().get_parent().get_node("logisticsMap").get_cell(tileposx+1,tileposy),delta*2)
			else:
				logistics(get_parent().get_parent().get_node("logisticsMap").get_cell(tileposx,tileposy-1),delta*2)
		8:
			if posy>posx:
				logistics(get_parent().get_parent().get_node("logisticsMap").get_cell(tileposx-1,tileposy),delta*2)
			else:
				logistics(get_parent().get_parent().get_node("logisticsMap").get_cell(tileposx,tileposy-1),delta*2)


func _process(delta):
	#print(tile_id," ",tileposx," ",tileposy)
	if self.real:
		self.speed = 0.5 * get_parent().get_parent().speedMultiplier
		var tileposx = floor(self.position.x/64)
		var tileposy = floor(self.position.y/64)
		var tile_id=get_parent().get_parent().get_node("logisticsMap").get_cell(tileposx,tileposy)
		logistics(tile_id,delta)
	
	pass
