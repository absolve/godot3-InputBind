extends Node2D



onready var sprite=$Sprite
onready var popup=$PopupPanel
var vec=Vector2.ZERO
var speed=500


func _ready():
	pass # Replace with function body.


func _process(delta):
	vec=Vector2.ZERO
	if Input.is_action_pressed("move_down"):
		vec=Vector2.DOWN
	if Input.is_action_pressed("move_up"):
		vec=Vector2.UP
	if Input.is_action_pressed("move_right"):
		vec=Vector2.RIGHT
	if Input.is_action_pressed("move_left"):
		vec=Vector2.LEFT	
	
	sprite.position+=vec*speed*delta
	pass


func _on_Button_pressed():
	popup.popup_centered()
	pass # Replace with function body.
