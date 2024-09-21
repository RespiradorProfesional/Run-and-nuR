extends Control

@onready var background_lobby = $background_lobby
@onready var scroll_container = $ScrollContainer
@onready var vbox_container = $ScrollContainer/search_lobby
@onready var lobby_vbox = $lobby
@onready var lobby_players = $lobby/lobby_players

var player_id
var peer = SteamMultiplayerPeer.new()
var lobby_id

func _ready():
	var api = Steam.steamInitEx(true, 480, true)
	print(api)
	Steam.join_requested.connect(_on_join_pressed)

	scroll_container.visible = false
	lobby_vbox.visible = false
	background_lobby.visible = false

func _on_host_lobby_pressed() -> void:
	peer.create_lobby(SteamMultiplayerPeer.LOBBY_TYPE_FRIENDS_ONLY, 2)
	multiplayer.multiplayer_peer = peer
	multiplayer.peer_connected.connect(_on_peer_connected)
	multiplayer.peer_disconnected.connect(_on_peer_disconnected)
	_on_peer_connected()

func _on_join_pressed(lobby_id, steam_id) -> void:
	print(lobby_id)
	peer.connect_lobby(lobby_id)
	multiplayer.multiplayer_peer = peer

func _on_search_lobby_pressed() -> void:
	pass

func join_lobby(lobby_id):
	peer.connect_lobby(lobby_id)
	multiplayer.multiplayer_peer = peer

func _on_start_pressed() -> void:
	rpc("change_scene")

func _on_peer_connected(id: int = 1) -> void:
	var player_scene = load("res://scene/ui/vbox_lobby.tscn")
	var player_instantiate = player_scene.instantiate()
	player_id = id
	player_instantiate.name = str(id)
	lobby_players.add_child(player_instantiate, true)
	player_instantiate.label_name.text = "a"
	lobby_vbox.visible = true

func _on_peer_disconnected(id: int = 1) -> void:
	pass

@rpc("any_peer", "call_local")
func change_scene() -> void:
	get_tree().change_scene_to_file("res://scene/ui/character_selector.tscn")
