class_name SaveManager

extends Node
@onready var dog = %Dog
@onready var clock = %Clock
@onready var food_bowl = %FoodBowl

var path_to_save_data = "user://savedata.tres"

func _ready():
	_load_save_data()

func _save():
	var saved_data:SavedData = SavedData.new()
	var dog_data:DogData = DogData.new()
	var dog_resource: DogResource = food_bowl.get_node("%Bowl")
	var clock_ref: Clock_Control = clock.get_node("ClockControl")
	
	#save dog stats
	dog_data.dog_stats = dog.dog_stats
	saved_data.dog_data = dog_data
	dog_data.dog_position = dog.position
	
	#save time
	saved_data.current_hour = clock_ref.get_current_hour()
	saved_data.current_minute = clock_ref.get_current_minute()
	
	#save bowl capacity
	saved_data.food_bowl_current_capacity = dog_resource.current_capacity
	
	ResourceSaver.save(saved_data, path_to_save_data)
	
func _load_save_data():
	
	var save_data:SavedData
	var dog_data:DogData
	var clock_ref: Clock_Control = clock.get_node("ClockControl")
	var dog_resource: DogResource = food_bowl.get_node("%Bowl")
	
	#check if we have save data
	if ResourceLoader.exists(path_to_save_data):
		save_data = load(path_to_save_data)
		dog_data = save_data.dog_data
		
		#load dog data
		dog.setup_dog(dog_data)
		
		#load saved clock time
		clock_ref.current_hour = save_data.current_hour
		clock_ref.current_minute = save_data.current_minute
		
		#load food bowl capacity
		dog_resource.current_capacity = save_data.food_bowl_current_capacity
		print(dog_resource.current_capacity)

func _on_save_button_up():
	_save()


func _on_load_button_up():
	_load_save_data()
