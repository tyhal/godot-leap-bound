extends Spatial

# Include Player Entity
var Player = preload("res://entity/Player.tscn")

var num_players = 4
var spawn_spread = 10
var tile_size = 32

func initialise_new_player(player_number):
	# Create Player Entity
	var player = Player.instance()
	# Reposition that player in the world
	var x = rand_range(-spawn_spread, spawn_spread)
	var y = rand_range(0, spawn_spread)
	var pos = Vector3(x,y,0)
	player.place(pos)
	
	# Tell Splitscreen plugin we are adding a player
	var render = $Splitscreen.add_player(player_number)
	
	# Create new Camera for the splitscreen
	var cam = InterpolatedCamera.new()
	$Players.add_child(player)
	render.viewport.add_child(cam)
	
	# Tell that camera to follow an object slightly away from the player (see Player Entity)
	cam.translation = Vector3(x, y, 10)
	cam.set_target(player.get_camera_target())
	cam.set_speed(2)
	cam.set_interpolation_enabled(true)
	cam.current = true
	

func _ready():
	randomize()
	for i in range(num_players):
		initialise_new_player(i)