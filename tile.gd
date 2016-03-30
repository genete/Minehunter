extends Control

var bombs_around=0
var flagged_around=0

###### FLAGS members
var bomb=false
## closed sprites
var sprite_closed=true
var sprite_flagged=false
var sprite_question=false
## opened sprites
var sprite_opened=false
var sprite_bomb=false
var sprite_misflagged_bomb=false
var sprite_exploded_bomb=false
var sprite_number=false

# Row and column where the tile is located
# starts with 0 and ends in N-1, M-1
var row=0
var col=0


func _ready():
	update_position()
	update_sprites()

#########################
###  GROUP MEMBERS ######
#########################

## Adds only one time a bomb at c, r.
## Increase the number of added bombs +1
## call tiles to increase the number of bombs around
func add_bomb_at(var c, var r):
	if c==col && r==row:
		if bomb:
			return
		set_bomb()
		add_to_group("bomb")
		remove_from_group("tiles")
		var board=get_parent()
		if(board):
			board.added_bombs+=1
			get_tree().call_group(2, "tiles", "added_bomb_at", c, r)

## If the tile is nearby where a bomb was added, 
## increase bombs around member
func added_bomb_at(var c, var r):
	if c==col && r==row:
		return
	else:
		if abs(col-c) <=1 && abs(row-r) <=1:
			bombs_around+=1
## User opened a closed tile that hasn't bomb or bombs_around
## Then notify to open tiles around c, r
func empty_tile_opened_at(var c, var r):
	# it is me who opened the tile
	if row==r && col ==c:
		remove_from_group("closed")
		add_to_group("opened")
		return
	# is someone else around who opened the tile
	if abs(row-r)<=1 && abs(col-c)<=1:
		if sprite_closed && !sprite_flagged && !bomb:
			open_tile()
			remove_from_group("closed")
			add_to_group("opened")
			if !sprite_number:
				get_tree().call_group(2, "closed", "empty_tile_opened_at", col, row)

## Someone flagged a tile at c, r
func flagged_added_at(var c, var r):
	if row==r && col==c:
		return
	else:
		if abs(row-r)<=1 && abs(col-c)<=1:
			flagged_around+=1

## Someone removed a flag at tile c, r
func flagged_removed_at(var c, var r):
	if row==r && col==c:
		return
	else:
		if abs(row-r)<=1 && abs(col-c)<=1:
			flagged_around-=1

## Someone clicked a opened tile at c, r
func opened_clicked_at(var c, var r):
	if row==r && col==c:
		return
	else:
		if abs(row-r)<=1 && abs(col-c)<=1:
			if bomb && sprite_flagged:
				return
			if sprite_closed:
				open_tile()
				if !sprite_number && !sprite_exploded_bomb:
					get_tree().call_group(2, "closed", "empty_tile_opened_at", col, row)

##############################
### CLASS MEMBERS ############
##############################

func set_bomb(var b=true):
	bomb=b

func get_bomb():
	return bomb
	
func set_bombs_around(var n):
	bombs_around=n
	
func get_bombs_around():
	return bombs_around

###############################
### IMPUT HANDLER #############
###############################

func _input_event(ev):
	var parent=get_parent()
	if parent.game_over:
		return
	if(ev.type==InputEvent.MOUSE_BUTTON and ev.pressed):
		if (ev.button_index==BUTTON_LEFT):
			on_left_click()
			update_sprites()
		elif (ev.button_index==BUTTON_RIGHT):
			on_right_click()
			update_sprites()

###############################
### UPDATE POSTION ############
###############################

func update_position():
	var size=get_size()
	var scale=get_scale()
	set_pos(Vector2(col*size.x*scale.x, row*size.y*scale.y))

###############################
### UPDATE SPRITES ############
###############################

func update_sprites():
	var closed_path="closed"
	var opened_path="opened"
	if sprite_closed:
		get_node(closed_path).show()
		get_node(opened_path).hide()
		get_node("closed/flag").hide()
		get_node("closed/question").hide()
		if sprite_flagged:
			get_node("closed/flag").show()
		if sprite_question:
			get_node("closed/question").show()
	if sprite_opened:
		get_node(closed_path).hide()
		get_node(opened_path).show()
		hide_numbers()
		get_node("opened/exploded").hide()
		get_node("opened/bomb").hide()
		get_node("opened/misflagged").hide()
		if sprite_exploded_bomb:
			get_node("opened/exploded").show()
		if sprite_bomb:
			get_node("opened/bomb").show() 
		if sprite_misflagged_bomb:
			get_node("opened/misflagged").show()
		var n=get_bombs_around()
		if n && sprite_number:
			get_node(str("opened/",n)).show()

###############################
### HIDE SPRITE NUMBER ########
###############################
func hide_numbers():
	for i in range(1, 9):
		get_node(str("opened/",i)).hide()

func on_left_click():
	if sprite_closed:
		if sprite_flagged:
			return
		open_tile()
		if !sprite_number && !sprite_exploded_bomb:
			get_tree().call_group(2, "closed", "empty_tile_opened_at", col, row)
	else:
		if sprite_opened:
			if bombs_around == flagged_around:
				get_tree().call_group(2, "closed", "opened_clicked_at", col, row)

func on_right_click():
	if sprite_closed:
		if !sprite_flagged && !sprite_question:
			sprite_flagged=true
			sprite_question=false
			get_tree().call_group(2, "tiles", "flagged_added_at", col, row)
			if bomb:
				add_to_group("correctly_flagged")
			else:
				add_to_group("misflagged")
			return
		if sprite_flagged:
			sprite_flagged=false
			sprite_question=true
			get_tree().call_group(2, "tiles", "flagged_removed_at", col, row)
			if bomb:
				remove_from_group("correctly_flagged")
			else:
				remove_from_group("misflagged")
			return
		if sprite_question:
			sprite_flagged=false
			sprite_question=false
			return


func open_tile( var explode=true):
	if sprite_opened:
		return
	remove_from_group("closed")
	add_to_group("opened")
	sprite_closed=false
	sprite_opened=true
	sprite_bomb=bomb
	sprite_exploded_bomb=bomb && explode
	if sprite_exploded_bomb:
		add_to_group("exploded")
	if !bomb && sprite_flagged:
		sprite_misflagged_bomb=true
		sprite_bomb=true
	sprite_number=!sprite_misflagged_bomb && !bomb && get_bombs_around()>0
	update_sprites()
