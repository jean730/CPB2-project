extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var menu_enabled = false
var selected_item=0
#var machines = 
# Called when the node enters the scene tree for the first time.
func _ready():
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
	if get_local_mouse_position().y<150 and menu_enabled:
		$TileGlow.visible=menu_enabled
		get_node("TileGlow").position.x=tileposx
		get_node("TileGlow").position.y=tileposy
	else:
		$TileGlow.visible=false

func _input(event):
	if event.is_action_pressed("toggle_menu"):
		menu_enabled = not menu_enabled
		
func _process(delta):
	move(delta)
	highlight_tile()
	get_node("Energy").text = "DogePowaah: "+str(int(get_parent().get_node("Ressources").energy))
	if menu_enabled:
		if $menu.position.y>225:
			$menu.position.y-=10
	else:
		if $menu.position.y<375:
			$menu.position.y+=10
		
	pass
