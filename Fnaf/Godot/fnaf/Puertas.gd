extends Node2D

@export var tiempo_desaparecido: float = 2.0
@export var color_negro: Color = Color.BLACK
@export var color_gris: Color = Color.GRAY

@export_group("Sistema 1 (Botón 1 + Botón 3)")
@export var boton_1: Button
@export var polygon_1a: Polygon2D
@export var polygon_1b: Polygon2D
@export var boton_3: Button
@export var polygon_3: Polygon2D

@export_group("Sistema 2 (Botón 2 + Botón 4)")
@export var boton_2: Button
@export var polygon_2a: Polygon2D
@export var polygon_2b: Polygon2D
@export var boton_4: Button
@export var polygon_4: Polygon2D

@export_group("Barra Inferior")
@export var barra_inferior: Control
@export var escena_monitor: CanvasItem # Cambiado de Control a CanvasItem

var esta_en_gris: Dictionary = {}

func _ready():
	configurar_grupo_color(boton_3, polygon_3)
	configurar_grupo_color(boton_4, polygon_4)
	
	configurar_grupo_ocultar(boton_1, polygon_1a, polygon_1b, polygon_3)
	configurar_grupo_ocultar(boton_2, polygon_2a, polygon_2b, polygon_4)
	
	configurar_barra_inferior()

# --- LÓGICA PARA OCULTAR POLÍGONOS ---
func configurar_grupo_ocultar(boton: Button, poly_a: Polygon2D, poly_b: Polygon2D, poly_color: Polygon2D):
	if not boton:
		return
		
	boton.modulate.a = 0.0
	
	var timer = Timer.new()
	timer.wait_time = tiempo_desaparecido
	timer.one_shot = true
	add_child(timer)
	
	boton.pressed.connect(_on_boton_ocultar_pressed.bind(poly_a, poly_b, poly_color, timer))
	timer.timeout.connect(_on_timer_timeout.bind(poly_a, poly_b))

func _on_boton_ocultar_pressed(poly_a: Polygon2D, poly_b: Polygon2D, poly_color: Polygon2D, timer: Timer):
	if not timer.is_stopped():
		return
	
	var esta_gris = esta_en_gris.get(poly_color, false)
	
	if poly_a and not esta_gris:
		poly_a.visible = false
		
	if poly_b:
		poly_b.visible = false
		
	timer.start()

func _on_timer_timeout(poly_a: Polygon2D, poly_b: Polygon2D):
	if poly_a: poly_a.visible = true
	if poly_b: poly_b.visible = true

# --- LÓGICA PARA CAMBIAR DE COLOR (NEGRO <-> GRIS) ---
func configurar_grupo_color(boton: Button, poly: Polygon2D):
	if not boton or not poly:
		return
		
	boton.modulate.a = 0.0
	poly.color = color_negro
	esta_en_gris[poly] = false
	
	boton.pressed.connect(_on_boton_color_pressed.bind(poly))

func _on_boton_color_pressed(poly: Polygon2D):
	esta_en_gris[poly] = !esta_en_gris[poly]
	
	if esta_en_gris[poly]:
		poly.color = color_gris
	else:
		poly.color = color_negro

# --- LÓGICA DE LA BARRA INFERIOR ---
func configurar_barra_inferior():
	if not barra_inferior or not escena_monitor:
		return
		
	# El monitor empieza oculto al arrancar el juego
	escena_monitor.visible = false
	
	# Detecta cada vez que el ratón entra en el área de la barra
	barra_inferior.mouse_entered.connect(_on_barra_mouse_entered)

func _on_barra_mouse_entered():
	escena_monitor.visible = !escena_monitor.visible
