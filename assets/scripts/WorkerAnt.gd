extends "Ant.gd"
const SPEED = 10
var walk_change = 0
var walk_time = 5
var input_vector = Vector3()
var target = Vector3()
var hasTurnip = false
var Turnip = preload("res://assets/scripts/Turnip.gd")
var Storage = preload("res://assets/scripts/Vase.gd")
var storage
func _physics_process(delta):
	._physics_process(delta)
	if hasTurnip:
		$Turnip.visible = true
		current_action = "walk_towards"
		target.x = storage.transform.origin.x
		target.y = storage.transform.origin.y
		target.z = storage.transform.origin.z
	else:
		$Turnip.visible = false
	if current_action == "find":
		target.x = self.translation.x + rand_range(-100,0) + 50
		target.z = self.translation.z + rand_range(-100,0) + 50
		current_action = "walk"
	if current_action == "walk":
		walk_change += delta
		if walk_change > walk_time:
			walk_change = 0
			current_action = "find"
	if current_action == "walk_towards" or current_action == "walk":
		#print(self.translation, " ", target)
		var flat_translation = Vector3(self.translation.x, self.translation.y, self.translation.z)
		#flat_translation.y = target.y
		translation = self.translation.move_toward(target, delta * SPEED)
		


func _on_Area_area_entered(area):
	if current_action != "return" and area.name != "Ground" and area.name != "Player":
		current_action = "find"
	if area is Turnip:
		hasTurnip = true
		area.queue_free()
	if area is Storage:
		current_action = "find"
		hasTurnip = false

func _on_TurnipVicinity_area_entered(area):
	if current_task == "farm":
		if current_action == "walk":

			if area is Turnip and is_instance_valid(area):
				current_action = "walk_towards"
				target.x = area.global_transform.origin.x
				target.y = area.global_transform.origin.y
				target.z = area.global_transform.origin.z
				#target.x = area.translation.x
				#target.z = area.translation.z
				#target.y = area.translation.y
				

func _on_Vicinity_area_entered(area):
	if area.name == "Turnip":

		current_action == "find"
	if area.name == "Storage":
		hasTurnip = false
		current_action == "find"
