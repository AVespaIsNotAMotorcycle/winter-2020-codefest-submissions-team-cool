extends TileMap

var mouse_pos
const DESELECT = Vector2(-1,-1)
var clicked_tile = DESELECT #vector2 location of the clicked tile
var selected_piece #ID in the tileset of the selected piece
var active_player


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
		#if there isn't a square selected
		if (clicked_tile == DESELECT):
			clicked_tile = world_to_map(mouse_pos) #then select the clicked square
			if get_cellv(clicked_tile) == -1: #if the clicked square is empty
				clicked_tile = DESELECT #don't select it
				print(clicked_tile)
			else:
				selected_piece = get_cellv(clicked_tile)
				print(selected_piece)
		
		else: #if a square is already selected
			clicked_tile = DESELECT #deselect it
			print(clicked_tile)