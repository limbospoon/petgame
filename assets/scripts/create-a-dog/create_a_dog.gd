extends Node

var path_to_save = "user://savedata.tres"
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
	#set selected dog breed to be first in list of dog breeds
	current_breed = dog_breeds.keys()[0]
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
		
	#set selected breed to be the breed at current key index
	current_breed = dog_breeds.keys()[current_breed_index]
	%"Dog Breed".text = current_breed

func _save_dog():
	var dog_data: DogData = DogData.new()
	var save_data: SavedData = SavedData.new() 
	
	#save health
	dog_data.dog_stats["health_stats"]["MaxHealth"] = dog_breeds[current_breed]["MaxHealth"] 
	dog_data.dog_stats["health_stats"]["CurrentHealth"] = dog_breeds[current_breed]["MaxHealth"]
	
	#save hunger
	dog_data.dog_stats["hunger_stats"]["MaxHunger"] = dog_breeds[current_breed]["MaxHunger"] 
	dog_data.dog_stats["hunger_stats"]["CurrentHunger"] = 0 
	
	#save dog name
	dog_data.dog_name = %EnterDogNameBox.text
	
	#save default postion
	dog_data.dog_position = Vector2(582, 318)
	
	#check if we already have save data
	if ResourceLoader.exists(path_to_save):
		save_data = ResourceLoader.load(path_to_save)
	
	save_data.dog_data = dog_data
	save_data.dog_selection = dog_breeds[current_breed]["index"]
	
	ResourceSaver.save(save_data, path_to_save)
	

func _load_dog():
	var save_data:SavedData = SavedData.new()
	var dog_data:DogData = DogData.new()
	
	#check if we have save data
	if ResourceLoader.exists(path_to_save):
		save_data = ResourceLoader.load(path_to_save)	
		dog_data = save_data.dog_data
	
		current_breed_index = save_data.dog_selection
		
		current_breed = dog_breeds.keys()[current_breed_index]
		%EnterDogNameBox.text = dog_data.dog_name
		%"Dog Breed".text = current_breed

func _on_left_breed_arrow_button_up():
	update_breed_selection(-1)

func _on_right_breed_arrow_button_up():
	update_breed_selection(1)
