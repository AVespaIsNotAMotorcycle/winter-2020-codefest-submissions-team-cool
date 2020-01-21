extends TileMap

var mouse_pos
const DESELECT = Vector2(-1,-1)
var clicked_tile = DESELECT #vector2 location of the clicked tile
var selected_piece #ID in the tileset of the selected piece
var active_player
var turn_pred = true


# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass #signal to make that tile green
	
func _input(event):
	mouse_pos = get_global_mouse_position()
	
	#this event will handle selecting a square for movement or rotation
	if event is InputEventMouseButton and event.pressed: #when a square is clicked
		#if there isn't a square selected
		if (clicked_tile == DESELECT):
			clicked_tile = world_to_map(mouse_pos) #then select the clicked square
			var id = get_cellv(clicked_tile)
			if id == -1: #if the clicked square is empty
				clicked_tile = DESELECT #don't select it
			elif (turn_pred && (id >= 5)) || (!turn_pred && (id < 5)): #if the selected piece isn't yours
				clicked_tile = DESELECT#don't select it
			else:
				selected_piece = get_cellv(clicked_tile)
				print(clicked_tile)
				print(selected_piece)
				print(analyze_orientation(clicked_tile.x,clicked_tile.y))
				
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
				turn_pred = !turn_pred
				fire_cannon()
				
	#rotate a selected piece by 
	if event is InputEventKey and event.pressed and clicked_tile != Vector2(-1,-1):
		if event.scancode == KEY_RIGHT:
			rotate_cell(clicked_tile, 90)
			clicked_tile = DESELECT
			turn_pred = !turn_pred
			fire_cannon()
		if event.scancode == KEY_LEFT:
			rotate_cell(clicked_tile,270)
			clicked_tile = DESELECT
			turn_pred = !turn_pred
			fire_cannon()
	
	
	
func fire_cannon():
	if (turn_pred && get_cellv(9,7) == -1) || (!turn_pred && get_cellv(0,0) == -1):
		return
		
	var direction
	var tile = Vector2(0,0)
	if turn_pred:
		direction = analyze_orientation(9,7)
		tile = Vector2(9,7)
		#as long as the laser remains in bounds:
		while (tile.x > -1 && tile.x < 10 && tile.y > -1 && tile.y < 8):
			#check each next_tile and update direction. If it's a hit, destroy and return
			var id = get_cellv(tile)
			
			#logic for king
			if id % 5 == 0:
				end_game()
			
			#logic for cannon
			if id % 5 == 1:
				set_cellv(tile, -1)
			
			
			#logic for triangular mirror
			if id % 5 == 2:
				pass
			
			#logic for diagonal mirror
			if id % 5 == 3:
				if analyze_orientation(tile) == 0 || analyze_orientation(tile) == 180:
					if direction == 0:
						direction = 90
					if direction == 90:
						direction = 0
					if direction == 180:
						direction = 270
					if direction == 270:
						direction == 180
				else:
					if direction == 0:
						direction = 279
					if direction == 270:
						direction = 0
					if direction == 180:
						direction = 90
					if direction == 90:
						direction == 180
			
			#logic for block
			if id % 5 == 4:
				pass
			
			#if nothing was destroyed, move laser
			if direction == 0:
				tile = Vector2(tile.x, tile.y - 1)
			if direction == 90:
				tile = Vector2(tile.x + 1, tile.y)
			if direction == 180:
				tile = Vector2(tile.x, tile.y + 1)
			if direction == 270:
				tile = Vector2(tile.x - 1, tile.y)
			
		
		
	else:
		direction = analyze_orientation(0,0)
		#while (next_tile.x > -1 && next_tile.x < 10 && next_tile.y > -1 && next_tile.y < 8):
		#	pass #check each next_tile and update direction. If it's a hit, destroy and return
"""

func end_game():
	print("Game over!")

func move(start, end):
	var id = get_cellv(start)
	var id2 = get_cellv(end)
	if id % 5 == 1:
		clicked_tile = DESELECT
	if id2 % 5 == 0:
		end_game()
		
	"""
	// these statements allowed for some pieces to take others like in classic chess
	if turn_pred && (id2 < 5 && id2 != -1):
		clicked_tile = DESELECT
		turn_pred = !turn_pred
	elif !turn_pred && (id2 > 4):
		clicked_tile = DESELECT
		turn_pred = !turn_pred
	"""
	if id2 != -1:
		clicked_tile = DESELECT
		turn_pred = !turn_pred
	
	else:
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
	if get_cellv(cell) == 1: #red cannon
		if analyze_orientation(cell.x,cell.y) == 0:
			deg = 270
		elif analyze_orientation(cell.x,cell.y) == 270:
			deg = 90
	if get_cellv(cell) == 6: #blue cannon
		if analyze_orientation(cell.x,cell.y) == 90:
			deg = 90
		elif analyze_orientation(cell.y,cell.y) == 180:
			deg = 270
	
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