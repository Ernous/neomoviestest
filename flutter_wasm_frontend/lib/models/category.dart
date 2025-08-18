class CategoryModel {
  const CategoryModel({required this.id, required this.name});
  final int id;
  final String name;

  factory CategoryModel.fromJson(Map<String, dynamic> json) => CategoryModel(
        id: (json['id'] as num).toInt(),
        name: json['name'] as String,
      );
}

