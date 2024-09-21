extends Control

@onready var background_lobby=$background_lobby
@onready var scroll_container=$ScrollContainer
@onready var vbox_container=$ScrollContainer/search_lobby
@onready var lobby_vbox=$lobby
@onready var lobby_players=$lobby/lobby_players

var player_id
var peer = SteamMultiplayerPeer.new()
var lobby_id

func _ready():
	var api = Steam.steamInitEx(true,480, true)
	print(api)
	Steam.join_requested.connect(_on_join_friend_pressed)
	Steam.lobby_match_list.connect(_on_lobby_match_list)
	Steam.lobby_created.connect(_on_lobby_created)
	
	scroll_container.visible=false
	lobby_vbox.visible=false
	background_lobby.visible=false

func _on_host_lobby_pressed() -> void:
	Steam.createLobby(Steam.LOBBY_TYPE_PUBLIC, 2)  # Crea un lobby público con un máximo de 2 jugadores

func _on_search_lobby_pressed() -> void:
	# Set distance to worldwide
	Steam.addRequestLobbyListDistanceFilter(Steam.LOBBY_DISTANCE_FILTER_WORLDWIDE)
	Steam.requestLobbyList()
	scroll_container.visible=true

func _on_lobby_match_list(these_lobbies: Array) -> void:
	for this_lobby in these_lobbies:
		# Pull lobby data from Steam, these are specific to our example
		var lobby_name: String = Steam.getLobbyData(this_lobby, "name")
		var lobby_mode: String = Steam.getLobbyData(this_lobby, "mode")

		# Get the current number of members
		var lobby_num_members: int = Steam.getNumLobbyMembers(this_lobby)

		# Create a button for the lobby
		var lobby_button: Button = Button.new()
		lobby_button.set_text("Lobby %s: %s [%s] - %s Player(s)" % [this_lobby, lobby_name, lobby_mode, lobby_num_members])
		lobby_button.set_size(Vector2(800, 50))
		lobby_button.set_name("lobby_%s" % this_lobby)
		lobby_button.connect("pressed", Callable(self, "join_lobby").bind(this_lobby))

		# Add the new lobby to the list
		vbox_container.add_child(lobby_button)

func join_lobby(this_lobby_id: int) -> void:
	# Make the lobby join request to Steam
	peer.connect_lobby(lobby_id)
	multiplayer.multiplayer_peer = peer

func _on_join_friend_pressed(lobby_id, steam_id):
	peer.connect_lobby(lobby_id)
	multiplayer.multiplayer_peer = peer

func _on_lobby_created(connect: int, this_lobby_id: int) -> void:
	if connect == 1:
		# Guardar el ID del lobby
		lobby_id = this_lobby_id
		print("Lobby creado: %s" % lobby_id)

		# Configura el lobby como joinable
		Steam.setLobbyJoinable(lobby_id, true)

		# Puedes agregar más datos del lobby si lo necesitas
		Steam.setLobbyData(lobby_id, "name", "Nombre de tu lobby")

		peer.create_lobby(SteamMultiplayerPeer.LOBBY_TYPE_PUBLIC,2)
		# Asignar el SteamMultiplayerPeer al sistema multijugador una vez creado el lobby
		multiplayer.multiplayer_peer = peer

		# Conectar eventos de jugador conectado y desconectado
		multiplayer.peer_connected.connect(_on_peer_connected)
		multiplayer.peer_disconnected.connect(_on_peer_disconnected)

		_on_peer_connected()

func _on_start_pressed() -> void:
	rpc("change_scene")

func _on_peer_connected(id: int =1) -> void:
	var player_scene= load("res://scene/ui/vbox_lobby.tscn")
	var player_instantiate= player_scene.instantiate()
	player_id=id
	player_instantiate.name=str(id)
	lobby_players.add_child(player_instantiate,true)
	player_instantiate.label_name.text="a"
	lobby_vbox.visible = true


func _on_peer_disconnected(id: int =1) -> void:
	pass

@rpc("any_peer", "call_local")
func change_scene() -> void:
	get_tree().change_scene_to_file("res://scene/ui/character_selector.tscn")
