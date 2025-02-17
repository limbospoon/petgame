extends Node
@onready var dog = %Dog

func _save():
	var saved_data:SavedData = SavedData.new()
	saved_data.dog_stats = dog.dog_stats
	ResourceSaver.save(saved_data, "user://savegame.tres")
	
func _load():
	var save_data:SavedData = load("user://savegame.tres")
	dog.dog_stats = save_data.dog_stats
	
func _on_save_button_button_up():
	_save()


func _on_load_button_button_up():
	_load()
