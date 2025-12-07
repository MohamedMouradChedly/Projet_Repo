class Course {
  // -----------------------------
  // REQUIRED FIELDS
  // -----------------------------
  String id;
  String title;
  String description;
  double price;
  String photoAsset;
  DateTime createdAt;

  // -----------------------------
  // OPTIONAL / NEW FIELDS
  // -----------------------------
  String? videoAsset;       // Local mp4 video asset
  List<String>? chapters;   // Optional list of chapter names

  // -----------------------------
  // CONSTRUCTOR
  // -----------------------------
  Course({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.photoAsset,
    required this.createdAt,
    this.videoAsset,
    this.chapters,
  });

  // -----------------------------
  // TO MAP (FOR FIRESTORE OR JSON)
  // -----------------------------
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'price': price,
      'photoAsset': photoAsset,
      'createdAt': createdAt.toIso8601String(),
      'videoAsset': videoAsset,
      'chapters': chapters,
    };
  }

  // -----------------------------
  // FROM MAP (FOR FIRESTORE OR JSON)
  // -----------------------------
  factory Course.fromMap(Map<String, dynamic> map, String id) {
    return Course(
      id: id,
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      price: map['price'] != null
          ? (map['price'] is int
          ? (map['price'] as int).toDouble()
          : map['price'].toDouble())
          : 0.0,
      photoAsset: map['photoAsset'] ?? 'assets/images/im1.png',
      createdAt: map['createdAt'] != null
          ? DateTime.parse(map['createdAt'])
          : DateTime.now(),
      videoAsset: map['videoAsset'],
      chapters: map['chapters'] != null
          ? List<String>.from(map['chapters'])
          : [],
    );
  }

  // -----------------------------
  // OPTIONAL: String representation
  // -----------------------------
  @override
  String toString() {
    return 'Course(id: $id, title: $title, price: $price, chapters: $chapters)';
  }
}
