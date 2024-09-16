extends Node2D

var peer : ENetMultiplayerPeer= ENetMultiplayerPeer.new()
@onready var hud=$Hud
var player_id


# Called when the node enters the scene tree for the first time.
func _on_host_pressed() -> void:
	peer.create_server(3500,2)
	multiplayer.multiplayer_peer = peer
	multiplayer.peer_connected.connect(_on_peer_connected)
	_on_peer_connected()
	hud.visible=false

func _on_join_pressed() -> void:
	peer.create_client("localhost",3500)
	multiplayer.multiplayer_peer = peer
	hud.visible=false

func _on_peer_connected(id: int =1) -> void:
	var player_scene= load("res://scene/test/test_player.tscn")
	var player_instantiate= player_scene.instantiate()
	player_id=id
	player_instantiate.name=str(id)
	
	add_child(player_instantiate,true)

#ver quien pulsa o no el boton 
