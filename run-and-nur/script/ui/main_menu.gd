extends Control

@onready var background_lobby = $background_lobby
@onready var scroll_container = $ScrollContainer
@onready var vbox_container = $ScrollContainer/search_lobby
@onready var lobby_vbox = $lobby
@onready var lobby_players = $lobby/lobby_players
@onready var screen_waiting=$screen_waiting

var player_id
var peer = SteamMultiplayerPeer.new()
var lobby_id

func _ready():
	var api = Steam.steamInitEx(true, 480, true)
	print(api)
	Steam.join_requested.connect(_on_join_friend)
	Steam.lobby_match_list.connect(_on_lobby_match_list)
	peer.lobby_created.connect(_on_lobby_created)

	scroll_container.visible = false
	lobby_vbox.visible = false
	background_lobby.visible = false
	screen_waiting.visible=false

#BUTTONS

func _on_host_lobby_pressed() -> void:
	background_lobby.visible=true
	peer.create_lobby(SteamMultiplayerPeer.LOBBY_TYPE_PUBLIC, 2)
	multiplayer.multiplayer_peer = peer
	multiplayer.peer_connected.connect(_on_peer_connected)
	multiplayer.peer_disconnected.connect(_on_peer_disconnected)
	GlobalData.user_id=1
	_on_peer_connected()

func _on_search_lobby_pressed() -> void:
	background_lobby.visible=true
	Steam.addRequestLobbyListDistanceFilter(Steam.LOBBY_DISTANCE_FILTER_WORLDWIDE)
	Steam.requestLobbyList()
	scroll_container.visible=true

func _on_start_pressed() -> void:
	rpc("change_scene")


#CALLBACKS


func _on_lobby_created(connect,id):
	if connect:
		lobby_id=id
		Steam.setLobbyData(id,"name",str(Steam.getPersonaName()+"'s Lobby"))
		Steam.setLobbyJoinable(id,true)
		

func _on_join_friend(lobby_id, steam_id) -> void:
	join_lobby(lobby_id)

func _on_lobby_match_list(lobbies):
	for lobby in lobbies:
		var lobby_name= Steam.getLobbyData(lobby,"name")
		var mem_count= Steam.getNumLobbyMembers(lobby)
		if lobby_name=="LittleChicken's Lobby":
			print("AAAAAAAAAAAAAAAAAAAAAAAA")
		var lobby_button: Button = Button.new()
		lobby_button.set_text(lobby_name)
		lobby_button.set_size(Vector2(800, 50))
		lobby_button.connect("pressed", Callable(self, "join_lobby").bind(lobby))
		vbox_container.add_child(lobby_button)


func join_lobby(id):
	screen_waiting.visible=true
	peer.connect_lobby(id)
	multiplayer.multiplayer_peer = peer
	GlobalData.user_id=multiplayer.get_unique_id()
	lobby_id=id 

#esto solo se le ejecuta al host y no lo comparte con el otro usuario
func _on_peer_connected(id: int = 1) -> void:
	var player_scene = load("res://scene/ui/vbox_lobby.tscn")
	var player_instantiate = player_scene.instantiate()
	player_instantiate.name = str(id)
	lobby_players.add_child(player_instantiate, true)
	player_instantiate.label_name.text = "a"
	lobby_vbox.visible = true

func _on_peer_disconnected(id: int = 1) -> void:
	pass

#RPCS

@rpc("any_peer", "call_local")
func change_scene() -> void:
	get_tree().change_scene_to_file("res://scene/ui/character_selector.tscn")
