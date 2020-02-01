extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	OS.set_window_size(Vector2(640, 512))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$selectedsquares.check = $boardPieces.clicked_tile

# Populates the board with the pieces
func _load_chessboard(boardfile):
	print("CALLED _LOAD_CHESSBOARD() ON " + boardfile) 
	#get_tree().change_scene("chessboard.tscn")
	var file = File.new()
	file.open("res://boardstates/" + boardfile, File.READ)
	print("OPENING res://boardstates/" + boardfile)
	var content = file.get_as_text()
	var tilemap = get_node("boardPieces")
	print(tilemap.get_parent())
	file.close()
	var number = ""
	var cellx = 0
	var celly = 0
	for letter in content:
		if letter != ",":
			number += letter
		else:
			print("X: " + str(cellx) + ", Y: " + str(celly) + ", Tile: " + str(number))
			tilemap.set_cell(cellx,celly,int(number))
			print("TILE AT " + str(cellx) + ", " + str(celly) + " IS " + str(tilemap.get_cell(cellx,celly)))
			number = ""
			cellx += 1
			if cellx == 10:
				cellx = 0
				celly += 1
	tilemap.update_dirty_quadrants()
	var hbox = get_node("../HBoxContainer")
	hbox.hide()
	OS.set_window_size(Vector2(640, 512))
	show()