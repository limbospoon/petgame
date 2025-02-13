extends Node2D

var house_scene_path = "res://scenes/house_scene.tscn"
var current_scene

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func goto_scene(path):
	print("Going to scene")
	var scene_to_load = load(path).instantiate()
	get_tree().root.add_child(scene_to_load)
	current_scene = scene_to_load

func load_create_a_dog():
	print("Loading create-a-dog")
	
	
	get_tree().root.remove_child(current_scene)
	
	current_scene.queue_free()
	await get_tree().create_timer(1).timeout
	print("House scene unloaded")
	
	if not is_instance_valid(current_scene):
		goto_scene(house_scene_path)
		
	#TODO: set bindings at more apporiate time
	#get ref to gamerover manager
	var game_over_manager = current_scene.get_node("%GameOverMenu") 
	
	 #bind retry signal to load create-a-dog
	game_over_manager.on_retry.connect(load_create_a_dog)
	print("Rebinded retry")


func _on_load_house_scene_button_up():
	#load house scene
	goto_scene(house_scene_path) 
	
	#get ref to gamerover manager
	var game_over_manager = current_scene.get_node("%GameOverMenu") 
	
	 #bind retry signal to load create-a-dog
	game_over_manager.on_retry.connect(load_create_a_dog)

	%LoadHouseScene.hide()
	
