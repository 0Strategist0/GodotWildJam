extends Node


# A dictionary of body positions and scenes of the form 
# {scene_name_1: {position_1: sprite_type_1, ..., 
# 				  position_n: sprite_type_n}
#  ...
#  scene_name_n: {position_1: sprite_type_1, ..., 
# 				  position_n: sprite_type_n}}
var bodies := {}

var triggered_first_hunt := false
