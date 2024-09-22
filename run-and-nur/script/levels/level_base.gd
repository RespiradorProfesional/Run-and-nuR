extends Node2D

@onready var player_spawn=$player_spawn

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	rpc("spawn_player", multiplayer.get_unique_id(), GlobalData.chacter_player1_route if GlobalData.user_id == 1 else GlobalData.chacter_player2_route)

# Función remota para instanciar a los jugadores en todos los peers
@rpc("any_peer", "call_local")
func spawn_player(player_id: int, character_route: String) -> void:
	var player_scene = load(character_route)
	var player_instantiate = player_scene.instantiate()
	player_instantiate.name = str(player_id)
	player_instantiate.position = player_spawn.position
	
	# Agrega el jugador instanciado a la escena
	add_child(player_instantiate, true)

	print("Jugador instanciado con ID: ", player_id)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
