extends Node2D

@onready var player_spawn=$player_spawn

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if GlobalData.user_id==1:
		var player_scene_1= load(GlobalData.chacter_player1_route)
		var player_instantiate_1= player_scene_1.instantiate()
		player_instantiate_1.name=str(GlobalData.user_id)
		player_instantiate_1.position=player_spawn.position
		add_child(player_instantiate_1,true)
	else:
		var player_scene_2= load(GlobalData.chacter_player2_route)
		var player_instantiate_2= player_scene_2.instantiate()
		player_instantiate_2.name=str(GlobalData.user_id)
		player_instantiate_2.position=player_spawn.position
		add_child(player_instantiate_2,true)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
