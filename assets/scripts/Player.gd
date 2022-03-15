extends KinematicBody

const GRAVITY = -24.8
var vel = Vector3()
const MAX_SPEED = 20
const JUMP_SPEED = 18
const ACCEL = 4.5
var fall = false
var dir = Vector3()
const DEACCEL= 16
const MAX_SLOPE_ANGLE = 40
var camera
var rotation_helper
var MOUSE_SENSITIVITY = 0.05
var hungerTime = 10
var hungerChange = 0
var thirstTime = 5
var thirstChange = 0
var interacted = null
var dialogueTime = 3
var dialogueChange = 0
var Turnip = preload("res://assets/scripts/Turnip.gd")
var Vicinity = preload("res://assets/scripts/Vicinity.gd")
func _ready():
	camera = $Rotation_Helper/Camera
	rotation_helper = $Rotation_Helper

	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _physics_process(delta):
	process_input(delta)
	process_movement(delta)
	hungerChange += delta
	thirstChange += delta
	if hungerChange > hungerTime:
		hungerChange = 0
		PlayerStore.hunger -= 1
	if thirstChange > thirstTime:
		thirstChange = 0
		PlayerStore.thirst -= 1

	if $Raycast1.get_collider():
		interacted = $Raycast1.get_collider()
	if $Raycast2.get_collider():
		interacted = $Raycast2.get_collider()
	if $Raycast3.get_collider():
		interacted = $Raycast3.get_collider()
	if interacted:
		if Input.is_action_just_pressed("interaction"):
			if is_instance_valid(interacted):
				if interacted is Turnip:
					interacted.queue_free()
					PlayerStore.hunger += 25
				if interacted is Vicinity:
					PlayerStore.message = "Dark times are ahead..."
	if PlayerStore.message != "":
		dialogueChange += delta
		if dialogueChange > dialogueTime:
			dialogueChange = 0
			PlayerStore.message = ""

func process_input(delta):

	dir = Vector3()
	var cam_xform = camera.get_global_transform()

	var input_movement_vector = Vector2()
	if Input.is_action_pressed("movement_forward"):
		input_movement_vector.y += 1
	if Input.is_action_pressed("movement_backward"):
		input_movement_vector.y -= 1
	if Input.is_action_pressed("movement_left"):
		input_movement_vector.x -= 1
	if Input.is_action_pressed("movement_right"):
		input_movement_vector.x += 1
	if Input.is_action_pressed("fall_button"):
		fall = true
	input_movement_vector = input_movement_vector.normalized()
	
	# Basis vectors are already normalized.
	dir += -cam_xform.basis.z * input_movement_vector.y
	dir += cam_xform.basis.x * input_movement_vector.x
	# ----------------------------------
	
	# ----------------------------------
	# Jumping
	if is_on_floor():
		if Input.is_action_just_pressed("movement_jump"):
			vel.y = JUMP_SPEED
	# ----------------------------------
	
	# ----------------------------------
	# Capturing/Freeing the cursor
	if Input.is_action_just_pressed("ui_cancel"):
		if Input.get_mouse_mode() == Input.MOUSE_MODE_VISIBLE:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	# ----------------------------------

func process_movement(delta):
	dir.y = 0
	dir = dir.normalized()
	if fall:
		vel.y += delta * GRAVITY
	var hvel = vel
	hvel.y = 0

	var target = dir
	target *= MAX_SPEED
	var accel
	if dir.dot(hvel) > 0:
		accel = ACCEL
	else:
		accel = DEACCEL
	hvel = hvel.linear_interpolate(target, accel * delta)
	vel.x = hvel.x
	vel.z = hvel.z
	vel = move_and_slide(vel, Vector3(0, 1, 0), 0.05, 4, deg2rad(MAX_SLOPE_ANGLE))

func _input(event):
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		rotation_helper.rotate_x(deg2rad(event.relative.y * MOUSE_SENSITIVITY * -1))
		self.rotate_y(deg2rad(event.relative.x * MOUSE_SENSITIVITY * -1))

		var camera_rot = rotation_helper.rotation_degrees
		camera_rot.x = clamp(camera_rot.x, -70, 70)
		rotation_helper.rotation_degrees = camera_rot