
extends Control

# member variables here, example:
# var a=2
# var b="textvar"
const max_width=90
const max_height=60
const min_width=10
const min_height=10

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	var node=get_node("vertical/header/new_game")
	node.connect("pressed", self, "new_game_pressed")
	new_game_pressed()
	set_process(true)

func _process(delta):
	var board=get_node("vertical/Board")
	if board.game_win:
		var new_game=get_node("vertical/header/new_game")
		var win=preload("res://images/32x32/facewin.png")
		new_game.set_normal_texture(win)

func number_tile_pressed():
	var animation=get_node("vertical/header/new_game/new_game_player")
	animation.play("surprise")
	pass

func new_game_pressed():
	var board=get_node("vertical/Board")
	var width_node=get_node("vertical/header/cols")
	var height_node=get_node("vertical/header/rows")
	var bombs_node=get_node("vertical/header/bombs")
	var width=width_node.get_text().to_int()
	var height=height_node.get_text().to_int()
	var bombs=bombs_node.get_text().to_int()
	width=check_size(width, max_width, min_width)
	height=check_size(height, max_height, min_height)
	bombs=check_bombs(bombs, width, height)
	board.new_game(width, height, bombs)
	var new_game=get_node("vertical/header/new_game")
	var smile=preload("res://images/32x32/smile.png")
	new_game.set_normal_texture(smile)
	var board_width_pixels=width*32 ## TODO avoid this hack
	var board_height_pixels=height*32 ## TODO avoid this hack
	set_size(Vector2(board_width_pixels, board_height_pixels))

func check_size(s, max_s, min_s):
	if s<min_s:
		s=min_s
	if s>max_s:
		s=max_s
	return s

func check_bombs(b, w, h):
	var localb=b
	if b<=0:
		localb=10
	if b>int(w*h/3.0):
		localb=int(w*h/3.0)
	return localb