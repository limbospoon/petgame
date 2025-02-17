extends Node

@onready var dog_name = %EnterDogNameBox

func save():
	var file = FileAccess.open("res://dogdata.data", FileAccess.WRITE)
	
	#check if dog name is blank
	if dog_name.text != "":
		file.store_var(dog_name.text)
	else:
		print("Please enter a name")
	file.close()

func load():
	var file = FileAccess.open("res://dogdata.data", FileAccess.READ)
	
	dog_name.text = file.get_var()
	file.close()
