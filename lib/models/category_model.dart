class CategoryModel {
  final String categoryId;
  final String categoryName;
  final String categoryImage;

  CategoryModel({
    required this.categoryId,
    required this.categoryName,
    required this.categoryImage,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      categoryId: json["category_id"].toString(),
      categoryName: json["category_name"].toString(),
      categoryImage: json["category_image"].toString(),
    );
  }
}