extends KinematicBody

export (int) var speed = 10

var velocity = Vector3()

func get_camera_target():
	return $CameraTarget
		
func place(_pos):
	_pos.z = 0
	translate(_pos)

func get_input():
    velocity = Vector3()
    if Input.is_action_pressed('ui_right'):
        velocity.x += 1
    if Input.is_action_pressed('ui_left'):
        velocity.x -= 1
    if Input.is_action_pressed('ui_down'):
        velocity.y -= 1
    if Input.is_action_pressed('ui_up'):
        velocity.y += 1
    velocity = velocity.normalized() * speed

func _physics_process(delta):
    get_input()
    velocity = move_and_slide(velocity)
	
#func _ready():
#	$Camera.current = true