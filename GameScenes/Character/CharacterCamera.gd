extends Camera2D

var shaking := false
var shake_intensity := 0.0
var shake_time := 0.0


func shake(intensity: float, time: float):
	if not shaking:
		shaking = true
		shake_intensity = intensity
		shake_time = time
	else:
		shake_intensity = max(shake_intensity, intensity)
		shake_time = max(shake_time, time)


func _process(delta):
	if shaking:
		shake_time -= delta / Engine.time_scale
		offset = shake_intensity * Vector2(randf_range(-1.0, 1.0), 
				randf_range(-1.0, 1.0))
		if shake_time <= 0.0:
			shake_time = 0.0
			shaking = false
