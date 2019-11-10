extends KinematicBody

export (int) var speed = 10

var velocity = Vector3()
var GRAV = 200 # ProjectSettings.get_setting("physics/3d/default_gravity")
var id = -1

func get_camera_target():
	return $CameraTarget

func set_player_id(_id):
	id = _id		

func place(_pos):
	_pos.z = 0
	translate(_pos)
		
func _ready():
	move_lock_y = true
	
	
# Simple Movement (REF: https://pastebin.com/7bVvEJwp)
const MOVE_SPEED = 15
const JUMP_FORCE = 20
const GRAVITY = 0.98
const MAX_FALL_SPEED = 30
const H_LOOK_SENS = 1.0
const V_LOOK_SENS = 1.0
var y_velo = 0
func _physics_process(delta):
    var move_vec = Vector3()
    if Input.is_action_pressed("move_forwards"):
        move_vec.z -= 1
    if Input.is_action_pressed("move_backwards"):
        move_vec.z += 1
    if Input.is_action_pressed("ui_right"):
        move_vec.x += 1
    if Input.is_action_pressed("ui_left"):
        move_vec.x -= 1
    move_vec = move_vec.normalized()
    move_vec = move_vec.rotated(Vector3(0, 1, 0), rotation.y)
    move_vec *= MOVE_SPEED
    move_vec.y = y_velo
    move_and_slide(move_vec, Vector3(0, 1, 0))
    var grounded = is_on_floor()
    y_velo -= GRAVITY
    if grounded and Input.is_action_just_pressed("ui_up"):
        y_velo = JUMP_FORCE
    if grounded and y_velo <= 0:
        y_velo = -0.1
    if y_velo < -MAX_FALL_SPEED:
        y_velo = -MAX_FALL_SPEED
  
 