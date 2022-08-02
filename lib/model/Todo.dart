class Todo{
  String? id;
  String fecha;
  String descripcion;
  String tipo;
  int activo;

  Todo(this.fecha, this.descripcion, this.tipo,this.activo);


  Todo.fromJson(Map<dynamic, dynamic> json)
      : id = json["id"],
        fecha = json['fecha'],
        descripcion = json['descripcion'],
        tipo = json['tipo'],
        activo = json['activo'];

  Map<dynamic, dynamic> toJson() => <dynamic, dynamic>{
    'id': id,
    'fecha': fecha,
    'descripcion': descripcion,
    'tipo': tipo,
    'activo': activo,
  };

}