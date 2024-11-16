import 'dart:convert';

class Category {
  int? id;
  String name;
  String image;

  Category({
    this.id,
    required this.name,
    required this.image,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['image'] = image;
    return data;
  }

  factory Category.popularCategoryFromJson(Map<String, dynamic> data) =>
      Category(
        id: data['id'],
        name: data['category']['name'],
        image: data['category']['images']['url'],
      );

  factory Category.categoryFromJson(Map<String, dynamic> data) => Category(
        id: data['id'],
        name: data['name'],
        image: data['images']['url'],
      );
}

List<Category> popularCategoryFromJson(String value) => List<Category>.from(
      json.decode(value)['data'].map(
            (category) => Category.popularCategoryFromJson(category),
          ),
    );

List<Category> categoryFromJson(String value) => List<Category>.from(
      json.decode(value)['data'].map(
            (category) => Category.categoryFromJson(category),
          ),
    );
