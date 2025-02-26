extends Node2D

@onready var game_over_menu = %GameOverMenu

signal _on_scene_loaded

var house_scene_path = "res://scenes/house_scene.tscn"
var create_a_dog_scene_path = "res://scenes/create-a-dog.tscn"
var current_scene: Node2D

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
	
	_on_scene_loaded.emit()

func load_house_scene():
	
	current_scene.queue_free()
	
	await get_tree().create_timer(0.2).timeout
	
	if not is_instance_valid(current_scene):
		goto_scene(house_scene_path)
	
func load_create_a_dog():
	print("Loading create-a-dog")
	
	if current_scene != null:
		current_scene.queue_free()
	
	await get_tree().create_timer(0.2).timeout
	print("House scene unloaded")
	
	if not is_instance_valid(current_scene):
		goto_scene(create_a_dog_scene_path)
		
	#bind create button to load house scene
	var create_btn:Button = current_scene.get_node("%CreateDogButton")
	create_btn.button_up.connect(load_house_scene)
	
func _on_load_createa_dog_button_up():
	#load create-a-dog scene
	load_create_a_dog()
	
	 #bind retry signal to load create-a-dog
	game_over_menu.on_retry.connect(load_create_a_dog)

	%"LoadCreate-a-Dog".hide()
	
func get_current_scene() -> Node2D:
	return current_scene
