extends Label

const MENSAJES:Array = [
	"Felicidades",
	"Auch",
	"No era tan difícil, ¿verdad?",
	"¿Estás feliz?",
	"Adiós",
	"",
	]

@onready var subtitulo = $Label

func _ready() -> void:
	subtitulo.text = MENSAJES[randi() % MENSAJES.size()]
