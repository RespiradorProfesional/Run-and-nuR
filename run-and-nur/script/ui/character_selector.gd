extends Control

@onready var player_1_texture=$VBoxContainer/HBoxContainer/player_1_texture
@onready var player_2_texture=$VBoxContainer/HBoxContainer/player_2_texture
var player_1_character
var player_2_character

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_button_pressed() -> void:
	rpc("rpc_button") 

@rpc("any_peer","call_local")
func rpc_button() :
	print(name)


func _on_rocket_pressed() -> void:
	rpc("select_character", "ROCKET", GlobalData.user_id)

func _on_emi_pressed() -> void:
	rpc("select_character", "EMI", GlobalData.user_id)

@rpc("any_peer","call_local")
func select_character(character_name,player_id):
	print(player_id)
	match character_name:
		"ROCKET":
			if player_id!=null:
				player_1_texture.texture=load("res://assets/ui/character_selector_photos/Rocket.png")
			else:
				player_2_texture.texture=load("res://assets/ui/character_selector_photos/Rocket.png")
		"EMI":
			if player_id!=null:
				player_1_texture.texture=load("res://icon.svg")
			else:
				player_2_texture.texture=load("res://icon.svg")
