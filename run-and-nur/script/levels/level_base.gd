extends Node2D

@onready var player_spawn=$player_spawn

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Solo el servidor debería instanciar los jugadores, luego replicar a los clientes
	if multiplayer.is_server():
		rpc("spawn_player", multiplayer.get_unique_id(), GlobalData.chacter_player1_route)
	else:
		# El cliente también debe solicitar su propio spawn
		rpc_id(1, "request_spawn", multiplayer.get_unique_id())

@rpc("any_peer", "call_local")
func spawn_player(player_id: int, character_route: String) -> void:
	# Verifica si el jugador ya fue instanciado, para evitar duplicados
	if get_node_or_null(str(player_id)) != null:
		return  # Ya existe un jugador con ese ID

	var player_scene = load(character_route)
	var player_instantiate = player_scene.instantiate()
	player_instantiate.name = str(player_id)
	player_instantiate.position = player_spawn.position
	
	# Agrega el jugador instanciado a la escena
	add_child(player_instantiate, true)

	print("Jugador instanciado con ID: ", player_id)

# Cliente solicita su propio spawn al servidor
@rpc("any_peer")
func request_spawn(player_id: int) -> void:
	# El servidor llama al método para instanciar el jugador
	rpc_id(player_id, "spawn_player", player_id, GlobalData.chacter_player2_route)
