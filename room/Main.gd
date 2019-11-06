extends Node2D

var Player = preload("res://entity/Player.tscn")

var num_players = 4
var hspread = 100
var tile_size = 32

func _ready():
	randomize()
	for i in range(num_players):
		var player = Player.instance()
		var render = $Splitscreen.add_player(i)
		var pos = Vector2(rand_range(-hspread, hspread),0)
		player.place(pos)
		render.viewport.add_child(player.get_camera())
		$Players.add_child(player)