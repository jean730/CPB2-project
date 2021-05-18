extends Node2D
var Mine = preload("res://Mine.tscn")
var Forge = preload("res://Forge.tscn")
var Chair = preload("res://Chair.tscn")
var CoalPlant = preload("res://Centrale.tscn")
var dezoom = false
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var coin_threshold=100000
var menu_enabled = false
enum Building_type {CONV_DOWN=0,CONV_LEFT=2,CONV_UP=3,CONV_RIGHT=4,CONV_UPLEFT=8,CONV_UPRIGHT=7,CONV_DOWNRIGHT=6,CONV_DOWNLEFT=5,MINE=10,FORGE=11,COAL_PLANT=12,CHAIR=13}
var selected_building=null
var ORE_NAME_1=""
var ORE_NAME_2=""
var ORE_NAME_3="Coal"
#var machines = 
# Called when the node enters the scene tree for the first time.
func name_generator():
	var voyelles=['a','e','i','o','u','y']
	var consonnes=['b', 'c', 'd', 'f', 'g', 'h', 'j', 'k', 'l', 'm', 'n', 'p', 'q', 'r', 's', 't', 'v', 'w', 'z']
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	for _i in range(3):
		self.ORE_NAME_1+=consonnes[rng.randi()%consonnes.size()]+voyelles[rng.randi()%voyelles.size()]
		self.ORE_NAME_2+=consonnes[rng.randi()%consonnes.size()]+voyelles[rng.randi()%voyelles.size()]
func _ready():
	name_generator()
	pass # Replace with function body.

func move(delta):
	if Input.is_key_pressed(KEY_UP):
		self.position.y-=300*delta
	if Input.is_key_pressed(KEY_DOWN):
		self.position.y+=300*delta
	if Input.is_key_pressed(KEY_LEFT):
		self.position.x-=300*delta
	if Input.is_key_pressed(KEY_RIGHT):
		self.position.x+=300*delta
		
	
	

func highlight_tile():
	var mousepos = get_global_mouse_position()
	var tileposx = floor(mousepos.x/64)*64+32-self.position.x
	var tileposy = floor(mousepos.y/64)*64+32-self.position.y
	if get_local_mouse_position().y<150 and menu_enabled and dezoom == false:
		$TileGlow.visible=menu_enabled
		get_node("TileGlow").position.x=tileposx
		get_node("TileGlow").position.y=tileposy
	else:
		$TileGlow.visible=false

func _input(event):
	var mousepos = get_global_mouse_position()
	var tileposx = floor(mousepos.x/64)
	var tileposy = floor(mousepos.y/64)
	if event.is_action_pressed("toggle_menu"):
		menu_enabled = not menu_enabled
	var dezoomPower=8.0
	if event.is_action_pressed("dezoom"):
		self.scale=Vector2(dezoomPower,dezoomPower)
		self.get_node("Camera").zoom=Vector2(dezoomPower,dezoomPower)
		self.get_node("PlayerSprite").scale=Vector2(1.0/dezoomPower,1.0/dezoomPower)
		dezoom = true
	elif event.is_action_released("dezoom"):
		self.scale=Vector2(1,1)
		self.get_node("Camera").zoom=Vector2(1,1)
		self.get_node("PlayerSprite").scale=Vector2(1,1)
		dezoom = false
	if event.is_action_released("ui_cancel"):
		get_tree().quit()
	if event.is_action_pressed("place") and menu_enabled and get_local_mouse_position().y<150:
		if selected_building != null:
			if selected_building < 10 and get_parent().get_node("logisticsMap").get_cell(tileposx,tileposy)==-1:
				if get_parent().get_node("Ressources").enough_ressources("ORE_1",1):
					get_parent().get_node("logisticsMap").set_cell(tileposx,tileposy,selected_building)
					get_parent().get_node("Ressources").use_ressources("ORE_1",1)
			elif selected_building == 11:
				if get_parent().get_node("Ressources").enough_ressources("ORE_1",5) and get_parent().get_node("Ressources").enough_ressources("ORE_2",5):
					var forge = Forge.instance()
					forge.position = Vector2(tileposx*64+32,tileposy*64+32)
					get_parent().get_node("logisticsMap").add_child(forge)
					get_parent().get_node("Ressources").use_ressources("ORE_1",5)
					get_parent().get_node("Ressources").use_ressources("ORE_2",5)
			elif selected_building == 10:
				if get_parent().get_node("Ressources").enough_ressources("ORE_2",5)	 and get_parent().get_node("map").get_cell(tileposx,tileposy)!=1:
					var mine = Mine.instance()
					mine.position = Vector2(tileposx*64+32,tileposy*64+32)
					get_parent().get_node("logisticsMap").add_child(mine)
					get_parent().get_node("Ressources").use_ressources("ORE_2",5)
			elif selected_building == 12:
				if get_parent().get_node("Ressources").enough_ressources("ORE_1",5) and get_parent().get_node("Ressources").enough_ressources("ORE_2",5) and get_parent().get_node("Ressources").enough_ressources("COAL",5):
					var coalplant = CoalPlant.instance()
					coalplant.position = Vector2(tileposx*64+32,tileposy*64+32)
					get_parent().get_node("logisticsMap").add_child(coalplant)
					get_parent().get_node("Ressources").use_ressources("ORE_1",5)
					get_parent().get_node("Ressources").use_ressources("ORE_2",5)
					get_parent().get_node("Ressources").use_ressources("COAL",5)
			elif selected_building == 13:
				if get_parent().get_node("Ressources").enough_ressources("ORE_1",5000) and get_parent().get_node("Ressources").enough_ressources("ORE_2",5000) and get_parent().get_node("Ressources").enough_ressources("COAL",5000):
					if get_parent().get_node("Ressources").energy>=2000000:
						var chair = Chair.instance()
						chair.position = Vector2(tileposx*64+32,tileposy*64+32)
						get_parent().get_node("logisticsMap").add_child(chair)
						get_parent().get_node("Ressources").use_ressources("ORE_1",5000)
						get_parent().get_node("Ressources").use_ressources("ORE_2",5000)
						get_parent().get_node("Ressources").use_ressources("COAL",5000)
						get_parent().get_node("Ressources").use_energy(2000000)
	if event.is_action_pressed("delete") and menu_enabled and get_local_mouse_position().y<150:
		if  get_parent().get_node("logisticsMap").get_cell(tileposx,tileposy)!=-1:
			get_parent().get_node("logisticsMap").set_cell(tileposx,tileposy,-1)
			get_parent().get_node("Ressources").add_ressources("ORE_1",5)
		else:
			pass
		
func _process(delta):
	move(delta)
	highlight_tile()
	get_node("Energy").text = "DogePowaah: "+str(int(get_parent().get_node("Ressources").energy))
	get_node("Coins").text = "UωUCoins: "+str(int(get_parent().get_node("Ressources").get_ressources("coins")))	
	get_node("ORE_1").text = self.ORE_NAME_1+": "+str(int(get_parent().get_node("Ressources").get_ressources("ORE_1")))
	get_node("ORE_2").text = self.ORE_NAME_2+": "+str(int(get_parent().get_node("Ressources").get_ressources("ORE_2")))
	get_node("ORE_3").text = self.ORE_NAME_3+": "+str(int(get_parent().get_node("Ressources").get_ressources("COAL")))
	if get_parent().get_node("Ressources").energy>coin_threshold:
		coin_threshold+=100000
		get_parent().get_node("Ressources").add_ressources("coins",1)
		print(coin_threshold,"  ",get_parent().get_node("Ressources").get_ressources("coins"))
		get_parent().speedMultiplier = 1+0.1*get_parent().get_node("Ressources").get_ressources("coins")
		get_parent().powerMultiplier = 1+0.1*get_parent().get_node("Ressources").get_ressources("coins")
	if menu_enabled:
		if $menu.position.y>225:
			$menu.position.y-=10
	else:
		if $menu.position.y<375:
			$menu.position.y+=10
		
	pass




func _on_machine_list_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton and event.pressed==false:
		var pos = get_local_mouse_position()
		if event.button_index==2:
			get_node("menu/machine_list/Selector").set_visible(false)
			selected_building=null
		elif event.button_index==1:
			if pos.x<-260:
				if pos.x < -449:
					if pos.y<236:
						selected_building=Building_type.CONV_DOWN
						get_node("menu/machine_list/Selector").scale=Vector2(1,1)
						get_node("menu/machine_list/Selector").position=Vector2(-480,356)
					else:
						selected_building=Building_type.CONV_UPLEFT
						get_node("menu/machine_list/Selector").scale=Vector2(1,1)
						get_node("menu/machine_list/Selector").position=Vector2(-480,417)
				elif pos.x < -386:
					if pos.y<236:
						selected_building=Building_type.CONV_LEFT
						get_node("menu/machine_list/Selector").scale=Vector2(1,1)
						get_node("menu/machine_list/Selector").position=Vector2(-416,356)
					else:
						selected_building=Building_type.CONV_UPRIGHT
						get_node("menu/machine_list/Selector").scale=Vector2(1,1)
						get_node("menu/machine_list/Selector").position=Vector2(-416,417)
				elif pos.x < -323:
					if pos.y<236:
						selected_building=Building_type.CONV_UP
						get_node("menu/machine_list/Selector").scale=Vector2(1,1)
						get_node("menu/machine_list/Selector").position=Vector2(-352,356)
					else:
						selected_building=Building_type.CONV_DOWNRIGHT
						get_node("menu/machine_list/Selector").scale=Vector2(1,1)
						get_node("menu/machine_list/Selector").position=Vector2(-352,417)
				else:
					if pos.y<236:
						selected_building=Building_type.CONV_RIGHT
						get_node("menu/machine_list/Selector").scale=Vector2(1,1)
						get_node("menu/machine_list/Selector").position=Vector2(-288,356)
					else:
						selected_building=Building_type.CONV_DOWNLEFT
						get_node("menu/machine_list/Selector").scale=Vector2(1,1)
						get_node("menu/machine_list/Selector").position=Vector2(-288,417)
			elif pos.x>-198 and pos.x<-126:
					selected_building=Building_type.FORGE
					get_node("menu/machine_list/Selector").scale=Vector2(1,1)
					get_node("menu/machine_list/Selector").position=Vector2(-163,386)
			elif pos.x>-53 and pos.x<18:
					selected_building=Building_type.MINE
					get_node("menu/machine_list/Selector").scale=Vector2(1,1)
					get_node("menu/machine_list/Selector").position=Vector2(-19,388)
			elif pos.x>95 and pos.x<165:
					selected_building=Building_type.COAL_PLANT
					get_node("menu/machine_list/Selector").scale=Vector2(1,1)
					get_node("menu/machine_list/Selector").position=Vector2(127,388)
			elif pos.x>336 and pos.x<411:
					selected_building=Building_type.CHAIR
					get_node("menu/machine_list/Selector").scale=Vector2(1,1.8)
					get_node("menu/machine_list/Selector").position=Vector2(367,387)
			print(pos.x)
			if selected_building != null:
				get_node("menu/machine_list/Selector").set_visible(true)
		print(selected_building)
