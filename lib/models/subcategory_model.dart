class SubCategoryModel {
  final String subCategoryId;
  final String subCategoryName;
  final String categoryId;
  final String categoryName;
  final String subCategoryImage;

  SubCategoryModel({
    required this.subCategoryId,
    required this.subCategoryName,
    required this.categoryId,
    required this.categoryName,
    required this.subCategoryImage,
  });

  factory SubCategoryModel.fromJson(
      Map<String, dynamic> json) {
    return SubCategoryModel(
      subCategoryId:
          json["sub_category_id"]?.toString() ?? "",
      subCategoryName:
          json["sub_category_name"]?.toString() ?? "",
      categoryId:
          json["category_id"]?.toString() ?? "",
      categoryName:
          json["category_name"]?.toString() ?? "",
      subCategoryImage:
          json["sub_category_image"]?.toString() ?? "",
    );
  }
}