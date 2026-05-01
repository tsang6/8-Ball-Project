extends RigidBody3D
var move_speed = 1
var rotate_speed = 1
var charge = 0.0
var max_force = 3.5
var is_charging = false
var cue_height = 0.01
var shot_timer = 0.0
var shot_fired = false
var start_position = Vector3.ZERO
var start_rotation = Vector3.ZERO

func _ready():
	freeze = true
	start_position = global_position
	start_rotation = rotation
	var cylinder = $"pool cue/Cylinder"
	var sphere = $"pool cue/Sphere"
	var shape1 = cylinder.mesh.create_trimesh_shape()
	var shape2 = sphere.mesh.create_trimesh_shape()
	var col1 = CollisionShape3D.new()
	var col2 = CollisionShape3D.new()
	col1.shape = shape1
	col2.shape = shape2
	col1.transform = cylinder.global_transform
	col2.transform = sphere.global_transform
	add_child(col1)
	add_child(col2)

func _physics_process(delta):
	if shot_fired:
		shot_timer += delta
		if shot_timer > 0.3:
			shot_fired = false
			shot_timer = 0.0
			freeze = true
			rotation = start_rotation
			global_position = start_position
		return
	var move_dir = Vector3.ZERO
	if Input.is_key_pressed(KEY_W):
		move_dir.z += 1
	if Input.is_key_pressed(KEY_S):
		move_dir.z -= 1
	if Input.is_key_pressed(KEY_A):
		move_dir.x += 1
	if Input.is_key_pressed(KEY_D):
		move_dir.x -= 1
	if move_dir != Vector3.ZERO:
		global_position += move_dir * move_speed * delta
		start_position = global_position
	global_position.y = cue_height
	if Input.is_key_pressed(KEY_LEFT):
		rotate_y(rotate_speed * delta)
	if Input.is_key_pressed(KEY_RIGHT):
		rotate_y(-rotate_speed * delta)
	if not Input.is_key_pressed(KEY_LEFT) and not Input.is_key_pressed(KEY_RIGHT):
		var current_y = rotation.y
		start_rotation.y = current_y
	if Input.is_key_pressed(KEY_SPACE):
		is_charging = true
		charge = min(charge + delta * 3.0, max_force)
	if not Input.is_key_pressed(KEY_SPACE) and is_charging:
		freeze = false
		var strike_dir = global_transform.basis.z
		strike_dir.y = 0  # flatten to horizontal
		strike_dir = strike_dir.normalized()
		apply_central_impulse(strike_dir * charge)
		charge = 0.0
		is_charging = false
		shot_fired = true
