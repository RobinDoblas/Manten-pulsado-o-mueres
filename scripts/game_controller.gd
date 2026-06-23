extends Node

signal fin_juego_signal

const NUMERO_TECLAS:int = 10
const MARGEN:int = 15
const MAX_CONTADOR_MENSAJES = 20
const VELOCIDAD_MENSAJES:float = 0.02
const DECREMENTO_VELOCIDAD_TECLAS = 0.1
const TIMER_FINAL:float = 1.8

var velocidad:float = 2.0
var botones:Array = []
var juego_parado:bool = false
var contador_mensajes:int = 0

@onready var boton_scene:Button = preload("res://scenes/botón.tscn").instantiate()
@onready var fin_juego_label:Label = preload("res://scenes/END.tscn").instantiate()
@onready var intro_label:Label = $"../Label"
@onready var mensaje_label:Label = preload("res://scenes/mensajes.tscn").instantiate()
@onready var ventana_size = get_viewport().get_visible_rect().size
@onready var audio = $"../AudioStreamPlayer2D"
@onready var audio_tren = $"../AudioStreamPlayer2D2"


func _ready() -> void:
	connect("fin_juego_signal", fin_juego)
	

func _input(event: InputEvent) -> void:
	if intro_label and event is InputEventMouseButton and event.pressed:
		intro_label.queue_free()
		intro_label = null
		audio.play()
		poner_audio_tren()
		generar_botones()
		while not juego_parado:
			generar_mensajes()
			await get_tree().create_timer(VELOCIDAD_MENSAJES).timeout
	
	
func generar_botones() -> void:
	for i in range(NUMERO_TECLAS):
		await get_tree().create_timer(velocidad).timeout
		if juego_parado:
			return
		crear_boton()
		velocidad -= DECREMENTO_VELOCIDAD_TECLAS


func generar_mensajes() -> void:
	if juego_parado:
		return
	var mensaje:Label = mensaje_label
	var posicion:Vector2 = posicion_random(mensaje)
	mensaje.global_position = posicion
	if contador_mensajes >= MAX_CONTADOR_MENSAJES:
		mensaje.text = mensaje.MENSAJES[randi() % mensaje.MENSAJES.size()]
		contador_mensajes = 0
	else:
		contador_mensajes += 1
	if not get_node_or_null("mensaje_node"):
		mensaje.name = "mensaje_node"
		add_child(mensaje)


func crear_boton() -> void:
	var boton:Button = boton_scene.duplicate()
	var tecla_texto:String = tecla_random()
	for btn in botones:
		if btn.text == tecla_texto:
			crear_boton()
			return
	boton.text = tecla_texto
	var posicion:Vector2 = posicion_random(boton)
	boton.global_position = posicion
	botones.append(boton)
	add_child(boton)


func tecla_random():
	const TECLAS = ["A","B","C","D","E","F","G","H","I","J","K","L","M",
	"N","O","P","Q","R","S","T","U","V","W","X","Y","Z",
	"↑","↓","←","→", 
	"Espacio","Shift","Ctrl","Alt",]
	
	return TECLAS[randi() % TECLAS.size()]


func posicion_random(elemento):
	var x = randi() % int(ventana_size.x - elemento.size.x - 2 * MARGEN) + MARGEN
	var y = randi() % int(ventana_size.y - elemento.size.y - 2 * MARGEN) + MARGEN
	return Vector2(x, y)


func _process(_delta: float) -> void:
	if juego_parado:
		return
	for boton in botones:
		if boton.listo and not boton.button_pressed:
			fin_juego_signal.emit()


func fade_out() -> void:
	var volumen_inicial = audio.volume_db
	while audio.volume_db > -80:
		audio.volume_db -= 1
		await get_tree().create_timer(0.05).timeout
	audio.stop()
	audio.volume_db = volumen_inicial
	

func poner_audio_tren() -> void:
	while not juego_parado:
		await get_tree().create_timer(2).timeout
		audio_tren.play(5.3)
		await get_tree().create_timer(5.47).timeout
		audio_tren.stop()
	

func fin_juego():
	juego_parado = true
	fade_out()
	var mensaje_node = get_node_or_null("mensaje_node")
	if mensaje_node:
		mensaje_node.queue_free()
	for boton in botones:
		boton.queue_free()
	botones.clear()
	add_child(fin_juego_label)
	await get_tree().create_timer(TIMER_FINAL).timeout
	get_tree().quit()
