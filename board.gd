extends Control

var width=30
var height=20
var bombs=40
var added_bombs=0
var game_over=false
var game_win=false

func _ready():
	create_board()
	add_bombs()
	set_process(true)

func _process(delta):
	var exploded=get_tree().get_nodes_in_group("exploded")
	if exploded.empty():
		game_over=false
	else:
		get_tree().call_group(2, "bomb", "open_tile", false)
		get_tree().call_group(2, "misflagged", "open_tile", false)
		game_over=true 
	var misflagged=get_tree().get_nodes_in_group("misflagged")
	var correctly_flagged=get_tree().get_nodes_in_group("correctly_flagged")
	if misflagged.empty() && correctly_flagged.size()==bombs:
		game_win=true



func create_board():
	var scene=preload("res://tile.tscn")
	randomize()
	for i in range(0, height):
		for j in range(0, width):
			var tile=scene.instance()
			tile.row=i
			tile.col=j
			add_child(tile)
			tile.add_to_group("tiles")
			tile.add_to_group("closed")

func add_bombs():
	var tree=get_tree()
	while bombs-added_bombs:
		var rcol=randi()%width
		var rrow=randi()%height
		tree.call_group(2,"tiles","add_bomb_at", rcol, rrow)

func clear_board():
	var children=get_children()
	for i in children:
		remove_child(i)
		i.queue_free()

func new_game(var w, var h, var b):
	width=w
	height=h
	bombs=b
	added_bombs=0
	game_over=false
	game_win=false
	clear_board()
	create_board()
	add_bombs()
	