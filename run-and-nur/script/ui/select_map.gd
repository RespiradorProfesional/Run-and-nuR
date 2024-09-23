extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print(GlobalData.user_id)




func _on_city_map_pressed() -> void:
	if GlobalData.user_id==1:
		rpc("select_map","CITY")


@rpc("any_peer","call_local")
func select_map(map_name):
	var scene_route
	match map_name:
		"CITY":
			scene_route="res://scene/levels/level_city.tscn"
	call_deferred("change_scene",scene_route)

func change_scene(scene_route):
	get_tree().change_scene_to_file(scene_route)
