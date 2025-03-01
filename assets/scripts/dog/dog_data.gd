class_name DogData
extends Resource

@export var dog_stats = {
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
@export var dog_position: Vector2
@export var dog_name: String
