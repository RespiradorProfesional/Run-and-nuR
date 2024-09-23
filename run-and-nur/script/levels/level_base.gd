extends Node2D

@onready var player_spawn=$player_spawn

#EL PROBLEMA ESTA EN EL MULTIPLAYER SPAWN 
#EL ORDEN AFECTA, YA QUE SI LO DEJO ASI PRIMERO EL HOST EL HOST NO VE AL USUARIO
#PERO EL USUARIO A EL SI, PERO SI PRIMERO SE SPAWNEA EL USUARIO Y DESPUES EL PLAYER NO SE VEN
#AUNQUE EL TEST SI FUNCIONA BIEN MIRAR A VER   

#PROBAR SI QUITAR EL MARKER


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var player_scene
	if multiplayer.get_unique_id()==1:
		player_scene= load(GlobalData.chacter_player1_route)
	else :
		player_scene= load(GlobalData.chacter_player2_route)
	var player_instantiate= player_scene.instantiate()
	player_instantiate.name=str(multiplayer.get_unique_id())
	player_instantiate.position=player_spawn.position
	add_child(player_instantiate,true)



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
