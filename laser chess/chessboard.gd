extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	OS.set_window_size(Vector2(840, 512))
	_save_board_state(get_tree().get_current_scene().get_name() + ".txt")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$selectedsquares.check = $boardPieces.clicked_tile

# Populates the board with the pieces
func _load_chessboard(boardfile):
	#Open and read boardfile
	print("CALLED _LOAD_CHESSBOARD() ON " + boardfile) 
	var file = File.new()
	file.open("res://boardstates/" + boardfile, File.READ)
	print("OPENING res://boardstates/" + boardfile)
	var content = file.get_as_text()
	var tilemap = get_node("boardPieces")
	print(tilemap.get_parent())
	file.close()
	#Loop through boardfile data and place pieces on the board
	var number = ""
	var cellx = 0
	var celly = 0
	for letter in content:
		if letter != ",":
			number += letter
		else:
			if celly < 8: #Place pieces
				tilemap.set_cell(cellx,celly,int(number))
				number = ""
				cellx += 1
				if cellx == 10:
					cellx = 0
					celly += 1
			else: #Rotate pieces
				tilemap.init_rotate_cell(Vector2(cellx,celly - 8), int(number))
				number = ""
				cellx += 1
				if cellx == 10:
					cellx = 0
					celly += 1
	#Update the camera
	tilemap.update_dirty_quadrants()
	var hbox = get_node("../HBoxContainer")
	hbox.hide()
	OS.set_window_size(Vector2(840, 512))
	show()
	
#Read the position and rotation of each tile in a scene and save it to a corresponding .txt file
func _save_board_state(boardfile):
	#Open boardfile
	print("CALLED _SAVE_BOARD_STATE()") 
	var file = File.new()
	file.open("res://boardstates/" + boardfile, File.WRITE)
	print("OPENING res://boardstates/" + boardfile)
	var tilemap = get_node("boardPieces")
	var cellx = 0
	var celly = 0
	var data = ""
	while celly < 8: #Save positions
		data += str(tilemap.get_cell(cellx, celly)) + ","
		cellx += 1
		if cellx == 10:
			cellx = 0
			celly += 1
	celly = 0
	cellx = 0
	while celly < 8: #Save rotation
		data += str(tilemap.analyze_orientation(cellx, celly)) + ","
		cellx += 1
		if cellx == 10:
			cellx = 0
			celly += 1
	file.store_line(data)
	file.close()