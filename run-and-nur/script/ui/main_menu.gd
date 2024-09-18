extends Control


func _on_host_pressed() -> void:
	var peer = ENetMultiplayerPeer.new()
	peer.create_server(3500,2)
	multiplayer.multiplayer_peer = peer
	multiplayer.peer_connected.connect(_on_peer_connected)
	_on_peer_connected()

func _on_join_pressed() -> void:
	var peer = ENetMultiplayerPeer.new()
	peer.create_client("localhost", 3500)  # Cambia "IP_DEL_HOST" por la dirección IP del host
	multiplayer.multiplayer_peer = peer
	

func _on_peer_connected(id: int =1) -> void:
	var new_label=Label.new()
	new_label.text=str(id)
	$VBoxContainer.add_child(new_label)
	$VBoxContainer.visible=true
	#hacer funcion rpc creo ns 


func _on_start_pressed() -> void:
	rpc("change_scene")

@rpc("any_peer", "call_local")
func change_scene() -> void:
	get_tree().change_scene_to_file("res://scene/ui/character_selector.tscn")
