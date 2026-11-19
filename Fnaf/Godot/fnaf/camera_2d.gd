extends Camera2D

@export var ancho_imagen: float = 1920.0 
@export var camera_speed: float = 5.0
@export var monitor: CanvasItem # Nueva casilla para tu nodo Monitor

var max_horizontal_offset: float = 0.0

func _ready():
	var ancho_pantalla = get_viewport_rect().size.x
	if ancho_imagen > ancho_pantalla:
		max_horizontal_offset = (ancho_imagen - ancho_pantalla) / 2.0
	else:
		max_horizontal_offset = 0.0 

func _process(delta):
	# Si el monitor está visible, detenemos aquí la función y la cámara se queda quieta
	if monitor and monitor.visible:
		return

	var viewport_size = get_viewport_rect().size
	var mouse_position = get_viewport().get_mouse_position()

	var mouse_direction = (mouse_position.x / viewport_size.x) * 2.0 - 1.0
	mouse_direction = clamp(mouse_direction, -1.0, 1.0)

	var target_offset = mouse_direction * max_horizontal_offset

	offset.x = lerp(
		offset.x,
		target_offset,
		1.0 - exp(-camera_speed * delta)
	)
