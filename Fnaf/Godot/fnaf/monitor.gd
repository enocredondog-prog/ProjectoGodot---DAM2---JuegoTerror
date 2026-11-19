extends Node2D # Cambia a Control si tu raíz es Control

@export var ia_controlador: Node
@export var pantalla: TextureRect # Aquí va el fondo de la habitación
@export var capa_ani1: TextureRect # La nueva capa para el Animatrónico 1
@export var capa_ani2: TextureRect # La nueva capa para el Animatrónico 2
@export var botones: Array[Button]

@export_group("Imágenes y Posiciones")
@export var img_vacias: Array[Texture2D]

@export var img_ani1: Array[Texture2D]
@export var pos_ani1: Array[Vector2] # Coordenadas X, Y para cada cámara

@export var img_ani2: Array[Texture2D]
@export var pos_ani2: Array[Vector2] 

var camara_actual: int = 0

func _ready():
	for i in range(botones.size()):
		if botones[i]:
			botones[i].pressed.connect(_on_camara_seleccionada.bind(i))
	
	actualizar_imagen()

func _on_camara_seleccionada(indice: int):
	camara_actual = indice
	actualizar_imagen()

func actualizar_imagen():
	if not pantalla or img_vacias.size() == 0:
		return
		
	# 1. El fondo SIEMPRE muestra la habitación vacía
	if camara_actual < img_vacias.size() and img_vacias[camara_actual]:
		pantalla.texture = img_vacias[camara_actual]
		
	var nombre_cam = "cam" + str(camara_actual + 1)
	
	# 2. Gestionamos Animatrónico 1
	if capa_ani1:
		if ia_controlador and ia_controlador.pos_animatronico_1 == nombre_cam and img_ani1.size() > camara_actual and img_ani1[camara_actual]:
			capa_ani1.texture = img_ani1[camara_actual]
			capa_ani1.visible = true
			# Le asignamos la posición exacta que hayas puesto en el Inspector
			if pos_ani1.size() > camara_actual:
				capa_ani1.position = pos_ani1[camara_actual]
		else:
			capa_ani1.visible = false # Si no está en esta cámara, lo ocultamos
			
	# 3. Gestionamos Animatrónico 2
	if capa_ani2:
		if ia_controlador and ia_controlador.pos_animatronico_2 == nombre_cam and img_ani2.size() > camara_actual and img_ani2[camara_actual]:
			capa_ani2.texture = img_ani2[camara_actual]
			capa_ani2.visible = true
			if pos_ani2.size() > camara_actual:
				capa_ani2.position = pos_ani2[camara_actual]
		else:
			capa_ani2.visible = false
