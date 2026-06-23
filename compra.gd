class_name Compra
extends Node2D
## Gestiona toda la lógica de una compra, la creación de productos, su escaneo,
## su pago y su completación.

var cola_detencion:Array = []
var cantidad:int = 4 # variable que dependerá de cliente
var velocidad:float = 3.0 # ''
var posicion_inicial:Vector2 = Vector2.ZERO

@onready var inventario:Node2D = preload("res://main/supermercado/escenas/inventario.tscn").instantiate()
@onready var productos:Array = inventario.get_children()

func _ready() -> void:
	var cinta:Node2D = get_tree().get_first_node_in_group("cinta")
	var col_cinta:CollisionShape2D = cinta.get_node("colision") if cinta else null
	posicion_inicial = col_cinta.get_global_position() - col_cinta.shape.extents if col_cinta else Vector2.ZERO
	_invocar_compra()
	print(posicion_inicial)


func _invocar_compra() -> void:
	for i in range(cantidad):
		var producto:Node2D = productos[randi_range(0, productos.size() - 1)].duplicate()
		producto.global_position = posicion_inicial
		producto.producto_escaneado.connect(_on_producto_escaneado)
		add_child(producto)
		await get_tree().create_timer(velocidad).timeout


func _on_producto_escaneado(producto) -> void:
	if producto.escaneado:
		return
	producto.escaneado = true
	print(producto.propiedades)
