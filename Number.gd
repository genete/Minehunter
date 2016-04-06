
extends HBoxContainer

var digits=3
var digit_width=16

func _ready():
	var scale=get_node("Digit0").get_scale_for_width(digit_width)
	set_scale(Vector2(scale, scale))

func parse_number(var n):
	var s=str(n)
	var l=s.length()
	for i in range(0, l):
		var d=s.substr(l-i-1,1).to_int()
		var node=get_node("Digit"+str(i))
		node.parse_digit(d)


