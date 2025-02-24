extends Label

func update_hunger_display(dog):
	text = str(dog.dog_stats["hunger_stats"]["CurrentHunger"])
	
