class Vehicle {
  const Vehicle({
    required this.name,
    required this.capacityTons,
    required this.plateNumber,
    required this.imageUrl,
    required this.description,
  });

  final String name;
  final int capacityTons;
  final String plateNumber;
  final String imageUrl;
  final String description;

  static const available = <Vehicle>[
    Vehicle(
      name: 'Colt Diesel',
      capacityTons: 2,
      plateNumber: 'B 9124 UXR',
      imageUrl: 'https://images.unsplash.com/photo-1601584115197-04ecc0da31d7?auto=format&fit=crop&w=640&q=85',
      description: 'Lincah untuk pengiriman dalam kota',
    ),
    Vehicle(
      name: 'Fuso',
      capacityTons: 8,
      plateNumber: 'B 8742 PXT',
      imageUrl: 'https://images.unsplash.com/photo-1519003722824-194d4455a60c?auto=format&fit=crop&w=640&q=85',
      description: 'Andalan distribusi antarkota',
    ),
    Vehicle(
      name: 'Tronton',
      capacityTons: 15,
      plateNumber: 'B 6631 KZA',
      imageUrl: 'https://images.unsplash.com/photo-1592838064575-70ed626d3a0e?auto=format&fit=crop&w=640&q=85',
      description: 'Kapasitas besar untuk muatan berat',
    ),
  ];
}
