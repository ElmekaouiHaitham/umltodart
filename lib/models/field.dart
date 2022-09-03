class Field {
  String name;
  String type;
  Field({required this.name, required this.type});

  @override
  String toString() {
    return "$name: $type";
  }
}
