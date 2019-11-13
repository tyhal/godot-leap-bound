extends Spatial

# Include Player Entity
var Player = preload("res://entity/Player.tscn")

var players_devices = []
var spawn_spread = 10
var tile_size = 32

func _unhandled_input(event):
	if event is InputEventJoypadButton or event is InputEventKey:
		if event.is_action_pressed("ui_accept"):
			var id = event.device
			if event is InputEventKey:
				id = -1 # Keyboard player
			print(id)
			if not players_devices.has(id):
				players_devices.append(id)
				initialise_new_player(players_devices.size() - 1)

func initialise_new_player(player_id):
	# Create Player Entity
	var player = Player.instance()
	
	# Reposition that player in the world
	var x = rand_range(-spawn_spread, spawn_spread)
	var y = rand_range(0, spawn_spread)
	var pos = Vector3(x,y,0)
	player.set_player_id(player_id)
	player.set_device_id(players_devices[player_id])
	player.place(pos)
	
	# Tell Splitscreen plugin we are adding a player
	var render = $Splitscreen.add_player(player_id)
	
	# Create new Camera for the splitscreen
	var cam = InterpolatedCamera.new()
	$Players.add_child(player)
	render.viewport.add_child(cam)

	cam.set_target(player.get_camera_target())
	cam.set_speed(2)
	cam.set_interpolation_enabled(true)
	cam.current = true
	
func initialise_all_players():
	for i in range(players_devices.size()):
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
