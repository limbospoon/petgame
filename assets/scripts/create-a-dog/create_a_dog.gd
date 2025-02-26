extends Node

var dog_data: DogData = DogData.new()
var dog_breeds = {
	"Poddle":
		{
			"MaxHealth": 110,
			"MaxHunger": 75,
			"index": 0
		},
	"Husky":
		{
			"MaxHealth": 150,
			"MaxHunger": 90,
			"index": 1
		},
	"Labrador":
		{
			"MaxHealth": 135,
			"MaxHunger": 80,
			"index": 2
		}
}

var current_breed = ""
var current_breed_index = 0
var MAX_BREED_SELECTION = (dog_breeds.keys().size() - 1)

func _ready():
	current_breed = dog_breeds.keys()[current_breed_index]
	%"Dog Breed".text = current_breed
	
func update_breed_selection(direction: int):
	#right selection checks
	if direction > 0 and current_breed_index < MAX_BREED_SELECTION:
		current_breed_index += 1
	elif direction > 0 and current_breed_index >= MAX_BREED_SELECTION:
		current_breed_index = 0
	
	#left selection checks
	if direction < 0 and current_breed_index > 0:
		current_breed_index -= 1
	elif direction < 0 and current_breed_index <= 0:
		current_breed_index = MAX_BREED_SELECTION
		
	current_breed = dog_breeds.keys()[current_breed_index]
	%"Dog Breed".text = current_breed

func _save_dog():
	var data:SavedData = SavedData.new()
	dog_data.dog_max_health = dog_breeds[current_breed]["MaxHealth"]
	dog_data.dog_max_hunger = dog_breeds[current_breed]["MaxHunger"]
	dog_data.dog_name = %EnterDogNameBox.text
	data.dog_selection = dog_breeds[current_breed]["index"]
	
	data.dog_stats = dog_data
	ResourceSaver.save(data, "user://savedata.tres")
	

func _load_dog():
	var save_data:SavedData = SavedData.new()
	
	#check if we have save data
	if ResourceLoader.exists("user://savedata.tres"):
		save_data = ResourceLoader.load("user://savedata.tres")	
	
	var saved_dog_data = save_data.dog_stats
	
	dog_data.dog_max_health = saved_dog_data.dog_max_health
	dog_data.dog_max_hunger = saved_dog_data.dog_max_hunger
	dog_data.dog_name = saved_dog_data.dog_name
	
	current_breed_index = save_data.dog_selection
	
	current_breed = dog_breeds.keys()[current_breed_index]
	%EnterDogNameBox.text = dog_data.dog_name
	%"Dog Breed".text = current_breed

func _on_left_breed_arrow_button_up():
	update_breed_selection(-1)

func _on_right_breed_arrow_button_up():
	update_breed_selection(1)
