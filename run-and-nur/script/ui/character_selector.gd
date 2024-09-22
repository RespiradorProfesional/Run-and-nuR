extends Control

@onready var player_1_texture=$VBoxContainer/HBoxContainer/player_1_texture
@onready var player_2_texture=$VBoxContainer/HBoxContainer/player_2_texture
var player_1_character
var player_2_character
var player_1_select=false
var player_2_select=false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_start_game_pressed() -> void:
	if player_1_select and player_2_select:
		rpc("select_map")

@rpc("any_peer","call_local")
func select_map() :
	get_tree().change_scene_to_file("res://scene/ui/select_map.tscn")


func _on_rocket_pressed() -> void:
	rpc("select_character", "ROCKET", GlobalData.user_id)

func _on_emi_pressed() -> void:
	rpc("select_character", "EMI", GlobalData.user_id)

#se llama en todos los pcs pero al poner la variable de player_id no se aplica al usuario contrario
@rpc("any_peer","call_local")
func select_character(character_name,player_id):
	print(player_id)
	var new_texture
	var character_route
	match character_name:
		"ROCKET":
			new_texture=load("res://assets/ui/character_selector_photos/Rocket.png")
			character_route="res://scene/characters/rocket_character.tscn"
		"EMI":
			new_texture=load("res://icon.svg")
			character_route="res://scene/characters/base_character.tscn"
	
	if player_id==1:
		player_1_texture.texture=new_texture
		GlobalData.chacter_player1_route=character_route
		player_1_select=true
	else:
		player_2_texture.texture=new_texture
		GlobalData.chacter_player2_route=character_route
		player_2_select=true
