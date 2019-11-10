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
	player.set_player_id(player_number)
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
	
func initialise_all_players():
	for i in range(num_players):
		initialise_new_player(i)
		
func check_players():
	for player in $Players.get_children():
		var t = player.get_transform()
		# If lower than 10 on the map
		if t.origin.y < -10:
			$Splitscreen.remove_player(player.id)
			player.queue_free()
	if $Players.get_child_count() == 0:
		initialise_all_players()
	
func _physics_process(delta):
	check_players()

func _ready():
	randomize()
	initialise_all_players()
