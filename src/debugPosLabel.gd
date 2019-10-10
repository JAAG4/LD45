extends Label

var player :Node2D
func _process(delta):
	player = get_parent().get_parent().find_node("Player")
	if player != null:
		text = str(player.position)