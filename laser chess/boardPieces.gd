extends TileMap

var mouse_pos
const DESELECT = Vector2(-1,-1)
var clicked_tile = DESELECT


# Called when the node enters the scene tree for the first time.
func _ready():
	set_cell(0,0,-1)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func _input(event):
	mouse_pos = get_global_mouse_position()
	#print(event.as_text())
	
	#this event will handle selecting a square for movement or rotation
	if event is InputEventMouseButton and event.pressed: #when a square is clicked
		if (clicked_tile == DESELECT): #if there isn't a square seelected
			clicked_tile = world_to_map(mouse_pos) #then select the clicked square
			print(clicked_tile)
			if get_cellv(clicked_tile) == -1: #if the clicked square is empty
				clicked_tile = DESELECT #don't select it
				print(clicked_tile)
		else: #if a square is already selected
			clicked_tile = DESELECT #deselect it
			print(clicked_tile)