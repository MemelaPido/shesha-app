class Vehicle {
  final int id;
  final String make;
  final String model;
  final int year;
  final String registration;
  final String colour;
  final String? photoPath;

  const Vehicle({
    required this.id,
    required this.make,
    required this.model,
    required this.year,
    required this.registration,
    required this.colour,
    this.photoPath,
  });

  String get displayName => '$make $model';

  Map<String, dynamic> toJson() => {
        'id': id,
        'make': make,
        'model': model,
        'year': year,
        'registration': registration,
        'colour': colour,
        'photo_path': photoPath,
      };
}
