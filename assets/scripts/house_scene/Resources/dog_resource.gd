class_name DogResource
extends Area2D

enum EResourceType{
	FOOD,
	WATER
}
var resource_type: EResourceType = EResourceType.FOOD

var restore_amount: int = 5
var current_capacity: int = MAX_CAPACITY
var decrease_capacity: int = 25

const MAX_CAPACITY: int = 100

func _restore(dog: Dog):
	print("restored")
	
func restore_resource(amount: int):
	current_capacity += amount
	if current_capacity > MAX_CAPACITY:
		current_capacity = MAX_CAPACITY
