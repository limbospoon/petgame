class_name Dog
extends CharacterBody2D

signal on_death
signal on_hunger_change
signal on_health_change

@onready var _animated_sprite = $AnimatedSprite2D #get the AnimateSprite2D on the dog
@onready var state_machine: StateMachine = %StateMachine

var speed := 3:
	set(value):
		speed = clamp(value,1,6)
	get:
		return speed

var dog_stats = {
	"health_stats": {
		"MaxHealth": 100,
		"CurrentHealth": 100
	},
	"hunger_stats": {
		"MaxHunger": 100,
		"CurrentHunger": 0,
		"HungerIncreaseTime": 2,
		"HungerIncreaseAmount": 2,
		"HealthDamage": 3
	},
}

var destination: Vector2
var is_moving: bool = false

func _ready():
	#hungry()
	pass

func _process(delta):
	pass

func setup_dog(dog_data):
	dog_stats = dog_data.dog_stats
	
	#load saved postion
	position = dog_data.dog_position
	
	#update ui
	on_health_change.emit()
	on_hunger_change.emit()
	
func set_destination(pos: Vector2):
	destination = pos

func move_to_position(threshold: float = 10) -> bool:
	
	var dist = (destination - position).length()
	var direction = (destination - position).normalized()
	
	#check if target destination is to the left or right
	var dot = (direction.x * Vector2.RIGHT.x) + (direction.y * Vector2.RIGHT.y)
	
	if dot < 0:
		_animated_sprite.flip_h = false
	else:
		_animated_sprite.flip_h = true
		
	if dist > threshold: #keep moving until we have reached our goal
		_animated_sprite.play("walking")
		is_moving = true
		position += direction * speed
		
		await get_tree().create_timer(get_process_delta_time()).timeout
		move_to_position()
	elif dist < threshold: #stop moving when we reached our goal
		is_moving = false
		_animated_sprite.play("idle-bark")
		return true
	
	return false

#Called when mouse is released
func _on_camera_2d_mouse_clicked():
	
	var mouse_pos = get_global_mouse_position()
	destination = mouse_pos #Set destination to mouse pos
	
	#set target destination
	set_destination(mouse_pos)
	
	#check if we are already moving if not then move
	if not is_moving:
		move_to_position()

func hungry():
	
	var hunger_stats = dog_stats["hunger_stats"]
	var _current_hunger = hunger_stats["CurrentHunger"]
	var _max_hunger = hunger_stats["MaxHunger"]
	var _hunger_increase = hunger_stats["HungerIncreaseAmount"]
	var _increase_delay = hunger_stats["HungerIncreaseTime"]
	
	#check if hunger is less then max hunger
	if _current_hunger < _max_hunger:
		_current_hunger += _hunger_increase #increase hunger
		dog_stats["hunger_stats"]["CurrentHunger"] = _current_hunger #update current hunger in dict
		on_hunger_change.emit() #broadcast hunger change
		await get_tree().create_timer(_increase_delay).timeout #delay increasing hunger again
		hungry()
	elif _current_hunger >= _max_hunger:
		dog_stats["hunger_stats"]["CurrentHunger"] = _max_hunger #et CurrentHunger to MaxHunger
		on_hunger_change.emit()
		starving()

func starving():
	
	var health_damage = dog_stats["hunger_stats"]["HealthDamage"]
	var damage_delay = dog_stats["hunger_stats"]["HungerIncreaseTime"]
	var max_hunger = dog_stats["hunger_stats"]["MaxHunger"]
	
	#deal health damage as long as hunger is Max
	if get_current_hunger() >= max_hunger:
		dog_stats["health_stats"]["CurrentHealth"] -= health_damage #decrease health
		on_health_change.emit()
		
		if dog_stats["health_stats"]["CurrentHealth"] <= 0:
			on_death.emit()
			return
		
		await get_tree().create_timer(damage_delay).timeout #delay for next damage tick
		starving()
	else:
		hungry()
		
func get_current_hunger() -> float:
	return dog_stats["hunger_stats"]["CurrentHunger"]
	
func get_current_health() -> int:
	return dog_stats["health_stats"]["CurrentHealth"]

func restore_hunger(amount: int) -> void:
	var current_hunger = dog_stats["hunger_stats"]["CurrentHunger"]
	current_hunger -= amount
	#ensure we dont below zero
	if current_hunger < 0:
		current_hunger = 0
		
	dog_stats["hunger_stats"]["CurrentHunger"] = current_hunger
	#update ui
	%Hunger.update_hunger_display(self)
