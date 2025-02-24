extends Node
@onready var dog = %Dog

func _save():
	var saved_data:SavedData = SavedData.new()
	saved_data.dog_stats = dog.dog_stats
	ResourceSaver.save(saved_data, "user://savedata.tres")
	
func _load_dog_data() -> DogData:
	
	var save_data:SavedData
	var dog_data:DogData
	
	if ResourceLoader.exists("user://savedata.tres"):
		save_data = load("user://savedata.tres")
		dog_data = save_data.dog_stats
		
	return dog_data
	
func _on_save_button_button_up():
	_save()


func _on_load_button_button_up():
	pass#_load()
