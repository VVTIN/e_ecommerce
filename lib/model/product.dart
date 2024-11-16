import 'dart:convert';
import 'package:ecommerce/model/tag.dart';

class ProductModel {
  final int? id;
  final String name;
  final String description;
  final List<String> images;
  final List<Tag> tags; 
  final int? discount;

  ProductModel({
     this.id,
    required this.name,
    required this.description,
    required this.images,
    required this.tags,
    this.discount,
  });

  factory ProductModel.productFromJson(Map<String, dynamic> data) {
    return ProductModel(
      id: data['id'],
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      images: List<String>.from(data['images'].map((image) => image['url'])),
      tags: List<Tag>.from(data['tags'].map((tag) => Tag.fromJson(tag))),
      discount: data['discount'],
    );
  }
  // From JSON
  factory ProductModel.popularProductFromJson(Map<String, dynamic> data) {
    return ProductModel(
      id: data['id'],
      name: data['product']['name'] ?? '',
      description: data['product']['description'] ?? '',
      images: List<String>.from(data['product']['images'].map((image) => image['url'])),
      tags: [],
    );
  }

  factory ProductModel.promotionProductFromJson(Map<String, dynamic> data) {
    return ProductModel(
      id: data['id'],
      name: data['product']['name'] ?? '',
      description: data['product']['description'] ?? '',
      images: List<String>.from(data['product']['images'].map((image) => image['url'])),
      tags: [],
      discount: data['product']['discount'] ?? 0,
    );
  }


  // From Map
  factory ProductModel.fromMap(Map<String, dynamic> map) {
    return ProductModel(
      id: map['id'],
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      images: List<String>.from(map['images'].map((url) => url)),
      tags: List<Tag>.from(map['tags'].map((tag) => Tag.fromJson(tag))), 
      discount: map['discount'],
    );
  }

  // To Map
  Map<String, dynamic> toMap() {
    return {
    
      'name': name,
      'description': description,
      'images': images, 
      'tags': tags.map((tag) => tag.toJson()).toList(), 
      'discount': discount,
    };
  }
}

// Functions for parsing
List<ProductModel> popularProductFromJson(String value) {
  final decodedData = json.decode(value);
  return List<ProductModel>.from(
    decodedData['data'].map((product) => ProductModel.popularProductFromJson(product)),
  );
}

List<ProductModel> promotionProductFromJson(String value) {
  final decodedData = json.decode(value);
  return List<ProductModel>.from(
    decodedData['data'].map((product) => ProductModel.promotionProductFromJson(product)),
  );
}

List<ProductModel> productFromJson(String value) {
  final decodedData = json.decode(value);
  return List<ProductModel>.from(
    decodedData['data'].map((product) => ProductModel.productFromJson(product)),
  );
}
