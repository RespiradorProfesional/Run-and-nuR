extends Node2D


@onready var hud=$Hud
var player_id=1

# Called when the node enters the scene tree for the first time.
func _on_host_pressed() -> void:
	var peer = ENetMultiplayerPeer.new()
	peer.create_server(3500,2)
	multiplayer.multiplayer_peer = peer
	multiplayer.peer_connected.connect(_on_peer_connected)
	_on_peer_connected()
	hud.visible=false
	print(player_id)

func _on_join_pressed() -> void:
	var peer = ENetMultiplayerPeer.new()
	peer.create_client("localhost", 3500)  # Cambia "IP_DEL_HOST" por la dirección IP del host
	multiplayer.multiplayer_peer = peer
	hud.visible = false

func _on_peer_connected(id: int =1) -> void:
	var player_scene= load("res://scene/test/test_player.tscn")
	var player_instantiate= player_scene.instantiate()
	player_id=id
	player_instantiate.name=str(id)
	print(player_id)
	add_child(player_instantiate,true)



#asi se podrian diferenciar

func _on_button_2_pressed() -> void:
	if player_id==1:
		rpc("player_1") 
	else:
		rpc("player_2") 

#ESTO LO HAGO PORQUE ES LO UNICO QUE SE DE RPC EL QUE LLAMA AL METODO EN TODOS
@rpc("any_peer","call_local")
func player_1() :
	$Sprite2D.scale=Vector2(2,2)

@rpc("any_peer","call_local")
func player_2() :
	$Sprite2D.scale=Vector2(1,1)

#esto hace que se llamen en todos los ordenadores a la vez
func _on_button_pressed() -> void:
	rpc("rpc_button") 

@rpc("any_peer","call_local")
func rpc_button() :
	print(player_id)
	$Sprite2D.visible=true 
