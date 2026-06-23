extends Button

const TEMPORIZADOR = 2

var tecla:Key
var listo:bool = false
var timer_animation:float = 0.0

func _ready() -> void:
	timer_animation = TEMPORIZADOR
	var texto_tecla = texto_a_tecla()
	tecla = OS.find_keycode_from_string(texto_tecla)
	await get_tree().create_timer(TEMPORIZADOR).timeout
	listo = true


func _input(event: InputEvent) -> void:
	if event is InputEventKey:
		if event.pressed and event.keycode == tecla:
			button_pressed = true
		if not event.pressed and event.keycode == tecla:
			button_pressed = false


func texto_a_tecla():
	match text:
		"↑": return "Up"
		"↓": return "Down"
		"←": return "Left"
		"→": return "Right"
		"Espacio": return "Space"
	return text


func _process(delta:float) -> void:
	if button_pressed:
		modulate.a = 1.0
		return
	timer_animation -= delta
	modulate.a = timer_animation / TEMPORIZADOR 
