extends Node

@export_range(1, 5) var nivel_juego: int = 1
@export var monitor: Node # ¡NUEVA VARIABLE! Para avisarle de los cambios

@export var umbral_por_nivel: Dictionary = {
	1: 16, 2: 13, 3: 10, 4: 7, 5: 4
}

var pos_animatronico_1: String = "cam1"
var pos_animatronico_2: String = "cam1"

func _ready():
	randomize() 
	
	var timer1 = Timer.new()
	timer1.wait_time = 10.0
	timer1.timeout.connect(_on_ia_1_timeout)
	add_child(timer1)
	timer1.start()
	
	await get_tree().create_timer(5.0).timeout
	
	var timer2 = Timer.new()
	timer2.wait_time = 10.0
	timer2.timeout.connect(_on_ia_2_timeout)
	add_child(timer2)
	timer2.start()

func supera_la_tirada() -> bool:
	return randi_range(0, 20) > umbral_por_nivel[nivel_juego]

func _on_ia_1_timeout():
	if supera_la_tirada():
		mover_animatronico_1()

func _on_ia_2_timeout():
	if supera_la_tirada():
		mover_animatronico_2()

func mover_animatronico_1():
	match pos_animatronico_1:
		"cam1": pos_animatronico_1 = "cam2"
		"cam2": pos_animatronico_1 = "cam5"
		"cam5": pos_animatronico_1 = "cam6" if randi_range(0, 1) == 0 else "cam7"
		"cam7": pos_animatronico_1 = "cam6"
		"cam6": pass
			
	print("Animatrónico 1 se movió a: ", pos_animatronico_1)
	avisar_al_monitor() # Actualiza la imagen en tiempo real si lo estás mirando

func mover_animatronico_2():
	match pos_animatronico_2:
		"cam1": pos_animatronico_2 = "cam2"
		"cam2": pos_animatronico_2 = "cam3"
		"cam3": pos_animatronico_2 = "cam4"
		"cam4": pass
			
	print("Animatrónico 2 se movió a: ", pos_animatronico_2)
	avisar_al_monitor() # Actualiza la imagen en tiempo real

# --- NUEVA FUNCIÓN ---
func avisar_al_monitor():
	if monitor and monitor.has_method("actualizar_imagen"):
		monitor.actualizar_imagen()
