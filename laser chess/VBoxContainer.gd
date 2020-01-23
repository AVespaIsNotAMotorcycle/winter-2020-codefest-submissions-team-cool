extends VBoxContainer

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_ace_gui_input(event):
	if event is InputEventMouseButton and event.pressed:
		get_tree().change_scene("chessboard.tscn")


func _on_curious_gui_input(event):
	if event is InputEventMouseButton and event.pressed:
		get_tree().change_scene("curious.tscn")

func _on_grail_gui_input(event):
	if event is InputEventMouseButton and event.pressed:
		get_tree().change_scene("grail.tscn")


func _on_mercury_gui_input(event):
	if event is InputEventMouseButton and event.pressed:
		get_tree().change_scene("mercury.tscn")


func _on_sophie_gui_input(event):
	if event is InputEventMouseButton and event.pressed:
		get_tree().change_scene("sophie.tscn")


func _on_exit_gui_input(event):
	if event is InputEventMouseButton and event.pressed:
		get_tree().quit()
