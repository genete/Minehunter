
extends Control


var color_on=Color(1,0,0,1)
var color_off=Color(0.15, 0.15, 0.15, 1)
var led_is_on
var invert=false

func _ready():
	led_on()
	pass

func led_on():
	var color
	if invert:
		color=color_off
	else:
		color=color_on
	get_node("led").set_modulate(color)
	led_is_on=true
	
func led_off():
	var color
	if invert:
		color=color_on
	else:
		color=color_off
	get_node("led").set_modulate(color)
	led_is_on=false

func set_color_on(var c):
	color_on=c
	if led_is_on:
		led_on()
	else:
		led_off()

func set_color_off(var c):
	color_off=c
	if led_is_on:
		led_on()
	else:
		led_off()
