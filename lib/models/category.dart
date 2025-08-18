class CategoryModel {
  final int id;
  final String name;
  final String? backgroundUrl;

  CategoryModel({required this.id, required this.name, this.backgroundUrl});

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'] as int,
      name: json['name'] as String,
      backgroundUrl: json['background_url'] as String?,
    );
  }
}

class CategoryResponse {
  final List<CategoryModel> categories;

  CategoryResponse({required this.categories});

  factory CategoryResponse.fromJson(Map<String, dynamic> json) {
    final List list = (json['categories'] as List? ?? const <dynamic>[]);
    final categories = list.map((e) => CategoryModel.fromJson(e as Map<String, dynamic>)).toList();
    return CategoryResponse(categories: categories);
  }
}

