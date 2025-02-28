extends Node
@onready var dog = %Dog
@onready var clock = %Clock
@onready var food_bowl: DogResource = %Bowl
func _save():
	var saved_data:SavedData = SavedData.new()
	saved_data.dog_stats = dog.dog_stats
	
	var clock_ref: Clock_Control = clock.get_node("ClockControl")
	saved_data.current_hour = clock_ref.get_current_hour()
	saved_data.current_minute = clock_ref.get_current_minute()
	
	saved_data.food_bowl_current_capacity = food_bowl.current_capacity
	
	ResourceSaver.save(saved_data, "user://savedata.tres")
	
func _load_save_data():
	
	var save_data:SavedData
	var dog_data:DogData
	var clock_ref: Clock_Control = clock.get_node("ClockControl")

	if ResourceLoader.exists("user://savedata.tres"):
		save_data = load("user://savedata.tres")
		dog_data = save_data.dog_stats
		
	dog.dog_stats = dog_data
	clock_ref.current_hour = save_data.current_hour
	clock_ref.current_minute = save_data.current_minute
	food_bowl.current_capacity = save_data.food_bowl_current_capacity
	print(food_bowl.current_capacity)

func _on_save_button_up():
	_save()


func _on_load_button_up():
	_load_save_data()
