extends Node2D

@onready var player_spawn=$player_spawn

#TUVE VARIOS PROBLEMAS, UNO FUE DE QUE EL QUE SPAWNEA COSAS ES EL SERVER
#COMO EN EL EJEMPLO DE PEER_CONECTED O AQUI QUE SE SPAWNEA EL PLAYER PARA PODER CONTROLARLO EL OTRO
#PERO EL OTRO NUNCA LO SPAWNEA REALMENTE POR CODIGO SINO QUE SE ENCARGA EL MULTIPLAYER

#Y OTRO PROBLEMA ES QUE EL MULTIPLAYERSPAWNER NECESITABA UN TIEMPO PARA PODER REALIZAR SPAWNS DE PLAYERS
#YA QUE AL PARECER SI LO HACIA EN READY NO LE DABA TIEMPO A EJECUTARSE

var character_1
var character_2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_timer_timeout() -> void:
	if multiplayer.get_unique_id()==1:
		# Instanciar jugadores solo en el servidor
		var player_scene_1 = load(GlobalData.chacter_player1_route)
		var player_instantiate_1 = player_scene_1.instantiate()
		player_instantiate_1.name = str(GlobalData.user_id)
		player_instantiate_1.position = player_spawn.position
		character_1=player_instantiate_1
		add_child(character_1, true)

		var player_scene_2 = load(GlobalData.chacter_player2_route)
		var player_instantiate_2 = player_scene_2.instantiate()
		player_instantiate_2.name = str(GlobalData.user_id_2)
		player_instantiate_2.position = player_spawn.position
		character_2=player_instantiate_2
		add_child(character_2, true)
