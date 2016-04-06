
extends GridContainer

const led_size=480
const grid_width=5
const grid_height=7

var grid_width_pixels=32

func _ready():
	parse_digit(0)

func get_scale_for_width(var width_pixels):
	var scale
	scale=float(width_pixels)/led_size/grid_width
	return scale

func parse_digit(var n):
	var node=get_node("dictionary")
	var dic=node.d
	var array=dic[n]
	var row=0
	for r in array:
		var col=0
		for l in r:
			var led=get_node("slot"+str(row)+str(col))
			if l:
				led.led_on()
			else:
				led.led_off()
			col=col+1
		row=row+1

func invert():
	for c in range(grid_width):
		for r in range(grid_height):
			var led=get_node("slot"+str(r)+str(c))
			led.invert=true
