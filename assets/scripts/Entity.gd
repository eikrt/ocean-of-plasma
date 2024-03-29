extends KinematicBody
const GRAVITY = -24.8
var vel = Vector3()
var velocity = Vector3()
const MAX_SPEED = 20
const JUMP_SPEED = 18
const ACCEL = 4.5
var fall = true
var dir = Vector3()

const DEACCEL= 16
const MAX_SLOPE_ANGLE = 40

func _physics_process(delta):
	process_movement(delta)
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
