extends TileMap

var mouse_pos
const DESELECT = Vector2(-1,-1)
var clicked_tile = DESELECT #vector2 location of the clicked tile
var selected_piece #ID in the tileset of the selected piece
var active_player


# Called when the node enters the scene tree for the first time.
func _ready():
	pass

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
			var new_tile = world_to_map(mouse_pos)
			var dist = vdistance(clicked_tile, new_tile)
			if dist.x > 1 || dist.y > 1:
				clicked_tile = DESELECT #deselect it
			elif dist == Vector2(0,0):
				clicked_tile = DESELECT
			else:
				move(clicked_tile, new_tile)
				clicked_tile = DESELECT
				
	if event is InputEventKey and event.pressed and clicked_tile != Vector2(-1,-1):
		if event.scancode == KEY_RIGHT:
			rotate_cell(clicked_tile, 90)
			clicked_tile = DESELECT
		if event.scancode == KEY_LEFT:
			rotate_cell(clicked_tile,270)
			clicked_tile = DESELECT
	
func move(start, end):
	var id = get_cellv(start)
	var state = analyze_orientation(start.x,start.y)
	set_cellv(start,-1)
	set_cellv(end,id)
	rotate_cell(end,state)

func analyze_orientation(x,y):
	if is_cell_transposed(x,y) and is_cell_x_flipped(x,y):
		return 90
	elif is_cell_transposed(x,y) and is_cell_y_flipped(x,y):
		return 270
	elif is_cell_x_flipped(x,y) and is_cell_y_flipped(x,y):
		return 180
	else:
		return 0

func rotate_cell(cell, deg):
	var targ = (analyze_orientation(cell.x,cell.y) + deg) % 360
	if targ == 0:
		set_cellv(cell, get_cellv(cell), false, false, false)
	if targ == 90:
		set_cellv(cell, get_cellv(cell), true, false, true)
	if targ == 180:
		set_cellv(cell, get_cellv(cell), true, true, false)
	if targ == 270:
		set_cellv(cell, get_cellv(cell), false, true, true)

func vdistance(start, end):
	return Vector2(abs(end.x-start.x),abs(end.y-start.y))