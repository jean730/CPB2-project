extends TileMap


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var noise = OpenSimplexNoise.new()


# Called when the node enters the scene tree for the first time.
func generate_map():
	randomize()
	noise.seed = randi()
	noise.octaves = 1
	noise.period = 10.0
	noise.persistence = 0.2
	for x in range(-100,100):
		for y in range(-100,100):
			
			#if noise.get_noise_3d(x+7,y+2,0)>0.6:
			if noise.get_noise_3d(x,y,0)>0.6:
				self.set_cell(x,y,2)
			elif noise.get_noise_3d(x,y,1000)>0.6:
				self.set_cell(x,y,3)
			elif noise.get_noise_3d(x,y,2000)>0.6:
				self.set_cell(x,y,4)
			else:
				self.set_cell(x,y,1)
	pass # Replace with function body.

func _ready():
	generate_map()
# Called every frame. 'delta' is the elapsed time since the previous frame.
