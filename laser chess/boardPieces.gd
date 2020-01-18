extends TileMap

var mouse_pos
var clicked_tile = Vector2(-1,-1)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	mouse_pos = get_global_mouse_position()
	if Input.is_mouse_button_pressed(1):
		if (clicked_tile == Vector2(-1,-1)):
			clicked_tile = world_to_map(mouse_pos)
			print(clicked_tile)
		else:
			clicked_tile = Vector2(-1,-1)