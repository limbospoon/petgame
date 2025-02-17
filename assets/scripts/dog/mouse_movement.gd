extends Camera2D

signal mouse_clicked

func _input(event):
	#check if mouse is clicked and released
	if event is InputEventMouseButton and event.is_released():
		mouse_clicked.emit()
		
