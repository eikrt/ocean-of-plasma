extends "Ant.gd"
const SPEED = 12
const TARGET_RANGE = 400
var walk_change = 0
var walk_time = 10
var input_vector = Vector3()
var target = Vector3()
var targetObject
var targetTransform
var hasTurnip = false
var Turnip = preload("res://assets/scripts/Turnip.gd")
var Storage = preload("res://assets/scripts/Vase.gd")
var storage
var g= Vector3()
func _physics_process(delta):
	._physics_process(delta)
	if hasTurnip:
		$Turnip.visible = true
		current_action = "walk_towards"
		target.x = storage.global_transform.origin.x
		target.y = storage.global_transform.origin.y
		target.z = storage.global_transform.origin.z
	else:
		$Turnip.visible = false

	if current_action == "find":
		randomize()
		target.x = self.global_transform.origin.x + rand_range(-TARGET_RANGE,0) + TARGET_RANGE/2
		target.z = self.global_transform.origin.z + rand_range(-TARGET_RANGE,0) + TARGET_RANGE/2
		target.y = self.global_transform.origin.y
		#print(target.x)
		current_action = "walk"
	if current_action == "walk":
		walk_change += delta
		if walk_change > walk_time:
			walk_time = rand_range(5,10)
			walk_change = 0
			current_action = "find"
	if current_action == "walk_towards" or current_action == "walk":
		var local_target = self.global_transform.xform_inv(target)
		self.translation = self.translation.move_toward(local_target, SPEED * delta)
		

		


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
				#current_action = "walk_towards"
				#targetObject = area
				#target.x = area.translation.x
				#target.z = area.translation.z
				#target.y = area.translation.y
				#target.x = area.global_transform.origin.x
				#target.y = area.global_transform.origin.y
				#target.z = area.global_transform.origin.z
				#print("dsf")
				#targetTransform = area.global_transform
				pass

func _on_Vicinity_area_entered(area):
	if area.name == "Turnip":

		current_action == "find"
	if area.name == "Storage":
		hasTurnip = false
		current_action == "find"
