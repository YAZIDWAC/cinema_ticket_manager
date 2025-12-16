class SalleModel {
  final String id;
  final String name;
  final int capacity;
  final bool is3D;
  final bool isIMAX;

  SalleModel({
    required this.id,
    required this.name,
    required this.capacity,
    required this.is3D,
    required this.isIMAX,
  });

  factory SalleModel.fromMap(String id, Map<String, dynamic> data) {
    return SalleModel(
      id: id,
      name: data['name'] ?? '',
      capacity: data['capacity'] ?? 0,
      is3D: data['is3D'] ?? false,
      isIMAX: data['isIMAX'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'capacity': capacity,
      'is3D': is3D,
      'isIMAX': isIMAX,
    };
  }
}
