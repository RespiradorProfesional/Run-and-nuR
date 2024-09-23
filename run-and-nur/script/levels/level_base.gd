extends Node2D

@onready var player_spawn=$player_spawn

#EL PROBLEMA ESTA EN EL MULTIPLAYER SPAWN 
#EL ORDEN AFECTA, YA QUE SI LO DEJO ASI PRIMERO EL HOST EL HOST NO VE AL USUARIO
#PERO EL USUARIO A EL SI, PERO SI PRIMERO SE SPAWNEA EL USUARIO Y DESPUES EL PLAYER NO SE VEN
#AUNQUE EL TEST SI FUNCIONA BIEN MIRAR A VER   

#PROBAR SI QUITAR EL MARKER

#NO ME IBA YA QUE INTENTABA INSTANCIAR EL PLAYER EN EL CLIENTE CUANDO SOLO SE INSTANCIA EN EL SERVIDOR

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if get_tree().is_network_server():
		# Instanciar jugadores solo en el servidor
		var player_scene_1 = load(GlobalData.chacter_player1_route)
		var player_instantiate_1 = player_scene_1.instantiate()
		player_instantiate_1.name = str(GlobalData.user_id)
		player_instantiate_1.position = player_spawn.position
		add_child(player_instantiate_1, true)

		var player_scene_2 = load(GlobalData.chacter_player2_route)
		var player_instantiate_2 = player_scene_2.instantiate()
		player_instantiate_2.name = str(GlobalData.user_id_2)
		player_instantiate_2.position = player_spawn.position
		add_child(player_instantiate_2, true)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
