extends Label

func update_health_display(dog):
	text = str(dog.dog_stats["health_stats"]["CurrentHealth"])
