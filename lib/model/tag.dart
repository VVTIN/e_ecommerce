class Tag {
  final int id;            
  final String title;    
  final double price;     

  Tag({
    required this.id,
    required this.title,
    required this.price,
  });

  factory Tag.fromJson(Map<String, dynamic> data) {
    return Tag(
      id: data['id'] ?? 0, 
      title: data['title'] ?? '', 
      price: (data['price'] is num) ? data['price'].toDouble() : 0.0, 
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'price': price,
    };
  }
}
