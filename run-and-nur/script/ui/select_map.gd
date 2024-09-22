extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.




func _on_city_map_pressed() -> void:
	if GlobalData.user_id!=null:
		rpc("select_map","CITY")


@rpc("authority","call_local")
func select_map(map_name):
	var scene_route
	match map_name:
		"CITY":
			scene_route=""
	print("AAAAAAA")
