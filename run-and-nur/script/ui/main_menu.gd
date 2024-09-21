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
	Steam.lobby_match_list.connect(_on_lobby_match_list)
	Steam.lobby_created.connect(_on_lobby_created)

	scroll_container.visible = false
	lobby_vbox.visible = false
	background_lobby.visible = false

func _on_lobby_created(connect: int, this_lobby_id: int) -> void:
	if connect == 1:
		lobby_id = this_lobby_id
		print("Lobby creado: %s" % lobby_id)

		# Conecta al lobby
		peer.connect_lobby(lobby_id)
		multiplayer.multiplayer_peer = peer

func _on_host_lobby_pressed() -> void:
	Steam.createLobby(Steam.LOBBY_TYPE_PUBLIC,2)

func _on_join_pressed(lobby_id, steam_id) -> void:
	peer.connect_lobby(lobby_id)
	multiplayer.multiplayer_peer = peer

func _on_search_lobby_pressed() -> void:
	# Configura el filtro de distancia para buscar lobbies
	Steam.addRequestLobbyListDistanceFilter(Steam.LOBBY_DISTANCE_FILTER_WORLDWIDE)
	# Solicita la lista de lobbies
	Steam.requestLobbyList()

func _on_lobby_match_list(these_lobbies: Array) -> void:
	# Limpia el contenedor de lobbi
	
	for lobby in these_lobbies:
		var lobby_name: String = Steam.getLobbyData(lobby, "name")
		var lobby_mode: String = Steam.getLobbyData(lobby, "mode")
		var num_members: int = Steam.getNumLobbyMembers(lobby)

		var lobby_button: Button = Button.new()
		lobby_button.text = "Lobby: %s [%d/%d]" % [lobby_name, num_members, 2]
		lobby_button.connect("pressed", Callable(self, "join_lobby").bind(lobby))
		vbox_container.add_child(lobby_button)
		scroll_container.visible=true

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
