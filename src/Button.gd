extends Button



func _on_Button_button_up():
	get_tree().change_scene("res://src/Restart.tscn")
	#This re-start button feature was added AFTER Ludum Dare
